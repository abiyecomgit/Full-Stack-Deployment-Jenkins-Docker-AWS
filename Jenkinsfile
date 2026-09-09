pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-2'
        AWS_ACCOUNT_ID = '975503882726'

        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        FRONTEND_ECR = 'fullstack-frontend'
        BACKEND_ECR = 'fullstack-backend'

        ECS_CLUSTER = 'fullstack-deployment-cluster'

        FRONTEND_SERVICE = 'fullstack-frontend-service'
        BACKEND_SERVICE = 'fullstack-backend-service'

        APP_URL = 'http://fullstack-app-alb-554606142.us-west-2.elb.amazonaws.com'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Image Tag') {
            steps {
                script {
                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                }

                echo "Deploying image tag: ${IMAGE_TAG}"
            }
        }

        stage('Verify AWS Identity') {
            steps {
                sh '''
                    aws sts get-caller-identity
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password \
                      --region ${AWS_REGION} | \
                    docker login \
                      --username AWS \
                      --password-stdin \
                      ${ECR_REGISTRY}
                '''
            }
        }

        stage('Build Images') {
            parallel {

                stage('Build Backend') {
                    steps {
                        sh '''
                            docker build \
                              --platform linux/amd64 \
                              -t ${BACKEND_ECR}:${IMAGE_TAG} \
                              ./backend

                            docker tag \
                              ${BACKEND_ECR}:${IMAGE_TAG} \
                              ${ECR_REGISTRY}/${BACKEND_ECR}:${IMAGE_TAG}

                            docker tag \
                              ${BACKEND_ECR}:${IMAGE_TAG} \
                              ${ECR_REGISTRY}/${BACKEND_ECR}:latest
                        '''
                    }
                }

                stage('Build Frontend') {
                    steps {
                        sh '''
                            docker build \
                              --platform linux/amd64 \
                              -t ${FRONTEND_ECR}:${IMAGE_TAG} \
                              ./frontend

                            docker tag \
                              ${FRONTEND_ECR}:${IMAGE_TAG} \
                              ${ECR_REGISTRY}/${FRONTEND_ECR}:${IMAGE_TAG}

                            docker tag \
                              ${FRONTEND_ECR}:${IMAGE_TAG} \
                              ${ECR_REGISTRY}/${FRONTEND_ECR}:latest
                        '''
                    }
                }
            }
        }

        stage('Push Images') {
            parallel {

                stage('Push Backend') {
                    steps {
                        sh '''
                            docker push \
                              ${ECR_REGISTRY}/${BACKEND_ECR}:${IMAGE_TAG}

                            docker push \
                              ${ECR_REGISTRY}/${BACKEND_ECR}:latest
                        '''
                    }
                }

                stage('Push Frontend') {
                    steps {
                        sh '''
                            docker push \
                              ${ECR_REGISTRY}/${FRONTEND_ECR}:${IMAGE_TAG}

                            docker push \
                              ${ECR_REGISTRY}/${FRONTEND_ECR}:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy Backend') {
            steps {
                sh '''
                    aws ecs update-service \
                      --cluster ${ECS_CLUSTER} \
                      --service ${BACKEND_SERVICE} \
                      --force-new-deployment \
                      --region ${AWS_REGION}
                '''
            }
        }

        stage('Deploy Frontend') {
            steps {
                sh '''
                    aws ecs update-service \
                      --cluster ${ECS_CLUSTER} \
                      --service ${FRONTEND_SERVICE} \
                      --force-new-deployment \
                      --region ${AWS_REGION}
                '''
            }
        }

        stage('Wait for ECS') {
            steps {
                sh '''
                    aws ecs wait services-stable \
                      --cluster ${ECS_CLUSTER} \
                      --services ${BACKEND_SERVICE} ${FRONTEND_SERVICE} \
                      --region ${AWS_REGION}
                '''
            }
        }

        stage('Verify ECS Services') {
            steps {
                sh '''
                    aws ecs describe-services \
                      --cluster ${ECS_CLUSTER} \
                      --services ${FRONTEND_SERVICE} ${BACKEND_SERVICE} \
                      --region ${AWS_REGION} \
                      --query 'services[*].[serviceName,desiredCount,runningCount]' \
                      --output table
                '''
            }
        }

        stage('Verify Application') {
            steps {
                sh '''
                    curl --fail --retry 5 --retry-delay 10 ${APP_URL}/
                    curl --fail --retry 5 --retry-delay 10 ${APP_URL}/api
                '''
            }
        }
    }

    post {
        success {
            echo 'Full-stack deployment completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Review the Jenkins console output.'
        }

        always {
            sh '''
                docker image prune -f || true
            '''
        }
    }
}
