# ============================================================
# ECS CLUSTER
# ============================================================

resource "aws_ecs_cluster" "main" {
  name = "fullstack-deployment-cluster"

  tags = {
    Name = "fullstack-deployment-cluster"
  }
}


# ============================================================
# FRONTEND TASK DEFINITION
# ============================================================

resource "aws_ecs_task_definition" "frontend" {
  family = "fullstack-frontend-task"

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name = "fullstack-frontend"

      image = "${aws_ecr_repository.frontend.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = var.frontend_container_port
          hostPort      = var.frontend_container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.frontend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])

  tags = {
    Name = "fullstack-frontend-task"
  }
}


# ============================================================
# BACKEND TASK DEFINITION
# ============================================================

resource "aws_ecs_task_definition" "backend" {
  family = "fullstack-backend-task"

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name = "fullstack-backend"

      image = "${aws_ecr_repository.backend.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = var.backend_container_port
          hostPort      = var.backend_container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])

  tags = {
    Name = "fullstack-backend-task"
  }
}


# ============================================================
# FRONTEND ECS SERVICE
# ============================================================

resource "aws_ecs_service" "frontend" {
  name = "fullstack-frontend-service"

  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count = var.service_desired_count

  launch_type = "FARGATE"

  network_configuration {
    subnets = [
      data.aws_subnet.private_a.id,
      data.aws_subnet.private_b.id
    ]

    security_groups = [
      aws_security_group.frontend.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn

    container_name = "fullstack-frontend"
    container_port = var.frontend_container_port
  }

  depends_on = [
    aws_lb_listener.http,
    aws_iam_role_policy_attachment.ecs_execution
  ]

  tags = {
    Name = "fullstack-frontend-service"
  }
}


# ============================================================
# BACKEND ECS SERVICE
# ============================================================

resource "aws_ecs_service" "backend" {
  name = "fullstack-backend-service"

  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn

  desired_count = var.service_desired_count

  launch_type = "FARGATE"

  network_configuration {
    subnets = [
      data.aws_subnet.private_a.id,
      data.aws_subnet.private_b.id
    ]

    security_groups = [
      aws_security_group.backend.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn

    container_name = "fullstack-backend"
    container_port = var.backend_container_port
  }

  depends_on = [
    aws_lb_listener_rule.backend,
    aws_iam_role_policy_attachment.ecs_execution
  ]

  tags = {
    Name = "fullstack-backend-service"
  }
}