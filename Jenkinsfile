pipeline {
    agent any

    parameters {
        string(name: 'Environment', defaultValue: 'dev')
        choice(name: 'Terraform_Action', choices: ['plan', 'apply', 'destroy'])
    }

    stages {
        stage('Preparing') {
            steps {
                sh 'echo Preparing'
            }
        }
    }
}
    stages{
        stage('preparing'){
            steps{
                sh 'echo Preparing'
            }
        }
        stage('Git Pulling'){
            steps{
                git branch: 'master',url:'https://github.com/Akashholla/EKS-Terraform-GitHub-Actions.git'
            }
        }
        stage('init'){
            steps{
                withAWS(credentials:'aws-creds',region:'us-east-1'){sh'terraform -chdir=eks/init'}
            }
        }
        stage('validate'){
            steps{
                withAWS(credentials:'aws-creds',region:'us-east-1'){
                    sh'terraform -chdir=eks/validate'}
            }
        }
        stage('Action'){
            steps{
                withAWS(credentials: 'aws-creds',region:'us-east-1'){
                    script{
                        if(params.Terraform_Action=='plan'){
                            sh'terraform -chdir=eks/plan -var-file=${params.Environment}.tfvars'
                        }
                        else if(params.Terraform_Action=='apply'){
                            sh'terraform -chdir=eks/apply -var-file=${params.Environment}.tfvars -auto-approve'
                        }
                        else if(params.Terraform_Action=='destroy'){
                            sh'terraform -chdir=eks/destroy -var-file=${params.Environment}.tfvars -auto-approve'
                        }
                        else{
                            error"Invalid value for terraform action:${params.Terraform_Action}"
                        }
                    }
                }
            }
        }
    }
}