pipeline {
    agent any

    environment {
        DOCKER_HUB = "bravojonasco"
        PORTFOLIO_IMAGE = "portfolio-app"
        FLASK_IMAGE = "flask-app"
        JAVA_IMAGE = "java-web-app"
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Build Portfolio Image') {
            steps {
                dir('portfolio-app') {
                    sh 'docker build -t $DOCKER_HUB/$PORTFOLIO_IMAGE:v1 .'
                }
            }
        }

        stage('Build Flask Image') {
            steps {
                dir('flask-app') {
                    sh 'docker build -t $DOCKER_HUB/$FLASK_IMAGE:v1 .'
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
                    sh 'docker build -t $DOCKER_HUB/$JAVA_IMAGE:v1 .'
                }
            }
        }

        stage('Push Portfolio Image') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub') {
                    sh 'docker push $DOCKER_HUB/$PORTFOLIO_IMAGE:v1'
                }
            }
        }

        stage('Push Flask Image') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub') {
                    sh 'docker push $DOCKER_HUB/$FLASK_IMAGE:v1'
                }
            }
        }

        stage('Push Java Image') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub') {
                    sh 'docker push $DOCKER_HUB/$JAVA_IMAGE:v1'
                }
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
            echo "Deployment Successful!"
        }

        failure {
            echo "Pipeline Failed!"
        }
    }
}
