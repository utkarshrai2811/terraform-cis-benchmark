resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # This is an example Amazon Linux 2 AMI ID; replace with the appropriate one for your region
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "example-instance"
  }
}