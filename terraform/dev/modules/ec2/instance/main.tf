resource "aws_instance" "dailyge_redis_instance" {
  ami                    = var.redis_instance_ami_id
  instance_type          = var.redis_instance_type
  key_name               = var.key_name
  subnet_id              = var.redis_subnet_id
  vpc_security_group_ids = var.redis_security_group_ids

  tags = {
    Name = "dailyge-redis-instance"
  }
}
