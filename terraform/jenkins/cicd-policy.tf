resource "aws_iam_policy" "jenkins_cicd" {
  name        = "fullstack-jenkins-cicd-policy"
  description = "Allows Jenkins to push images to ECR and redeploy ECS services"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ECRAuthentication"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Sid    = "ECRImagePush"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]

        Resource = [
          "arn:aws:ecr:us-west-2:975503882726:repository/fullstack-frontend",
          "arn:aws:ecr:us-west-2:975503882726:repository/fullstack-backend"
        ]
      },
      {
        Sid    = "ECSDeployment"
        Effect = "Allow"

        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:DescribeClusters"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_cicd" {
  role       = aws_iam_role.jenkins_ec2.name
  policy_arn = aws_iam_policy.jenkins_cicd.arn
}
