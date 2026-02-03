# Demo Deployment (Automation Showcase)
You can access the demo website on this [link](https://d2ra6veurbz5fd.cloudfront.net/)

> **Purpose:** This document explains the *minimal demo branch* used to showcase CI/CD automation and Terraform workflows, while intentionally keeping **cost, complexity, and external dependencies** low.

This demo exists to complement the main Terraform submission on the `main` branch.  
The `main` branch remains the **primary review target** for architecture, Terraform quality, and design decisions.

---

## Why a separate demo branch exists

The full solution on the `main` branch includes:
- Route53 records
- Custom domains
- TLS / ACM considerations
- Multiple AWS services working together

While this reflects a realistic production setup, it introduces two practical issues for a short-lived review scenario:

1. **Cost control** – DNS records, certificates, and long-lived resources are unnecessary for a demo.
2. **Reviewer accessibility** – reviewers should be able to *observe* automation without needing AWS credentials or domain ownership.

To address this, the `demo-cloudfront-only` branch contains a **minimal, production-aligned subset** of the solution:

- Static website hosted on **S3 + CloudFront**
- No Route53 records
- No custom domains
- Uses the default CloudFront distribution domain

This keeps the demo:
- Cheap
- Fast to deploy
- Easy to reason about
- Focused purely on Terraform behavior and automation

---

## What this demo demonstrates

This branch is designed to demonstrate:

- Infrastructure provisioning using Terraform
- Remote Terraform state usage
- Automated deployment via GitHub Actions
- Explicit teardown via a destroy workflow
- Stable endpoints (CloudFront domain remains unchanged across redeployments)


---

## CI/CD workflows

Two GitHub Actions workflows are defined in this branch:

### Deploy demo infrastructure
- Provisions the S3 + CloudFront stack using Terraform
- Uploads static site content
- Outputs the CloudFront distribution URL

### Destroy demo infrastructure
- Destroys all Terraform-managed resources
- Ensures no ongoing AWS cost after review


---

## Cost and cleanup considerations

Although reviewers are not expected to run the workflows themselves, cost awareness was a core design goal:

- A dedicated **destroy workflow** exists and is always run after demo validation
- The demo stack contains only essential resources

This reflects a consulting principle I follow consistently:  
**automation should make the safe path the easy path.**

---

Both branches follow the same design principles; the demo branch simply optimizes for safe, observable execution.
