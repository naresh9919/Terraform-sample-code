pipeline {
    agent any
    
    tools {
        terraform 'Terraform'
    }
    stages {
        stage ("checkout from GIT") {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/naresh9919/Terraform-sample-code.git'
            }
        }
        stage ("terraform init") {
            steps {
                sh 'terraform init'
            }
        }
        stage ("terraform fmt") {
            steps {
                sh 'terraform fmt'
            }
        }
        stage ("terraform validate") {
            steps {
                sh 'terraform validate'
            }
        }
        stage ("terrafrom plan") {
            steps {
                sh 'terraform plan '
            }
        }
        stage ("terraform apply") {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }
}
