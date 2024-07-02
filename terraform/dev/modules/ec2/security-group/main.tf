resource "aws_security_group" "redis_security_group" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH port."
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Inbound port."
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "All outbound traffic."
  }

  tags = {
    Name = "Dailyge Redis."
  }
}
