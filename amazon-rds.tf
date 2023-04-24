resource "aws_db_instance" "example" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "exampledb"
  username             = "exampleuser"
  password             = "examplepassword"
  parameter_group_name = "default.mysql5.7"

  backup_retention_period = 7
  backup_window           = "07:00-09:00"

  vpc_security_group_ids = [aws_security_group.example.id]

  storage_encrypted = true
  kms_key_id        = aws_kms_key.example.id

  monitoring_interval = 60

  enabled_cloudwatch_logs_exports = [
    "audit",
    "error",
    "general",
    "slowquery",
  ]

  multi_az = true
  publicly_accessible = false
  deletion_protection = true
}

resource "aws_kms_key" "example" {
  description = "Example KMS key for RDS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:*"
        ]
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          AWS = "*"
        }
      }
    ]
  })
}