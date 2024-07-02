resource "aws_ecs_cluster" "dailyge_ecs_cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "dailyge_ecs_instance_role" {
  name = "${var.cluster_name}-ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_policy" {
  name        = "ECSInstancePolicy"
  description = "Policy for ECS Instances to allow necessary actions"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:Describe*",
          "ecs:*",
          "elasticloadbalancing:*",
          "cloudwatch:*",
          "logs:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.dailyge_ecs_instance_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.dailyge_ecs_instance_role.name
}

resource "aws_security_group" "ecs_security_group" {
  vpc_id = var.vpc_id

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

  tags = {
    Name        = "ecs-sg"
    Environment = "prod"
  }
}

data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs_launch_template" {
  name = "ecsLaunchTemplate"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.ecs_security_group.id]
    subnet_id                   = element(var.private_subnet_ids, 0)
  }

  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.dailyge_ecs_cluster.name} >> /etc/ecs/ecs.config\necho ECS_CONTAINER_STOP_TIMEOUT=2s >> /etc/ecs/ecs.config\necho ECS_IMAGE_PULL_BEHAVIOR=once >> /etc/ecs/ecs.config")

  tag_specifications {
    resource_type = "instance"
    tags          = {
      Name        = "ecs-instance"
      Environment = "prod"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                = "dailyge-api-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "dailyge-api"
    propagate_at_launch = true
  }
}

resource "aws_appautoscaling_policy" "scale_out_policy" {
  name               = "scale-out-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 50.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "scale_in_policy" {
  name               = "scale-in-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 50.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_target" "ecs_scaling_target" {
  max_capacity       = var.max_size
  min_capacity       = var.min_size
  resource_id        = "service/${aws_ecs_cluster.dailyge_ecs_cluster.name}/${aws_ecs_service.dailyge_prod_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_ecs_task_definition" "dailyge_prod_deploy_task_def" {
  family                   = "dailyge-api-prod"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name              = "dailyge-prod-container"
      image             = var.dailyge_api_prod_url
      essential         = true
      stopTimeout       = 2
      cpu               = 1024
      memoryReservation = 1024
      environment       = [
        {
          name  = "ECS_CONTAINER_STOP_TIMEOUT"
          value = "3"
        }
      ]
      portMappings = [
        {
          hostPort      = 8080
          containerPort = 8080
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = "ap-northeast-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "dailyge_dev_deploy_task_def" {
  family                   = "dailyge-api-dev"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name              = "dailyge-dev-container"
      image             = var.dailyge_api_dev_url
      essential         = true
      stopTimeout       = 2
      cpu               = 512
      memoryReservation = 512
      environment       = [
        {
          name  = "ECS_CONTAINER_STOP_TIMEOUT"
          value = "3"
        }
      ]
      portMappings = [
        {
          hostPort      = 8081
          containerPort = 8081
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = "ap-northeast-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_iam_policy" "ecs_ecr_access_policy" {
  name        = "ECSECRAccessPolicy"
  description = "Policy to allow ECS to pull images from ECR"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_ecr_access_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_ecr_access_policy.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "ecs-tasks.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "Dailyge execution role."
  }
}

resource "aws_iam_role" "ecs_service_role" {
  name = "ecsServiceRole"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "ecs.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "Dailyge service role."
  }
}

resource "aws_iam_policy" "ecs_service_role_policy" {
  name        = "ECSServiceRolePolicy"
  description = "Policy for ECS Service Role"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeListeners",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs",
          "ecs:ListTasks",
          "ecs:DescribeTasks",
          "ecs:DescribeServices",
          "ecs:DescribeClusters",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_policy_attach" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = aws_iam_policy.ecs_service_role_policy.arn
}

resource "aws_ecs_service" "dailyge_prod_service" {
  name            = "${var.cluster_name}-prod-service"
  cluster         = aws_ecs_cluster.dailyge_ecs_cluster.id
  task_definition = aws_ecs_task_definition.dailyge_prod_deploy_task_def.arn
  #  iam_role        = aws_iam_role.ecs_service_role.name
  desired_count   = 2
  launch_type     = "EC2"

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 150

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn_8080
    container_name   = "dailyge-prod-container"
    container_port   = 8080
  }

  health_check_grace_period_seconds = 30

  depends_on = [
    aws_iam_role_policy_attachment.ecs_service_role_policy_attach,
    aws_iam_policy.ecs_service_role_policy,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attach
  ]
}

resource "aws_ecs_service" "dailyge_dev_service" {
  name            = "${var.cluster_name}-dev-service"
  cluster         = aws_ecs_cluster.dailyge_ecs_cluster.id
  task_definition = aws_ecs_task_definition.dailyge_dev_deploy_task_def.arn
  #  iam_role        = aws_iam_role.ecs_service_role.name
  desired_count   = 1
  launch_type     = "EC2"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }

  deployment_minimum_healthy_percent = 70
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = var.target_group_arn_8081
    container_name   = "dailyge-dev-container"
    container_port   = 8081
  }

  health_check_grace_period_seconds = 30

  depends_on = [
    aws_iam_role_policy_attachment.ecs_service_role_policy_attach,
    aws_iam_policy.ecs_service_role_policy,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attach
  ]
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/dailyge-dev-service"
  retention_in_days = 3
}

resource "aws_iam_policy" "ecs_logging_policy" {
  name        = "ECSLoggingPolicy"
  description = "Policy to allow ECS tasks to log to CloudWatch"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_logging_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_logging_policy.arn
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ECSTaskExecutionPolicy"
  description = "Policy for ECS task execution role"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}
