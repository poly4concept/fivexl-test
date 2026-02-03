# FivexL – Terraform Website Hosting Challenge

Hello FivexL team 👋  
Thank you for taking the time to review my submission.

This repository contains my solution to the **Terraform Website Hosting Challenge**, with a focus on:

- Clear architectural decision-making
- Production-oriented Terraform design
- Multi-account deployments
- Automation and cost awareness

---

## How this repository is structured

This repository contains **two branches**, each with a specific purpose.

### 1. `main` branch — **Primary review target**

This is the main submission and the branch I recommend reviewing first.

It contains:
- Two AWS website-hosting approaches implemented in Terraform:
  - **Static site:** S3 + CloudFront + Route53
  - **Container site:** ECS Fargate + ALB + Route53
- Multi-environment (`dev` / `prod`) support using remote Terraform state
- Clear separation of concerns and reusable modules
- Explicit trade-offs and production-oriented assumptions

📄 **Start here:**  
👉 [`readme-technical.md`](./readme-technical.md)

---

### 2. `demo-cloudfront-only` branch — *Optional automation demo*

This branch contains a **minimal, cost-controlled demo** focused purely on:

- Terraform automation
- GitHub Actions workflows
- Safe deploy and teardown patterns

It intentionally avoids:
- Custom domains
- Route53 records
- TLS / ACM complexity

This allows the automation to be demonstrated without requiring domain ownership from reviewers.

📄 **Optional read:**  
👉 [`readme-demo.md`](./readme-demo.md)

---

## Recommended review flow

If you are short on time:

1. Review the **`main` branch**
2. Read **`readme-technical.md`**
3. Skim Terraform modules and environment structure

If you have extra time and are curious about automation patterns:

4. Review the **`demo-cloudfront-only` branch**
5. Read **`readme-demo.md`**
6. Look at the GitHub Actions workflows and execution proof

---

## Notes

- The `main` branch reflects how I would approach this challenge in a real consulting engagement.
- The demo branch exists purely to make automation observable while keeping cost and risk low.

Thank you again for your time and consideration.