resource "aws_security_group" "jenkins" {
  name        = "fullstack-jenkins-sg"
  description = "Security group for Full-Stack Jenkins server"
  vpc_id      = aws_vpc.jenkins.id

  tags = {
    Name = "fullstack-jenkins-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_web" {
  security_group_id = aws_security_group.jenkins.id

  description = "Allow Jenkins web access from my public IP"

  from_port   = var.jenkins_port
  to_port     = var.jenkins_port
  ip_protocol = "tcp"

  cidr_ipv4 = var.allowed_ip
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.jenkins.id

  description = "Allow Jenkins outbound internet access"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}