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
- Access keys for IAM users should be rotated every 90 days or less
- IAM password policy requires minimum password length of 14 or greater
- IAM users should not have IAM policies attached

## 3. Amazon EC2

- Use security groups to restrict inbound and outbound traffic
- Use VPC flow logs
- Enable AWS Config
- Enable AWS CloudTrail
- Enable AWS GuardDuty
- Regularly monitor and patch instances
- Security groups should not allow ingress from any(all) ip address to port 22
- Ensure no security groups allow ingress from any(all) ip address to port 3389

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
- Enable S3 bucket access logging on the CloudTrail S3 bucket

## 7. Amazon CloudWatch

- Enable CloudWatch Logs and Metrics/Log metric filters and alarms for: 
  - usage of root user
  - changes to Security Group
  - changes to NACL
  - changes to Network Gateways
  - changes to Route Tables
  - changes to VPC
  - unauthorized API calls
  - management console sign-in without MFA
  - changes to IAM policy
  - changes to CloudTrail configuration
  - management console authentication failures
  - disabling/scheduled deletion of customer created master keys
  - changes to S3 bucket policies
  - changes to AWS Config configurations
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
