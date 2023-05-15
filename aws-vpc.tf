provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Development VPC
resource "aws_vpc" "development_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Development VPC"
  }
}

resource "aws_network_acl" "development_nacl" {
  vpc_id = aws_vpc.development_vpc.id
  tags = {
    Name = "Development NACL"
  }
}

# Staging VPC
resource "aws_vpc" "staging_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "Staging VPC"
  }
}

resource "aws_network_acl" "staging_nacl" {
  vpc_id = aws_vpc.staging_vpc.id
  tags = {
    Name = "Staging NACL"
  }
}

# Production VPC
resource "aws_vpc" "production_vpc" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = "Production VPC"
  }
}

resource "aws_network_acl" "production_nacl" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name = "Production NACL"
  }
}

# Enable VPC Flow Logs
resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn         = "arn:aws:iam::123456789012:role/FlowLogRole"  # Replace with your IAM role ARN
  log_destination     = "arn:aws:logs:<region>:<account-id>:log-group:/aws/vpc/flow-log:<flow-log-id>"  # Replace with your desired log group ARN
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.development_vpc.id  # Replace with the desired VPC ID
}

# NAT Gateway for outbound traffic from private subnets
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = "<private-subnet-id>"  # Replace with the desired private subnet ID
}
