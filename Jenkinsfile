pipeline {
    agent any

    environment {
        DOCKER_HUB = "bravojonasco"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Verify Environment') {
            steps {
                sh '''
                echo "===== Environment Check ====="
                java -version
                mvn -version
                docker --version
                git --version
                docker compose version
                '''
            }
        }

        stage('Build Portfolio Image') {
            steps {
                dir('portfolio-app') {
                    sh """
                    docker build -t ${DOCKER_HUB}/portfolio-app:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Build Flask Image') {
            steps {
                dir('flask-app') {
                    sh """
                    docker build -t ${DOCKER_HUB}/flask-app:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Build Java Application') {
            steps {
                dir('java-web-app') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Build Java Docker Image') {
            steps {
                dir('java-web-app') {
                    sh """
                    docker build -t ${DOCKER_HUB}/java-web-app:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub') {
                    sh 'docker info'
                }
            }
        }

        stage('Push Portfolio Image') {
            steps {
                sh "docker push ${DOCKER_HUB}/portfolio-app:${IMAGE_TAG}"
            }
        }

        stage('Push Flask Image') {
            steps {
                sh "docker push ${DOCKER_HUB}/flask-app:${IMAGE_TAG}"
            }
        }

        stage('Push Java Image') {
            steps {
                sh "docker push ${DOCKER_HUB}/java-web-app:${IMAGE_TAG}"
            }
        }

        stage('Deploy') {
            steps {
                sh './scripts/deploy.sh'
            }
        }

        stage('Health Check') {
            steps {
                sh './scripts/health-check.sh'
            }
        }
    }

    post {
        always {
            sh './scripts/cleanup.sh'
            cleanWs()
        }

        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'CI/CD Pipeline failed.'
        }
    }
}
