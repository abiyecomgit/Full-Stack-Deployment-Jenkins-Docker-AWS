variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name used for resource tagging"
  type        = string
  default     = "Full-Stack-Deployment"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "Development"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC"
  type        = string
  default     = "10.30.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for Public Subnet A"
  type        = string
  default     = "10.30.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for Public Subnet B"
  type        = string
  default     = "10.30.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for Private Subnet A"
  type        = string
  default     = "10.30.11.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for Private Subnet B"
  type        = string
  default     = "10.30.12.0/24"
}

variable "availability_zone_a" {
  description = "Primary availability zone"
  type        = string
  default     = "us-west-2a"
}

variable "availability_zone_b" {
  description = "Secondary availability zone"
  type        = string
  default     = "us-west-2b"
}

variable "instance_type" {
  description = "EC2 instance type used by Jenkins"
  type        = string
  default     = "t3.medium"
}

variable "jenkins_port" {
  description = "Port used by Jenkins"
  type        = number
  default     = 8080
}

variable "allowed_ip" {
  description = "Public IPv4 CIDR allowed to access Jenkins"
  type        = string
}
