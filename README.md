## Terraform Lab

This repository contains Terraform configurations used for AWS infrastructure labs and DevOps practice.
## IAM Security Hardening

The Terraform lab uses GitHub Actions with AWS OIDC authentication and separate CI and deployment IAM roles.

### Completed

- Removed broad AWS-managed ReadOnlyAccess permissions from GitHub Actions roles.
- Configured scoped EC2 read permissions and Terraform S3 state access.
- Restricted dev deployment EC2 write permissions to the us-east-1 region.
- Verified the IAM region restriction using AWS policy simulation:
  - us-east-1: ec2:CreateVpc allowed.
  - us-west-2: ec2:CreateVpc implicitly denied.

### In Progress

- Enforce Project and Environment tags during resource creation.
- Restrict EC2 resource modification and deletion permissions.
- Protect security-boundary tags from unauthorized changes.
- Validate least-privilege policies before deploying the dev infrastructure.

Unfinished IAM tag-boundary changes are maintained separately from the main branch.
