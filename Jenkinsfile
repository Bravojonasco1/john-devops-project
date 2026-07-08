pipeline {
    agent any

    environment {
        DOCKER_HUB = "bravojonasco"

        PORTFOLIO_IMAGE = "portfolio-app"
        FLASK_IMAGE = "flask-app"
        JAVA_IMAGE = "java-web-app"

        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Show Build Info') {
            steps {
                sh '''
                echo "Build Number: ${BUILD_NUMBER}"
                echo "Docker Tag: ${IMAGE_TAG}"
                '''
            }
        }

        stage('Build Portfolio Image') {
            steps {
                dir('portfolio-app') {
                    sh """
                    docker build -t ${DOCKER_HUB}/${PORTFOLIO_IMAGE}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Build Flask Image') {
            steps {
                dir('flask-app') {
                    sh """
                    docker build -t ${DOCKER_HUB}/${FLASK_IMAGE}:${IMAGE_TAG} .
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
                    docker build -t ${DOCKER_HUB}/${JAVA_IMAGE}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub') {
                    sh 'echo "Docker Hub Login Successful"'
                }
            }
        }

        stage('Push Portfolio Image') {
            steps {
                sh """
                docker push ${DOCKER_HUB}/${PORTFOLIO_IMAGE}:${IMAGE_TAG}
                """
            }
        }

        stage('Push Flask Image') {
            steps {
                sh """
                docker push ${DOCKER_HUB}/${FLASK_IMAGE}:${IMAGE_TAG}
                """
            }
        }

        stage('Push Java Image') {
            steps {
                sh """
                docker push ${DOCKER_HUB}/${JAVA_IMAGE}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy Containers') {
            steps {
                sh '''
                docker compose down || true
                docker compose up -d
                '''
            }
        }
    }

    post {

        success {
            echo "===================================="
            echo "BUILD SUCCESSFUL"
            echo "Images tagged with Build #${BUILD_NUMBER}"
            echo "===================================="
        }

        failure {
            echo "===================================="
            echo "BUILD FAILED"
            echo "===================================="
        }

        always {
            cleanWs()
        }
    }
}
