resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/fullstack-frontend"
  retention_in_days = 7

  tags = {
    Name = "fullstack-frontend-logs"
  }
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/fullstack-backend"
  retention_in_days = 7

  tags = {
    Name = "fullstack-backend-logs"
  }
}