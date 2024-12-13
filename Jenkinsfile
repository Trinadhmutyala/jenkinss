pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']], // Ensure the correct branch name
                    userRemoteConfigs: [[
                        url: 'https://github.com/Trinadhmutyala/jenkinss.git',
                        credentialsId: 'github-token' // Replace with your GitHub credentials ID
                    ]]
                ])
            }
        }
        stage('Plan') {
            steps {
                sh 'pwd; terraform init'
                sh 'pwd; terraform plan -out=tfplan'
                sh 'pwd; terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        stage('Apply and destroy') {
            steps {
                sh 'pwd; terraform $action -auto-approve'
            }
        }
    }
}
