variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "Full-Stack-Deployment"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "Development"
}

variable "frontend_container_port" {
  description = "Frontend container port"
  type        = number
  default     = 80
}

variable "backend_container_port" {
  description = "Backend container port"
  type        = number
  default     = 8080
}

variable "service_desired_count" {
  description = "Number of running ECS tasks per service"
  type        = number
  default     = 0
}