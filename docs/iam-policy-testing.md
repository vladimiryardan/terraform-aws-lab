
# AWS IAM Policy Testing Guide

## Overview

This guide documents the security validation process for the
Terraform AWS Lab deployment role.

The objective is to enforce least-privilege access while
maintaining functional Terraform CI/CD deployments.

## Security Configuration

- Authentication: GitHub Actions OIDC
- Deployment environment: dev
- Allowed AWS region: us-east-1
- Deployment role: terraform-github-actions-deploy-dev
- Infrastructure management: Terraform
- Remote state: Amazon S3

## Prerequisites

- AWS CLI configured
- Valid AWS CLI profile
- Permission to execute iam:SimulatePrincipalPolicy
- Terraform installed
- Access to the GitHub repository

Configure the AWS CLI profile and retrieve the account ID:

```bash
export AWS_PROFILE=terraform-lab

ACCOUNT_ID=$(aws sts get-caller-identity \
  --query Account \
  --output text)

ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/terraform-github-actions-deploy-dev"
```

## Test 1: Allowed Region

Verify that VPC creation is permitted in us-east-1.

```bash
aws iam simulate-principal-policy \
  --policy-source-arn "$ROLE_ARN" \
  --action-names ec2:CreateVpc \
  --resource-arns "*" \
  --context-entries \
  ContextKeyName=aws:RequestedRegion,ContextKeyValues=us-east-1,ContextKeyType=string \
  --query 'EvaluationResults[].{Action:EvalActionName,Decision:EvalDecision}' \
  --output table
```

Expected result: `allowed`

Historical test result: PASS

## Test 2: Restricted Region

Verify that VPC creation is not permitted in us-west-2.

```bash
aws iam simulate-principal-policy \
  --policy-source-arn "$ROLE_ARN" \
  --action-names ec2:CreateVpc \
  --resource-arns "*" \
  --context-entries \
  ContextKeyName=aws:RequestedRegion,ContextKeyValues=us-west-2,ContextKeyType=string \
  --query 'EvaluationResults[].{Action:EvalActionName,Decision:EvalDecision}' \
  --output table
```

Expected result: `implicitDeny`

Historical test result: PASS

## Test Results

| Test | Expected | Actual | Status |
|---|---|---|---|
| CreateVpc in us-east-1 | allowed | allowed | PASS |
| CreateVpc in us-west-2 | implicitDeny | implicitDeny | PASS |

These results were recorded before the planned tag-based
IAM restrictions were deployed.

## Planned Tag-Based Security Tests

The following tests are pending implementation and validation.

Required resource tags:

- Project: terraform-lab
- Environment: dev
- ManagedBy: Terraform

| Test Scenario | Target Result |
|---|---|
| Create VPC with correct security tags | allowed |
| Create VPC without Project tag | denied |
| Create VPC without Environment tag | denied |
| Create VPC with incorrect Project tag | denied |
| Create VPC with Environment=prod | denied |
| Modify unrelated existing resources | denied |
| Remove protected security tags | denied |
| Modify protected security tags | denied |
| Update permitted tags on dev resources | allowed |

Future simulations must include appropriate resource ARNs,
request tags, resource tags, and other required context keys.

## Policy Simulation Limitations

IAM policy simulation does not create AWS resources.

However, simulation does not guarantee that an actual
Terraform deployment will succeed.

Additional authorization requirements may include:

- Resource-specific IAM permissions
- Tag-on-create authorization
- Multiple resource authorization for RunInstances
- Service control policies
- Permissions boundaries
- Required IAM context keys

A successful Terraform plan does not validate every
permission required by Terraform apply or destroy.

## Deployment Validation Process

1. Modify Terraform IAM configuration in a feature branch.
2. Run Terraform formatting and validation.
3. Review the Terraform plan.
4. Create a pull request.
5. Wait for all required CI checks.
6. Review and merge the pull request.
7. Apply the reviewed IAM changes.
8. Run IAM policy simulations.
9. Test an actual dev deployment when authorized.
10. Destroy temporary lab infrastructure after testing.

## Current Security Status

- OIDC authentication: Implemented
- Separate CI and deployment roles: Implemented
- Broad ReadOnlyAccess removal: Completed
- Region-based write restrictions: Verified
- Request-tag restrictions: In progress
- Resource-tag restrictions: Pending
- Protected-tag enforcement: Pending
- Full least-privilege deployment validation: Pending

## References

- https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/supported-iam-actions-tagging.html
- https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonec2.html
