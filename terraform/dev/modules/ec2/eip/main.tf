resource "aws_eip" "bastion_instance_eip" {
  instance = var.bastion_instance_id
  vpc      = true
}
