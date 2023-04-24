# Terraform templates (CIS benchmarks)

## 1. Amazon S3

- Enable versioning
- Enable default encryption
- Enable logging
- Enable MFA Delete
- Set up a lifecycle policy for incomplete multipart uploads
- Apply appropriate bucket policies and access control lists (ACLs)

## 2. AWS Identity and Access Management (IAM)

- Apply least privilege access policies
- Use IAM roles for EC2 instances
- Rotate access keys regularly
- Enable MFA for all users
- Use groups to assign permissions
- Enable AWS IAM password policies

## 3. Amazon EC2

- Use security groups to restrict inbound and outbound traffic
- Use VPC flow logs
- Enable AWS Config
- Enable AWS CloudTrail
- Enable AWS GuardDuty
- Regularly monitor and patch instances

## 4. Amazon RDS

- Encypt RDS instances
- Enable automated backups
- Enable logging and monitoring
- Restrict network access using security groups
- Enable IAM authentication

## 5. AWS VPC

- Use dedicated VPCs for each environment (e.g, development, staging, production)
- Use network Access Control Lists (NACLs) to restrict traffic
- Enable VPC Flow Logs
- Use NAT gatrways for outbound traffic from private subnets

## 6. AWS CloudTrail

- Enable CloudTrail in all regions
- Enable log file validation
- Encrypt log files at rest
- Integrate with AWS CloudWatch

## 7. Amazon CloudWatch

- Enable CloudWatch Logs and Metrics
- Set up CloudWatch Alarms for critical events
- Monitor AWS trusted Advisor findings

## 8. AWS Config

- Enable AWS Config in all regions
- Record all resource types
- Enable AWS Config rules to enforce compliance

## 9. AWS Lambda

- Use least privilege IAM roles
- Enable function-level monitoring
- Encrypt environment variables

## 10. AWS KMS

- Use customer-managed KMS keys
- Enable key rotation
- Use IAM policies to control access to KMS keys
