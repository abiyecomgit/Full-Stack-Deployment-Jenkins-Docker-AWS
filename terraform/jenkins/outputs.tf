# ============================================================
# JENKINS OUTPUTS
# ============================================================

output "jenkins_instance_id" {
  description = "EC2 instance ID of the Jenkins server"
  value       = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  description = "Elastic public IP address of Jenkins"
  value       = aws_eip.jenkins.public_ip
}

output "jenkins_url" {
  description = "Public Jenkins URL"
  value       = "http://${aws_eip.jenkins.public_ip}:${var.jenkins_port}"
}

output "jenkins_iam_role_name" {
  description = "IAM role attached to Jenkins"
  value       = aws_iam_role.jenkins_ec2.name
}

output "jenkins_instance_profile_name" {
  description = "IAM instance profile attached to Jenkins"
  value       = aws_iam_instance_profile.jenkins.name
}


# ============================================================
# VPC OUTPUT
# ============================================================

output "jenkins_vpc_id" {
  description = "VPC ID used by Jenkins and ECS"
  value       = aws_vpc.jenkins.id
}


# ============================================================
# SECURITY GROUP OUTPUT
# ============================================================

output "jenkins_security_group_id" {
  description = "Jenkins security group ID"
  value       = aws_security_group.jenkins.id
}


# ============================================================
# PUBLIC SUBNET OUTPUTS
# ============================================================

output "public_subnet_a_id" {
  description = "Public Subnet A ID"
  value       = aws_subnet.jenkins_public.id
}

output "public_subnet_b_id" {
  description = "Public Subnet B ID"
  value       = aws_subnet.public_b.id
}


# ============================================================
# PRIVATE SUBNET OUTPUTS
# ============================================================

output "private_subnet_a_id" {
  description = "Private Subnet A ID"
  value       = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  description = "Private Subnet B ID"
  value       = aws_subnet.private_b.id
}


# ============================================================
# NAT GATEWAY OUTPUT
# ============================================================

output "nat_gateway_id" {
  description = "NAT Gateway used by private ECS subnets"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Public Elastic IP assigned to NAT Gateway"
  value       = aws_eip.nat.public_ip
}