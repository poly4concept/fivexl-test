## FivexL Terraform Website Hosting Challenge

This repository implements two different approaches to hosting a simple website on AWS using Terraform, with a focus on **clarity, production thinking, and multi-account support** rather than using as many services as possible.

- **Approach 1 – Static site:** S3 + CloudFront + Route53  
- **Approach 2 – Container site:** ECS Fargate + ALB + Route53  

The same Terraform code can be used to deploy into multiple AWS accounts (for example, `dev` and `prod`) by using separate environment directories with different backend and variable configuration.

---

### 1. What was built

- **Remote Terraform backend** using S3 with state locking (configured per environment).
- **Static website stack**:
  - Private S3 bucket for content.
  - CloudFront distribution with Origin Access Control (OAC).
  - Route53 alias record for a custom domain.
  - Terraform-managed upload of `site/index.html` and CloudFront invalidation on content changes.
- **Container website stack**:
  - Minimal VPC with public subnets.
  - ECS Fargate cluster, task definition, and service fronted by an Application Load Balancer.
  - Route53 alias record to the ALB.
  - HTML content assumed to be baked into the container image; changing the image tag creates a new task definition and triggers a rolling deployment.
- **Environment separation**:
  - `environments/dev` and `environments/prod` with their own remote backends and variables.
- **Basic CI**:
  - GitHub Actions workflow to run `terraform fmt` and `terraform validate`.

---

### 2. Hosting approaches explained

- **S3 + CloudFront static site**
  - A private S3 bucket stores the static files.
  - CloudFront serves the content using an Origin Access Control, so the bucket is **not** publicly accessible.
  - Route53 provides a DNS alias (`A`/`AAAA` records) mapping a custom domain (e.g. `static-dev.example.com`) to the CloudFront distribution.
  - Terraform uploads `site/index.html` to S3 and invalidates CloudFront on change so users see updates quickly.

- **ECS Fargate + ALB container site**
  - A simple VPC with two public subnets hosts the ALB and Fargate tasks.
  - ECS Fargate runs a single-container task definition (typically an nginx or similar image that serves static HTML baked into the image).
  - The ALB exposes HTTP on port 80 and routes traffic to the ECS service.
  - Route53 maps a second subdomain (e.g. `app-dev.example.com`) to the ALB using an alias record.

---

### 3. Why these two approaches

- **S3 + CloudFront**:
  - This is the canonical approach for low-cost, highly-available static site hosting on AWS.
  - It scales automatically, has very low operational overhead, and integrates cleanly with Route53 and ACM.
  - It is appropriate for marketing sites, documentation, and any static content.

- **ECS Fargate + ALB**:
  - This models a more application-like deployment using containers.
  - It is suitable when you need dynamic server-side logic, custom runtimes, or more complex routing than a purely static site.
  - It demonstrates how HTML (or a full web app) can be baked into a container image and deployed behind a load balancer with stable DNS.

These two options cover the **static** and **containerized application** ends of the spectrum, which are the most common choices in modern AWS architectures.

---

### 4. Why not EC2, Elastic Beanstalk, or Amplify?

- **EC2 with a web server**:
  - Would require managing instances, AMIs, scaling groups, and OS patching.
  - Higher operational overhead and less cost-efficient for simple websites compared to S3/CloudFront or Fargate.

- **Elastic Beanstalk**:
  - Provides abstractions on top of EC2/ALB/ASG but hides some operational details.
  - Less aligned with modern container-centric workflows where ECS/Fargate or EKS are preferred.
  - Adds its own opinionated layer that can be harder to integrate into a modular Terraform codebase.

- **AWS Amplify Hosting**:
  - Great for front-end heavy apps with tight Git integration.
  - More opinionated and less “infrastructure-centric” from a consulting perspective.
  - This challenge is focused on demonstrating core AWS building blocks via Terraform, which Amplify abstracts away.

---

### 5. Auto-redeployment mechanisms

- **Static site (S3 + CloudFront)**
  - `site/index.html` is managed by Terraform as an `aws_s3_object` in the environment configuration.
  - The S3 object’s `etag` is tied to the local file’s MD5 hash.
  - A `null_resource` with a `local-exec` provisioner uses the AWS CLI to run:
    - `aws cloudfront create-invalidation --distribution-id <id> --paths '/*'`
  - When `index.html` changes:
    - Terraform updates the S3 object.
    - The `null_resource` detects the change (via its `triggers`) and automatically issues a CloudFront invalidation.

