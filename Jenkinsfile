pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'ap-southeast-1'
        TERRAFORM            = '/opt/homebrew/bin/terraform' // Add this line with the full path to terraform
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'new-repo', url: 'https://github.com/nghialmgcd201527/terraform-jenkins.git'
            }
        }
        stage('Terraform init') {
            steps {
                sh '${TERRAFORM} init'
            }
        }
        stage('Plan') {
            steps {
                sh '${TERRAFORM} plan -out tfplan'
                sh '${TERRAFORM} show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Apply / Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh '${TERRAFORM} ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh '${TERRAFORM} ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }
    }
}