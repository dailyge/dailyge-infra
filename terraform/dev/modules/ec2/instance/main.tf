resource "aws_instance" "dailyge_redis_instance" {
  ami                    = var.redis_instance_ami_id
  instance_type          = var.redis_instance_type
  key_name               = var.key_name
  subnet_id              = var.redis_subnet_id
  vpc_security_group_ids = var.redis_security_group_ids

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -a -G docker ec2-user

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    sudo docker run -d --name redis -p 6379:6379 redis:latest
  EOF

  tags = {
    Name = "dailyge-redis"
  }
}
