resource "aws_cloudwatch_log_group" "example" {
  name = "example-log-group"
}

resource "aws_cloudwatch_metric_alarm" "example" {
  alarm_name          = "example"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  alarm_description   = "This metric checks for high CPU usage"
  alarm_actions       = [aws_sns_topic.example.arn]
  threshold           = "80"
  statistic           = "SampleCount"

  dimensions = {
    InstanceId = aws_instance.example.id
  }
}

resource "aws_sns_topic" "example" {
  name = "example"
}

resource "aws_sns_topic_subscription" "example" {
  topic_arn = aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = "you@example.com"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95b798c7" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}