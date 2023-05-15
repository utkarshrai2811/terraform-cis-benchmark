provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_security_group" "rds_security_group" {
  name        = "RDSSecurityGroup"
  description = "Security group for RDS instances"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Add more ingress and egress rules as per your requirements to restrict traffic
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "RDSSubnetGroup"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]  # Replace with your desired subnet IDs
}

resource "aws_db_instance" "rds_instance" {
  identifier            = "RDSInstance"
  engine                = "mysql"
  engine_version        = "8.0.23"
  instance_class        = "db.t2.micro"
  username              = "admin"
  password              = "password"
  allocated_storage     = 20
  storage_type          = "gp2"
  publicly_accessible   = false
  multi_az              = false
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  backup_retention_period = 7
  backup_window           = "00:00-03:00"
  maintenance_window      = "Sun:00:00-Sun:03:00"

  // Enable logging
  enable_logging = true
  s3_bucket_name = "example-logging-bucket"  # Replace with your desired S3 bucket name
  s3_prefix      = "rds-logs/"

  // Enable monitoring
  monitoring_interval = 60

  // Enable IAM authentication
  iam_database_authentication_enabled = true

  // Enable encryption
  storage_encrypted = true
}