- **Container site (ECS Fargate + ALB)**
  - The module accepts an `image_url` (e.g. an ECR image URI with a tag).
  - HTML and assets are assumed to be baked into that image by your CI pipeline (e.g. Dockerfile copies `site/index.html` into the container).
  - When the `image_url` (usually the tag) changes, Terraform:
    - Creates a new ECS task definition revision.
    - Updates the ECS service to use the new task definition.
    - ECS performs a rolling deployment behind the ALB, preserving the same DNS name and ALB endpoint.

In both cases, **user-facing endpoints remain stable**; only the underlying content or task definitions change.

---

### 6. Multi-account deployments

- **Directory structure**
  - `environments/dev` and `environments/prod` each contain their own:
    - `backend.tf` – S3 remote state configuration.
    - `main.tf` – Core resources and module instantiation.
    - `variables.tf` – Environment-specific variables.
    - `terraform.tfvars` – Concrete values for that environment.

- **Provider configuration**
  - The AWS provider is configured using region and (optionally) profile, supplied via variables and/or the standard AWS environment variables.
  - **Account IDs are never hardcoded**. The same Terraform code can run in any account where:
    - The remote state bucket table exist.
    - The appropriate Route53 hosted zone is available.

- **Environment-specific parameters**
  - Examples:
    - `aws_region`
    - `domain_name` (e.g. `dev.example.com` vs `example.com`)
    - `hosted_zone_id`
    - Subdomain names for the static and ECS sites.
    - ECS image URL and service sizing (CPU/memory/desired count).

By changing only `terraform.tfvars` (and the remote backend config), the same modules are reused across dev and prod without duplication.

---

### 7. How to deploy dev vs prod

#### Prerequisites

- Terraform 1.x installed.
- AWS CLI installed and configured with credentials able to:
  - Access the target AWS account.
  - Read/write the S3 state bucket and DynamoDB locking table.
  - Manage Route53, ACM, CloudFront, ECS, and ALB resources.
- Pre-created:
  - S3 bucket for Terraform state (one per environment or shared with prefixes).
  - Route53 hosted zone for the chosen domain(s).

#### Deploying the `dev` environment

```bash
cd environments/dev

# Initialize Terraform with the remote backend
terraform init

# Review the plan
terraform plan

# Apply the changes
terraform apply
```

Once complete, Terraform will output the static and ECS site endpoints (domains); DNS records will already be in place via Route53.

#### Deploying the `prod` environment

```bash
cd environments/prod

terraform init
terraform plan
terraform apply
```

The prod environment uses its own backend configuration and `terraform.tfvars`, but otherwise relies on the **same modules and Terraform code**.

---

### 8. Tradeoffs and future improvements

- **TLS / ACM**
  - For brevity, TLS is configured in a minimal way (or assumed to be provided via an ACM certificate ARN).
  - In a production system, I would:
    - Automate ACM certificate issuance and DNS validation (for both CloudFront in `us-east-1` and ALB in the workload region).
    - Enforce HTTPS-only access and HSTS.

- **Networking**
  - The ECS module creates a small VPC with public subnets to keep the example self-contained.
  - In a larger environment, VPCs, subnets, and shared networking would be managed by dedicated modules or a centralized network stack, with ECS consuming existing infrastructure.

- **Content build and containerization**
  - For the ECS site, this repository assumes a CI pipeline builds and pushes a container image that includes the HTML content.
  - A more complete setup would:
    - Include a Dockerfile and application code.
    - Add CI steps to build/push images to ECR based on changes in `site/` or application code.

- **State and bootstrap**
  - The S3 bucket for Terraform state are assumed to exist.
  - In a real engagement, you might:
    - Provide a separate “bootstrap” Terraform configuration to create and manage state infrastructure.
    - Enforce encryption, bucket lifecycle policies, and access controls as organizational standards.

- **Observability and operations**
  - For clarity, this example omits CloudWatch alarms, logging configuration details, WAF, and advanced security controls.
  - In production, I would typically:
    - Enable detailed logs for CloudFront, ALB, and ECS.
    - Add monitoring/alerting on availability and latency.
    - Integrate with organizational security tooling (WAF, GuardDuty, Security Hub).


