resource "aws_lb" "dailyge_alb" {
  name               = "dailyge-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets_ids
  security_groups    = var.alb_security_group_ids
}

resource "aws_lb_target_group" "dailyge_alb_target_group_3000" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-3000"
  port                 = 3000
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 300

  health_check {
    enabled             = true
    interval            = 30
    path                = "/login"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "Monitoring target group."
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8080" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-8080"
  port                 = 8080
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    enabled             = true
    interval            = 15
    path                = "/api/health-check"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

  tags = {
    Name = "Prod target group."
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8081" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-8081"
  port                 = 8081
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 60

  health_check {
    enabled             = true
    interval            = 10
    path                = "/api/health-check"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name = "Dev target group."
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8083" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-8083"
  port                 = 8083
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 15

  health_check {
    enabled             = true
    interval            = 15
    path                = "/api/health-check"
    port                = 8083
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

  tags = {
    Name = "Dev target group."
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_443" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-443"
  port                 = 443
  protocol             = "HTTPS"
  target_type          = "instance"
  deregistration_delay = 30

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Name = "HTTPS target group."
  }
}

resource "aws_lb_listener" "dailyge_alb_https_listener_443" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.aws_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_443.arn
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_lb_listener_rule" "forward_monitoring" {
  listener_arn = aws_lb_listener.dailyge_alb_https_listener_443.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_3000.arn
  }

  condition {
    host_header {
      values = ["monitoring.dailyge.com"]
    }
  }
}

resource "aws_lb_target_group_attachment" "monitoring_attachment" {
  target_group_arn = aws_lb_target_group.dailyge_alb_target_group_3000.arn
  target_id        = var.monitoring_instance_ip
  port             = 3000
}

resource "aws_lb_listener_rule" "forward_api_8080" {
  listener_arn = aws_lb_listener.dailyge_alb_https_listener_443.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8080.arn
  }

  condition {
    host_header {
      values = ["api.dailyge.com"]
    }
  }
  depends_on = [aws_lb_target_group.dailyge_alb_target_group_8080]
}

resource "aws_lb_listener_rule" "forward_api_8081" {
  listener_arn = aws_lb_listener.dailyge_alb_https_listener_443.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8081.arn
  }

  condition {
    host_header {
      values = ["api-dev.dailyge.com"]
    }
  }
  depends_on = [aws_lb_target_group.dailyge_alb_target_group_8081]
}

resource "aws_lb_listener_rule" "forward_api_8083" {
  listener_arn = aws_lb_listener.dailyge_alb_https_listener_443.arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8083.arn
  }

  condition {
    host_header {
      values = ["api-docs.dailyge.com"]
    }
  }
  depends_on = [aws_lb_target_group.dailyge_alb_target_group_8083]
}
