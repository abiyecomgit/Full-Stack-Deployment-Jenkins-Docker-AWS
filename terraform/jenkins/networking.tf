# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "jenkins" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "fullstack-jenkins-vpc"
  }
}


# ============================================================
# INTERNET GATEWAY
# ============================================================

resource "aws_internet_gateway" "jenkins" {
  vpc_id = aws_vpc.jenkins.id

  tags = {
    Name = "fullstack-jenkins-igw"
  }
}


# ============================================================
# PUBLIC SUBNET A
#
# Existing subnet used by Jenkins.
# The ALB will also use this subnet.
# ============================================================

resource "aws_subnet" "jenkins_public" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    Name = "fullstack-public-subnet-a"
  }
}


# ============================================================
# PUBLIC SUBNET B
#
# Second public subnet for the Application Load Balancer.
# ============================================================

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name = "fullstack-public-subnet-b"
  }
}


# ============================================================
# PRIVATE SUBNET A
#
# ECS Fargate tasks will run here.
# ============================================================

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = var.private_subnet_a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = false

  tags = {
    Name = "fullstack-private-subnet-a"
  }
}


# ============================================================
# PRIVATE SUBNET B
#
# ECS Fargate tasks will also run here.
# ============================================================

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = var.private_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = false

  tags = {
    Name = "fullstack-private-subnet-b"
  }
}


# ============================================================
# PUBLIC ROUTE TABLE
# ============================================================

resource "aws_route_table" "jenkins_public" {
  vpc_id = aws_vpc.jenkins.id

  tags = {
    Name = "fullstack-public-rt"
  }
}


# ============================================================
# PUBLIC INTERNET ROUTE
# ============================================================

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.jenkins_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jenkins.id
}


# ============================================================
# PUBLIC SUBNET A ASSOCIATION
# ============================================================

resource "aws_route_table_association" "jenkins_public" {
  subnet_id      = aws_subnet.jenkins_public.id
  route_table_id = aws_route_table.jenkins_public.id
}


# ============================================================
# PUBLIC SUBNET B ASSOCIATION
# ============================================================

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.jenkins_public.id
}


# ============================================================
# ELASTIC IP FOR NAT GATEWAY
# ============================================================

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "fullstack-nat-eip"
  }

  depends_on = [
    aws_internet_gateway.jenkins
  ]
}


# ============================================================
# NAT GATEWAY
#
# The NAT Gateway is placed in Public Subnet A.
# It provides outbound internet access for ECS tasks
# running in the private subnets.
# ============================================================

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.jenkins_public.id

  tags = {
    Name = "fullstack-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.jenkins
  ]
}


# ============================================================
# PRIVATE ROUTE TABLE
# ============================================================

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.jenkins.id

  tags = {
    Name = "fullstack-private-rt"
  }
}


# ============================================================
# PRIVATE INTERNET ROUTE
#
# Private ECS tasks send outbound internet traffic
# through the NAT Gateway.
# ============================================================

resource "aws_route" "private_internet" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}


# ============================================================
# PRIVATE SUBNET A ASSOCIATION
# ============================================================

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}


# ============================================================
# PRIVATE SUBNET B ASSOCIATION
# ============================================================

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}