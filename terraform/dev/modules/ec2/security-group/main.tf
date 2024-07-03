resource "aws_security_group" "alb_security_group" {
  vpc_id = var.vpc_id
  name   = "dailyge alb security group."

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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
    Name = "dailyge-redis"
  }
}

resource "aws_security_group" "rds_security_group" {
  vpc_id = var.vpc_id
  name   = "dailyge redis security group."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH port."
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "dailyge-rds"
  }
}

resource "aws_security_group" "prometheus_security_group" {
  vpc_id = var.vpc_id
  name   = "dailyge prometheus security group."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH port."
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
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
    Name = "dailyge-prometheus"
  }
}
