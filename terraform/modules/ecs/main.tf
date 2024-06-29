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

  user_data = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.dailyge_ecs_cluster.name} > /etc/ecs/ecs.config")

  tag_specifications {
    resource_type = "instance"
    tags          = {
      Name        = "ecs-instance"
      Environment = "prod"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
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

resource "aws_ecs_task_definition" "dailyge_task_def" {
  family                   = "dailyge-family"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name              = "dailyge-container"
      image             = var.dailyge_api_dev_url
      essential         = true
      cpu               = 256
      memoryReservation = 256
      portMappings      = [
        {
          containerPort = 80
          hostPort      = 80
        },
        {
          containerPort = 8080
          hostPort      = 8080
        },
        {
          containerPort = 8081
          hostPort      = 8081
        }
      ]
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

resource "aws_ecs_service" "dailyge_service" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.dailyge_ecs_cluster.id
  task_definition = aws_ecs_task_definition.dailyge_task_def.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.target_group_arn_8080
    container_name   = "dailyge-container"
    container_port   = 8080
  }

  force_new_deployment = true
  health_check_grace_period_seconds = 300

  depends_on = [
    var.production_listener_arn_8080
  ]
}
