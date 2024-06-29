resource "aws_lb" "dailyge_alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets_ids
  security_groups    = [aws_security_group.alb_sg.id]
  tags               = var.tags
}

resource "aws_lb_listener" "dailyge_alb_listener_80" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_80.arn
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_80" {
  name     = "${var.name}-tg-80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "dailyge_alb_listener_8080" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 8080
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8080.arn
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8080" {
  name     = "${var.name}-tg-8080"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "dailyge_alb_listener_8081" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 8081
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8081.arn
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8081" {
  name     = "${var.name}-tg-8081"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "Security group for ALB ${var.name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
