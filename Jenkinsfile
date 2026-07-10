pipeline {

    agent any

    environment {
        DOCKER_HUB = "bravojonasco"
        IMAGE_TAG = "latest"
        AWS_DEFAULT_REGION = "us-east-1"
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
                echo "Source code checked out"
            }
        }

        stage('Verify Environment') {
            steps {
                sh '''
                echo "===== Environment ====="
                java -version
                mvn -version
                docker --version
                terraform version
                ansible --version
                aws --version
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

        stage('Build Docker Images') {
            steps {
                sh '''
                docker build -t ${DOCKER_HUB}/portfolio-app:${IMAGE_TAG} portfolio-app
                docker build -t ${DOCKER_HUB}/flask-app:${IMAGE_TAG} flask-app
                docker build -t ${DOCKER_HUB}/java-web-app:${IMAGE_TAG} java-web-app
                docker build -t ${DOCKER_HUB}/nginx-proxy:${IMAGE_TAG} nginx
                '''
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                    echo "$DOCKER_PASSWORD" | docker login \
                        -u "$DOCKER_USERNAME" \
                        --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                sh '''
                docker push ${DOCKER_HUB}/portfolio-app:${IMAGE_TAG}
                docker push ${DOCKER_HUB}/flask-app:${IMAGE_TAG}
                docker push ${DOCKER_HUB}/java-web-app:${IMAGE_TAG}
                docker push ${DOCKER_HUB}/nginx-proxy:${IMAGE_TAG}
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']
                    ]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']
                    ]) {
                        sh '''
                        echo "Checking AWS Identity"
                        aws sts get-caller-identity

                        terraform plan \
                          -var-file=terraform.tfvars
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds']
                    ]) {
                        sh '''
                        terraform apply \
                          -auto-approve \
                          -var-file=terraform.tfvars
                        '''
                    }
                }
            }
        }

        stage('Wait for EC2 SSH') {
            steps {
                dir('terraform') {
                    sh '''
                    IP=$(terraform output -raw public_ip)

                    echo "Waiting for SSH on $IP..."

                    for i in {1..30}; do
                        if ssh \
                            -i /var/lib/jenkins/demokey.pem \
                            -o StrictHostKeyChecking=no \
                            -o UserKnownHostsFile=/dev/null \
                            -o ConnectTimeout=5 \
                            ec2-user@$IP "echo SSH Ready" >/dev/null 2>&1
                        then
                            echo "SSH is available."
                            exit 0
                        fi

                        echo "SSH not ready yet..."
                        sleep 10
                    done

                    echo "Timed out waiting for SSH."
                    exit 1
                    '''
                }
            }
        }

        stage('Create Dynamic Ansible Inventory') {
            steps {
                dir('terraform') {
                    script {

                        def serverIP = sh(
                            script: "terraform output -raw public_ip",
                            returnStdout: true
                        ).trim()

                        writeFile(
                            file: "../ansible/inventory",
                            text: """[web]
${serverIP} ansible_user=ec2-user ansible_ssh_private_key_file=/var/lib/jenkins/demokey.pem
"""
                        )

                        echo "Inventory created for ${serverIP}"
                    }
                }
            }
        }

        stage('Debug Inventory') {
            steps {
                dir('ansible') {
                    sh '''
                    echo "===== INVENTORY ====="
                    pwd
                    ls -la
                    cat inventory
                    '''
                }
            }
        }

        stage('Run Ansible Deployment') {
            steps {
                dir('ansible') {
                    sh '''
                    chmod 600 /var/lib/jenkins/demokey.pem

                    export ANSIBLE_CONFIG=$PWD/ansible.cfg
                    export ANSIBLE_HOST_KEY_CHECKING=False

                    ansible-playbook \
                      -i inventory \
                      -u ec2-user \
                      --private-key=/var/lib/jenkins/demokey.pem \
                      -vvv \
                      playbook.yml
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                chmod +x scripts/health-check.sh
                ./scripts/health-check.sh
                '''
            }
        }
    }

    post {

        success {
            echo '''

====================================

PIPELINE COMPLETED SUCCESSFULLY

====================================

'''
        }

        failure {
            echo '''

====================================

PIPELINE FAILED

CHECK LOGS

====================================

'''
        }

        always {
            sh 'docker logout || true'
            cleanWs()
        }
    }
}
