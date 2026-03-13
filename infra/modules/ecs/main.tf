/*
resource "aws_ecs_cluster" "cluster" {
  name = var.project
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/${var.project}"
  retention_in_days = 7
}
# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Required AWS managed policy for ECS
resource "aws_iam_role_policy_attachment" "execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom policy for Parameter Store secrets
resource "aws_iam_role_policy" "ssm_access" {
  name = "ecs-ssm-access"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = "*"
        ## [
          var.db_password_arn,
          var.api_key_arn
        ]##
      }
      ,

      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
      }

    ]
  })
}

# Enable ECS Exec (container shell access)
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Policy to allow ECS Exec Command and logs
resource "aws_iam_role_policy" "ecs_task_ssm_exec" {
  name = "${var.project}-ecs-task-ssm"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:GetSecretValue",
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [
          var.db_password_arn,
          var.api_key_arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}
# Security Group for ECS tasks
resource "aws_security_group" "ecs_sg" {
  name   = "${var.project}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Task Definition
resource "aws_ecs_task_definition" "task" {
  family                   = var.project
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${var.image_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
      secrets = [
        {
      name      = "DB_PASSWORD"
      valueFrom = var.db_password_arn
        },
        {
      name      = "API_KEY"
      valueFrom = var.api_key_arn
        } 
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "service" {
 
  name            = var.project
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn

  desired_count = var.desired_count
  launch_type   = "FARGATE"
  

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [
    aws_iam_role_policy_attachment.execution_role_policy
  ]
}
*/

# ---------------------------------------
# ECS Cluster
# ---------------------------------------
resource "aws_ecs_cluster" "cluster" {
  name = var.project
}

# ---------------------------------------
# CloudWatch Logs
# ---------------------------------------
resource "aws_cloudwatch_log_group" "logs" {
  name              = "/ecs/${var.project}"
  retention_in_days = 7
}

# ---------------------------------------
# IAM Role for ECS Task Execution
# ---------------------------------------
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach required managed policy
resource "aws_iam_role_policy_attachment" "execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Optional: Add SSM/SecretsManager permissions for execution role
resource "aws_iam_role_policy" "execution_role_secrets" {
  name = "${var.project}-execution-ssm-secrets"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ]
        Resource = [
          var.db_password_arn,
          var.api_key_arn
        ]
      }
    ]
  })
}

# ---------------------------------------
# IAM Role for ECS Task (runtime role)
# ---------------------------------------
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Policy for ECS Exec & secrets at runtime
resource "aws_iam_role_policy" "ecs_task_ssm_exec" {
  name = "${var.project}-ecs-task-ssm"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:GetSecretValue",
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [
          var.db_password_arn,
          var.api_key_arn
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = "*"
      }
    ]
  })
}

# ---------------------------------------
# Security Group for ECS Tasks
# ---------------------------------------
resource "aws_security_group" "ecs_sg" {
  name   = "${var.project}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-ecs-sg"
  }
}

# ---------------------------------------
# ECS Task Definition
# ---------------------------------------
resource "aws_ecs_task_definition" "task" {
  family                   = var.project
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${var.image_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
        }
      ]

      # Inject secrets from Parameter Store / Secrets Manager
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = var.db_password_arn
        },
        {
          name      = "API_KEY"
          valueFrom = var.api_key_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ---------------------------------------
# ECS Service
# ---------------------------------------
resource "aws_ecs_service" "service" {
  name            = var.project
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn

  desired_count = var.desired_count
  launch_type   = "FARGATE"

  enable_execute_command = true

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [
    aws_iam_role_policy_attachment.execution_role_policy,
    aws_iam_role_policy.ecs_task_ssm_exec
  ]
}