provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_iam_policy" "least_privilege_policy" {
  name        = "LeastPrivilegePolicy"
  path        = "/"
  description = "Policy with least privilege access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    }
    // Add more statements as per your requirements for least privilege access
  ]
}
EOF
}

resource "aws_iam_role" "ec2_role" {
  name               = "EC2Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_user" "rotate_access_keys_user" {
  name = "RotateAccessKeysUser"
}

resource "aws_iam_access_key" "rotate_access_keys" {
  user    = aws_iam_user.rotate_access_keys_user.name
  depends_on = [aws_iam_user.rotate_access_keys_user]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_account_password_policy" "mfa_and_password_policy" {
  minimum_password_length = 14
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_numbers = true
  require_symbols = true
  max_password_age = 90
  password_reuse_prevention = 5
}

resource "aws_iam_group" "permissions_group" {
  name = "PermissionsGroup"
}

resource "aws_iam_group_policy_attachment" "permissions_attachment" {
  group      = aws_iam_group.permissions_group.name
  policy_arn = aws_iam_policy.least_privilege_policy.arn
}

resource "aws_iam_user" "no_policies_user" {
  name = "NoPoliciesUser"
}

resource "aws_iam_user_policy_attachment" "no_policies_attachment" {
  user       = aws_iam_user.no_policies_user.name
  policy_arn = aws_iam_policy.least_privilege_policy.arn

  depends_on = [aws_iam_user.no_policies_user]
}
