#!/bin/bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

# ---------------------------------------
# Update system
# ---------------------------------------

apt-get update -y

# ---------------------------------------
# Install base packages
# ---------------------------------------

apt-get install -y \
  ca-certificates \
  curl \
  fontconfig \
  git \
  gnupg \
  unzip \
  wget \
  openjdk-21-jre

# ---------------------------------------
# Install Jenkins LTS
# ---------------------------------------

mkdir -p /etc/apt/keyrings

wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y

apt-get install -y jenkins

systemctl enable jenkins
systemctl start jenkins

# ---------------------------------------
# Install Docker
# ---------------------------------------

apt-get install -y docker.io

systemctl enable docker
systemctl start docker

# Allow Jenkins to run Docker commands
usermod -aG docker jenkins

# ---------------------------------------
# Install AWS CLI v2
# ---------------------------------------

curl \
  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o "/tmp/awscliv2.zip"

unzip -q /tmp/awscliv2.zip -d /tmp

/tmp/aws/install

rm -rf /tmp/aws
rm -f /tmp/awscliv2.zip

# ---------------------------------------
# Restart Jenkins
# ---------------------------------------

systemctl restart jenkins

# ---------------------------------------
# Verify services
# ---------------------------------------

java -version
git --version
docker --version
aws --version

systemctl is-active --quiet docker
systemctl is-active --quiet jenkins