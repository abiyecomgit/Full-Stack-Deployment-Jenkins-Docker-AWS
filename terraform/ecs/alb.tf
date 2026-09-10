# ============================================================
# APPLICATION LOAD BALANCER
# ============================================================

resource "aws_lb" "application" {
  name               = "fullstack-app-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    data.aws_subnet.public_a.id,
    data.aws_subnet.public_b.id
  ]

  tags = {
    Name = "fullstack-app-alb"
  }
}


# ============================================================
# FRONTEND TARGET GROUP
# ============================================================

resource "aws_lb_target_group" "frontend" {
  name        = "fullstack-frontend-tg"
  port        = var.frontend_container_port
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = data.aws_vpc.main.id

  health_check {
    enabled = true

    path     = "/"
    protocol = "HTTP"

    healthy_threshold   = 2
    unhealthy_threshold = 3

    interval = 30
    timeout  = 5

    matcher = "200"
  }

  tags = {
    Name = "fullstack-frontend-tg"
  }
}


# ============================================================
# BACKEND TARGET GROUP
# ============================================================

resource "aws_lb_target_group" "backend" {
  name        = "fullstack-backend-tg"
  port        = var.backend_container_port
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = data.aws_vpc.main.id

  health_check {
    enabled = true

    path     = "/"
    protocol = "HTTP"

    healthy_threshold   = 2
    unhealthy_threshold = 3

    interval = 30
    timeout  = 5

    matcher = "200"
  }

  tags = {
    Name = "fullstack-backend-tg"
  }
}


# ============================================================
# HTTP LISTENER
#
# Default route goes to frontend.
# ============================================================

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}


# ============================================================
# BACKEND ROUTING
#
# Requests beginning with /api are forwarded to backend.
# ============================================================

resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn

  priority = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = [
        "/api",
        "/api/*"
      ]
    }
  }
}