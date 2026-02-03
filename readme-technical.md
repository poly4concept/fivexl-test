## FivexL Terraform Website Hosting Challenge

This repository demonstrates **two production-oriented approaches** to hosting a simple website on AWS using Terraform. The focus is on **clarity, sound architectural choices, and reusability across multiple AWS accounts**, rather than showcasing the maximum number of AWS services.

The two approaches intentionally represent the most common ends of the spectrum for website hosting on AWS:

* **Approach 1 – Static website**: S3 + CloudFront + Route53
* **Approach 2 – Containerized website**: ECS Fargate + ALB + Route53

The same Terraform modules are reused across environments (e.g. `dev` and `prod`) through environment-specific configuration, demonstrating how a single codebase can support multi-account deployments.

---

## 1. What was built

### Core infrastructure

* **Remote Terraform state** stored in S3 with state locking enabled with native s3 lock (configured per environment).
* **Environment isolation** using separate directories for `dev` and `prod`, each with its own backend and variable values.

### Static website stack (S3 + CloudFront)

* Private S3 bucket to store static site content.
* CloudFront distribution using **Origin Access Control (OAC)** to ensure the bucket is not publicly accessible.
* Route53 alias record pointing a custom domain to the CloudFront distribution.
* Terraform-managed upload of `site/index.html`.
* Automatic CloudFront invalidation when static content changes.

### Containerized website stack (ECS Fargate)

* Minimal VPC with public subnets to keep the example self-contained.
* ECS Fargate cluster, task definition, and service.
* Application Load Balancer (ALB) fronting the ECS service.
* Route53 alias record pointing a custom domain to the ALB.
* HTML content assumed to be baked into the container image; updating the image tag triggers a rolling deployment.

---

## 2. Hosting approaches explained

### Static website: S3 + CloudFront

* Static files are stored in a **private** S3 bucket.
* CloudFront serves content globally and securely using Origin Access Control.
* Route53 provides DNS alias records (`A` / `AAAA`) mapping a custom subdomain (e.g. `static-dev.example.com`) to the CloudFront distribution.
* Terraform manages the lifecycle of the static content and ensures cache invalidation when files change.

This approach minimizes operational overhead while providing excellent performance and scalability.

---

### Containerized website: ECS Fargate + ALB

* A small VPC with two public subnets hosts the ALB and ECS tasks.
* ECS Fargate runs a single-container task definition (for example, an Nginx image serving static HTML baked into the image).
* The ALB exposes HTTP traffic on port 80 and forwards requests to the ECS service.
* Route53 maps a subdomain (e.g. `app-dev.example.com`) to the ALB using an alias record.

This models a more application-like deployment where server-side logic, custom runtimes, or dynamic content may be required.

---

## 3. Why these two approaches

### S3 + CloudFront

* Canonical AWS solution for static site hosting.
* Extremely low operational overhead and cost-effective.
* Automatically scalable and highly available.
* Well-suited for marketing sites, documentation, and static frontends.

### ECS Fargate + ALB

* Represents a modern container-based deployment model.
* Suitable for applications that require dynamic behavior or custom runtimes.
* Demonstrates stable endpoints with rolling deployments and no downtime.

Together, these approaches cover the most common real-world website hosting patterns on AWS.

---

## 4. Why not EC2, Elastic Beanstalk, or Amplify?

### EC2-based hosting

* Requires managing instances, AMIs, scaling groups, and OS patching.
* Higher operational burden compared to S3/CloudFront or Fargate.
* Less cost-efficient for simple website workloads.

### Elastic Beanstalk

* Adds an opinionated abstraction layer on top of EC2, ALB, and ASGs.
* Can obscure important infrastructure details.
* Less flexible when integrating into modular, Terraform-driven platforms.

### AWS Amplify Hosting

* Excellent for frontend-centric teams and tight Git integration.
* Highly opinionated and abstracts away core infrastructure primitives.
* Less suitable for a challenge focused on demonstrating Terraform and AWS fundamentals.

---

## 5. Auto-redeployment mechanisms

### Static site (S3 + CloudFront)

* `site/index.html` is managed as an `aws_s3_object` resource.
* The object `etag` is derived from the file’s MD5 hash.
* A `null_resource` with `local-exec` triggers a CloudFront invalidation:

  * `aws cloudfront create-invalidation --distribution-id <id> --paths '/*'`
* When the file changes:

  * Terraform updates the S3 object.
  * The invalidation runs automatically, ensuring users receive updated content.

### Container site (ECS Fargate)

* The ECS module accepts an `image_url` (typically an ECR image with a tag).
* HTML content is baked into the image during the CI build process.
* When the image tag changes:

  * Terraform creates a new task definition revision.
  * The ECS service updates to the new revision.
  * ECS performs a rolling deployment behind the ALB.

In both cases, **DNS names and endpoints remain stable** while content is updated underneath.

---

## 6. Multi-account deployments

### Directory structure

* `environments/dev`
* `environments/prod`

Each environment contains:

* `backend.tf` – Remote state configuration.
* `main.tf` – Module composition and resource definitions.
* `variables.tf` – Declared inputs.
* `terraform.tfvars` – Environment-specific values.

### Provider configuration

* AWS provider settings are supplied via variables and standard AWS environment variables.
* **No account IDs are hardcoded**.
* The same Terraform code can be deployed to any AWS account where:

  * The Terraform state backend exists.
  * The required Route53 hosted zone is available.

### Environment-specific parameters

Examples include:

* AWS region
* Domain name and hosted zone ID
* Subdomain names for static and containerized sites
* ECS image URL and service sizing (CPU, memory, desired count)

---

## 7. Deployment workflow

### Prerequisites

* Terraform 1.10.x
* AWS CLI configured with sufficient permissions to manage:

  * S3, DynamoDB (state backend)
  * Route53, ACM, CloudFront
  * ECS and ALB
* Pre-existing:

  * S3 bucket for Terraform state
  * DynamoDB table for state locking
  * Route53 hosted zone

### Deploying an environment

```bash
cd environments/dev

terraform init
terraform plan
terraform apply
```

The same steps apply for `prod`, using its own environment directory and variable values.

---

## 8. Trade-offs and future improvements

### TLS / ACM

* TLS is intentionally kept minimal for clarity.
* In a production system, I would:

  * Fully automate ACM certificate issuance and DNS validation.
  * Enforce HTTPS-only access and HSTS.

### Networking

* The ECS stack includes its own minimal VPC for self-containment.
* In larger environments, networking would typically be managed separately and shared across services.

### Container build pipeline

* This repository assumes an external CI pipeline builds and pushes container images.
* A more complete example could include:

  * A Dockerfile and application source.
  * Automated ECR builds triggered by changes in application code or static assets.


### Observability and security

* Logging, alarms, WAF, and advanced security controls are omitted for brevity.
* In production, I would typically add:

  * CloudFront, ALB, and ECS logging
  * Availability and latency alarms
  * WAF and security monitoring integrations