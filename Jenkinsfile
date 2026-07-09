pipeline {
    agent any

    environment {
        DOCKER_HUB = "bravojonasco"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    options {
        timestamps()
        disableConcurrentBuilds()
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
                    echo "===== Environment ====="
                    java -version
                    mvn -version
                    git --version
                    docker --version
                '''
            }
        }

        stage('Build Java Application') {
            steps {
                dir('java-web-app') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Build Portfolio Image') {
            steps {
                dir('portfolio-app') {
                    sh "docker build -t ${DOCKER_HUB}/portfolio-app:${IMAGE_TAG} ."
                }
            }
        }

        stage('Build Flask Image') {
            steps {
                dir('flask-app') {
                    sh "docker build -t ${DOCKER_HUB}/flask-app:${IMAGE_TAG} ."
                }
            }
        }

        stage('Build Java Image') {
            steps {
                dir('java-web-app') {
                    sh "docker build -t ${DOCKER_HUB}/java-web-app:${IMAGE_TAG} ."
                }
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USER" \
                        --password-stdin
                    '''
                }
            }
        }

        stage('Push Images') {
            steps {
                sh """
                    docker push ${DOCKER_HUB}/portfolio-app:${IMAGE_TAG}
                    docker push ${DOCKER_HUB}/flask-app:${IMAGE_TAG}
                    docker push ${DOCKER_HUB}/java-web-app:${IMAGE_TAG}
                """
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

        success {
            echo "=================================="
            echo "PIPELINE COMPLETED SUCCESSFULLY"
            echo "Build Number: ${BUILD_NUMBER}"
            echo "=================================="
        }

        failure {
            echo "Pipeline Failed!"
        }

        always {
            sh './scripts/cleanup.sh'
            cleanWs()
        }
    }
}
