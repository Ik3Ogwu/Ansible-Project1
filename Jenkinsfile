pipeline {
    agent any
    environment {
        PATH=sh(script:"echo $PATH:/usr/local/bin", returnStdout:true).trim()
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID=sh(script:'export PATH="$PATH:/usr/local/bin" && aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
        ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        APP_REPO_NAME = "ecr-repo/todo-app"
        APP_NAME = "todo"
        HOME_FOLDER = "/home/ec2-user"
        GIT_FOLDER = sh(script:'echo ${https://github.com/nicholasdesousa3/AnsibleProject} | sed "s/.*\\///;s/.git$//"', returnStdout:true).trim()
    }
    stages {
        stage('Create Infrastructure') {
            steps {
                script{
                    sh 'echo "Initilializing terraform files and instances"'
                    sh 'terraform init'
                    sh 'terraform apply --auto-approve'
                }
                
            }
        }
        stage('Create ECR') {
            steps {
                script {
                    sh '''
                        echo "Creating ECR repository"
                        aws ecr describe-repositories --region ${AWS_REGION} | grep ${APP_REPO_NAME} || \
                        aws ecr create-repository --region ${AWS_REGION} --repository-name ${APP_REPO_NAME}
                    '''
                }     
            }
        }
        stage('Build App Docker Image') {
            steps {
                echo 'Building App Image'
                script {
                    env.NODE_IP = sh(script: 'terraform output -raw node_public_ip', returnStdout:true).trim()
                    env.DB_HOST = sh(script: 'terraform output -raw postgre_private_ip', returnStdout:true).trim()
                }
                sh 'echo ${DB_HOST}'
                sh 'echo ${NODE_IP}'
<<<<<<< HEAD:jenkinsfile
                sh 'envsubst < node-env-template > ./nodejs/server/.env'
                sh 'cat ./nodejs/server/.env'
                sh 'envsubst < react-env-template > ./react/client/.env'
                sh 'cat ./react/client/.env'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:postgre" -f ./postgresql/dockerfile-postgresql .'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:nodejs" -f ./nodejs/dockerfile-nodejs .'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:react" -f ./react/dockerfile-react .'
=======
                sh 'envsubst < node-env-template > ./required-files/nodejs/server/.env'
                sh 'cat ./.env'
                sh 'envsubst < react-env-template > .env'
                sh 'cat ./.env'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:postgre" -f ./required-files/postgresql/dockerfile-postgresql .'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:nodejs" -f ./required-files/nodejs/dockerfile-nodejs .'
                sh 'docker build --force-rm -t "$ECR_REGISTRY/$APP_REPO_NAME:react" -f ./required-files/react/dockerfile-react .'
>>>>>>> ac7a50488a02efd97a66029d1e434daf9e99557c:Jenkinsfile
                sh 'docker image ls'
            }
        }
        stage('Push images to ECR') {
            steps {
                script{
                    sh'echo "Pushing images to ECR"'
                    //sh 'aws sso login --profile jenkins-project-profile'
                    sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin "$ECR_REGISTRY"'
                    sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:react"'
                    sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:nodejs"'
                    sh 'docker push "$ECR_REGISTRY/$APP_REPO_NAME:postgre"'
                    }
                }
            }
        stage('Wait') {
            steps {
                script{
                    // Use AWS CLI to describe instance status and wait until it's running
                    id = sh(script: 'aws ec2 describe-instances --filters Name=tag-value,Values=ansible_nodejs Name=instance-state-name,Values=running --query Reservations[*].Instances[*].[InstanceId] --output text',  returnStdout:true).trim()
                    sh "aws ec2 wait instance-status-ok --instance-ids $id"
                }
            }
        }
        stage('Deploy') {
            steps {
                // Use Ansible playbook to deploy the application
<<<<<<< HEAD:jenkinsfile
                ansiblePlaybook credentialsId: 'son', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory_aws_ec2.yml', playbook: 'docker-project.yml', vaultTmpPath: ''
=======
                ansiblePlaybook credentialsId: 'son', 
                installation: 'ansible', 
                inventory: './required-files/inventory_aws_ec2.yml', 
                playbook: './required-files/docker-project.yml', 
                vaultTmpPath: ''
>>>>>>> ac7a50488a02efd97a66029d1e434daf9e99557c:Jenkinsfile
            }
        }
    }
}
