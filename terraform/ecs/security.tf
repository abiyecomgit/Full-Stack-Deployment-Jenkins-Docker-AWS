# ============================================================
# ALB SECURITY GROUP
# ============================================================

resource "aws_security_group" "alb" {
  name        = "fullstack-alb-sg"
  description = "Security group for Full-Stack Application Load Balancer"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "fullstack-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP traffic from the internet"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
  security_group_id = aws_security_group.alb.id

  description = "Allow outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}


# ============================================================
# FRONTEND ECS SECURITY GROUP
# ============================================================

resource "aws_security_group" "frontend" {
  name        = "fullstack-frontend-sg"
  description = "Security group for frontend ECS tasks"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "fullstack-frontend-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "frontend_from_alb" {
  security_group_id = aws_security_group.frontend.id

  description = "Allow frontend traffic only from ALB"

  from_port   = var.frontend_container_port
  to_port     = var.frontend_container_port
  ip_protocol = "tcp"

  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "frontend_outbound" {
  security_group_id = aws_security_group.frontend.id

  description = "Allow frontend outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}


# ============================================================
# BACKEND ECS SECURITY GROUP
# ============================================================

resource "aws_security_group" "backend" {
  name        = "fullstack-backend-sg"
  description = "Security group for backend ECS tasks"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "fullstack-backend-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "backend_from_alb" {
  security_group_id = aws_security_group.backend.id

  description = "Allow backend traffic only from ALB"

  from_port   = var.backend_container_port
  to_port     = var.backend_container_port
  ip_protocol = "tcp"

  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "backend_outbound" {
  security_group_id = aws_security_group.backend.id

  description = "Allow backend outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}