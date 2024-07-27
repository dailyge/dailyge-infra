resource "aws_lb" "dailyge_alb" {
  name               = "dailyge-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets_ids
  security_groups    = var.alb_security_group_ids
  tags               = var.tags
}

resource "aws_lb_target_group" "dailyge_alb_target_group_80" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-80"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 6

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
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8080" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-8080"
  port                 = 8080
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 6

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
}

resource "aws_lb_target_group" "dailyge_alb_target_group_8081" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-8081"
  port                 = 8081
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 60

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
}

resource "aws_lb_target_group" "dailyge_alb_target_group_9000" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-9000"
  port                 = 9000
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 300

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "dailyge_alb_target_group_443" {
  vpc_id               = var.vpc_id
  name                 = "${var.project_name}-tg-443"
  port                 = 443
  protocol             = "HTTPS"
  target_type          = "ip"
  deregistration_delay = 300

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
}

resource "aws_lb_listener" "dailyge_alb_http_listener_8080" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8080.arn
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_lb_listener" "dailyge_alb_http_listener_8081" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 8081
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_8081.arn
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_lb_listener" "dailyge_alb_http_listener_9000" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 9000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_9000.arn
  }

  lifecycle {
    create_before_destroy = false
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

resource "aws_lb_listener" "http_to_https_redirect" {
  load_balancer_arn = aws_lb.dailyge_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "forward_static_analysis_dailyge" {
  listener_arn = aws_lb_listener.dailyge_alb_https_listener_443.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dailyge_alb_target_group_9000.arn
  }

  condition {
    host_header {
      values = ["static-analysis.dailyge.com"]
    }
  }
}

resource "aws_lb_target_group_attachment" "api_docs_attachment" {
  target_group_arn = aws_lb_target_group.dailyge_alb_target_group_80.arn
  target_id        = var.api_docs_instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "sonarqube_attachment" {
  target_group_arn = aws_lb_target_group.dailyge_alb_target_group_9000.arn
  target_id        = var.sonarqube_instance_ip
  port             = 9000
}
