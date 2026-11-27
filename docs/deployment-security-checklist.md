# Terraform Deployment Security Checklist

## 1. Pre-Deployment Checks

- [ ] Confirm the correct AWS account.
- [ ] Confirm the intended AWS region.
- [ ] Verify the target environment.
- [ ] Confirm the Git working tree is clean.
- [ ] Ensure sensitive files are excluded from Git.
- [ ] Verify Terraform remote state configuration.
- [ ] Confirm state locking is enabled.

## 2. IAM and Authentication

- [ ] Use GitHub Actions OIDC authentication.
- [ ] Avoid long-lived AWS access keys in GitHub.
- [ ] Verify separate CI and deployment IAM roles.
- [ ] Review permissions against least-privilege principles.
- [ ] Verify deployment region restrictions.
- [ ] Test IAM policies before deployment.

## 3. Network Security

- [ ] Verify VPC and subnet CIDR ranges.
- [ ] Restrict SSH access to authorized IP addresses.
- [ ] Review security group ingress and egress rules.
- [ ] Avoid unnecessary public exposure.
- [ ] Confirm route table configuration.

## 4. Terraform Validation

- [ ] Run terraform fmt -check.
- [ ] Run terraform validate.
- [ ] Generate and review the Terraform plan.
- [ ] Investigate unexpected resource replacements.
- [ ] Confirm no unintended resources will be destroyed.

## 5. CI/CD Approval

- [ ] Create a dedicated feature branch.
- [ ] Submit a pull request.
- [ ] Confirm all required CI checks pass.
- [ ] Review the infrastructure changes.
- [ ] Merge only approved changes.
- [ ] Apply only the reviewed deployment plan.

## 6. Post-Deployment Verification

- [ ] Verify provisioned AWS resources.
- [ ] Confirm resource tags.
- [ ] Verify network connectivity.
- [ ] Confirm Terraform state consistency.
- [ ] Review deployment logs.
- [ ] Monitor AWS resource costs.

## 7. Lab Cleanup

- [ ] Review the Terraform destroy plan.
- [ ] Remove temporary lab infrastructure.
- [ ] Preserve the remote state bucket.
- [ ] Preserve required IAM and OIDC resources.
- [ ] Verify no unintended billable resources remain.

## Security Policy

Never bypass failed CI checks, disable state locking,
or deploy unreviewed infrastructure changes.

A successful Terraform plan does not guarantee that
all deployment permissions are correctly configured.

This checklist defines recommended deployment controls.
It does not imply that every control has been implemented.
