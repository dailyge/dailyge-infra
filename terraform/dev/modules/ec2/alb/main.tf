resource "aws_lb" "dailyge_alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets_ids
  security_groups    = [aws_security_group.alb_sg.id]
  tags               = var.tags
}

resource "aws_lb_listener" "dailyge_alb_listener_8080" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 8080
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8080.arn
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8080" {
  name        = "${var.name}-tg-8080"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 15
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
  deregistration_delay = 30
}

resource "aws_lb_listener" "dailyge_alb_listener_8081" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 8081
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8081.arn
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8081" {
  name        = "${var.name}-tg-8081"
  port        = 8081
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    enabled             = true
    interval            = 15
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

  deregistration_delay = 30
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "Security group for ALB ${var.name}"
  vpc_id      = var.vpc_id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
