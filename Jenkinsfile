pipeline {

    agent any

    environment {

        DOCKER_HUB = "bravojonasco"
        IMAGE_TAG = "latest"

        AWS_REGION = "us-east-1"

        TF_DIR = "terraform"
        ANSIBLE_DIR = "ansible"

    }


    options {

        timestamps()

        disableConcurrentBuilds()

        buildDiscarder(
            logRotator(
                daysToKeepStr: '7',
                numToKeepStr: '20'
            )
        )

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

                    sh '''

                    mvn clean package

                    '''

                }

            }

        }



        stage('Build Docker Images') {

            steps {

                sh '''

                docker build \
                -t ${DOCKER_HUB}/portfolio-app:${IMAGE_TAG} \
                portfolio-app


                docker build \
                -t ${DOCKER_HUB}/flask-app:${IMAGE_TAG} \
                flask-app


                docker build \
                -t ${DOCKER_HUB}/java-web-app:${IMAGE_TAG} \
                java-web-app


                docker build \
                -t ${DOCKER_HUB}/nginx-proxy:${IMAGE_TAG} \
                nginx


                '''

            }

        }



        stage('Docker Hub Login') {

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

                dir("${TF_DIR}") {

                    withCredentials([

                        [$class: 'AmazonWebServicesCredentialsBinding',
                         credentialsId: 'aws-creds']

                    ]) {


                        sh '''

                        terraform init

                        '''

                    }

                }

            }

        }




        stage('Terraform Plan') {

            steps {


                dir("${TF_DIR}") {


                    sh '''

                    terraform plan \
                    -var-file=terraform.tfvars

                    '''


                }


            }

        }




        stage('Terraform Apply') {


            steps {


                dir("${TF_DIR}") {


                    sh '''

                    terraform apply \
                    -auto-approve \
                    -var-file=terraform.tfvars

                    '''


                }


            }


        }




        stage('Create Dynamic Ansible Inventory') {


            steps {


                script {


                    def publicIP = sh(

                        script: """

                        cd ${TF_DIR}

                        terraform output -raw public_ip

                        """,

                        returnStdout: true

                    ).trim()



                    writeFile(

                        file: "${ANSIBLE_DIR}/inventory",

                        text: """

[web]

${publicIP} ansible_user=ec2-user

"""

                    )


                    echo "Inventory created for ${publicIP}"


                }


            }


        }




        stage('Run Ansible Deployment') {


            steps {


                withCredentials([


                    sshUserPrivateKey(

                        credentialsId: 'ec2-ssh-key',

                        keyFileVariable: 'SSH_KEY'

                    )


                ]) {


                    sh '''

                    ansible-playbook \
                    -i ansible/inventory \
                    ansible/playbook.yml \
                    --private-key $SSH_KEY


                    '''

                }


            }


        }





        stage('Health Check') {


            steps {


                script {


                    def ip = sh(

                    script: """

                    cd terraform

                    terraform output -raw public_ip

                    """,

                    returnStdout:true

                    ).trim()



                    sh """

                    curl -f http://${ip}:8088 || exit 1

                    """


                }


            }


        }


    }



    post {


        success {


            echo """

            ==================================

            PIPELINE SUCCESSFUL

            Applications deployed successfully

            ==================================

            """


        }



        failure {


            echo "Pipeline failed - check logs"

        }



        always {


            sh '''

            docker logout || true

            '''


        }


    }

}
