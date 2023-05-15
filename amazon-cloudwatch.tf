provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Enable CloudWatch Logs
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "ExampleLogGroup"
  retention_in_days = 30  # Modify as needed
}

# Enable CloudWatch Metrics
resource "aws_cloudwatch_metric_alarm" "root_user_alarm" {
  alarm_name          = "RootUserAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "IAMUserRoot"
  namespace           = "AWS/IAM"
  period              = 60
  statistic           = "SampleCount"
  threshold           = 1
  alarm_description   = "Root user activity detected"
  alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:RootUserAlarmTopic"]  # Replace with your desired SNS topic ARN

  dimensions = {
    Username = "root"
  }
}

# Add additional CloudWatch metric alarms for other events (Security Group, NACL, Network Gateways, Route Tables, VPC, etc.)

# Set up CloudWatch Events for unauthorized API calls
resource "aws_cloudwatch_event_rule" "unauthorized_api_calls_rule" {
  name        = "UnauthorizedApiCallsRule"
  description = "Triggered when unauthorized API calls are detected"

  event_pattern = <<EOF
{
  "detail": {
    "userIdentity": {
      "invokedBy": "arn:aws:iam::*:root"
    },
    "eventType": [
      "AwsApiCall",
      "AwsConsoleSignin"
    ],
    "responseElements": {
      "ConsoleLogin": "Failure"
    }
  }
}
EOF
}

# Set up CloudWatch Events for management console sign-in without MFA
resource "aws_cloudwatch_event_rule" "console_signin_without_mfa_rule" {
  name        = "ConsoleSigninWithoutMfaRule"
  description = "Triggered when management console sign-in occurs without MFA"

  event_pattern = <<EOF
{
  "detail": {
    "eventType": [
      "AwsConsoleSignin"
    ],
    "responseElements": {
      "ConsoleLogin": "Success"
    },
    "additionalEventData": {
      "MFAUsed": "No"
    }
  }
}
EOF
}

# Add additional CloudWatch Events for other events (IAM policy changes, CloudTrail configuration changes, etc.)

# Set up CloudWatch Alarms for critical events
resource "aws_cloudwatch_metric_alarm" "critical_event_alarm" {
  alarm_name          = "CriticalEventAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CriticalEvent"
  namespace           = "AWS/CloudTrail"
  period              = 60
  statistic           = "SampleCount"
  threshold           = 1
  alarm_description   = "Critical event detected"
  alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:CriticalEventAlarmTopic"]  # Replace with your desired SNS topic ARN

  dimensions = {
    EventName    = "StopLogging"
    ResourceType = "Trail"
  }
}

# Set up CloudWatch Alarms for AWS Trusted Advisor findings
resource "aws_cloudwatch_metric_alarm" "trusted_advisor_alarm" {
  alarm_name          = "TrustedAdvisorAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
    metric_name         = "CheckId"
  namespace           = "AWS/TrustedAdvisor"
  period              = 3600  # Modify as needed
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "AWS Trusted Advisor finding detected"
  alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:TrustedAdvisorAlarmTopic"]  # Replace with your desired SNS topic ARN

  dimensions = {
    CheckName = "ServiceLimits"
  }
}

# Add additional CloudWatch alarms for other AWS Trusted Advisor findings

# Associate CloudWatch Logs with CloudTrail
resource "aws_cloudtrail" "cloudtrail" {
  name                       = "ExampleCloudTrail"
  s3_bucket_name             = "example-cloudtrail-bucket"  # Replace with your CloudTrail S3 bucket name
  cloud_watch_logs_role_arn  = "arn:aws:iam::123456789012:role/CloudTrailCloudWatchLogsRole"  # Replace with your CloudWatch Logs IAM role ARN
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.log_group.arn
  enable_log_file_validation = true
}

# Set up CloudWatch Alarms for CloudTrail logs
resource "aws_cloudwatch_metric_alarm" "cloudtrail_log_alarm" {
  alarm_name          = "CloudTrailLogAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "LogDeliverySuccess"
  namespace           = "AWS/CloudTrail"
  period              = 300
  statistic           = "SampleCount"
  threshold           = 1
  alarm_description   = "CloudTrail log delivery failure detected"
  alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:CloudTrailLogAlarmTopic"]  # Replace with your desired SNS topic ARN

  dimensions = {
    TrailName = "ExampleCloudTrail"
  }
}
