pipeline {
    agent any
    environment {
        APP_NAME = "python-app"
        REPOSITORY = "https://github.com/suleonal/python-web-app.git"
        VERSION = "1.0.${env.BUILD_ID}"
        FULL_CHART_NAME = "${APP_NAME}-${VERSION}.tgz"
    }
    stages {
        stage('Build') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }
        stage('Push Image') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: 'https://index.docker.io/v1/']) {
                    sh 'docker tag myapp:latest my-dockerhub-user/myapp:latest'
                    sh 'docker push my-dockerhub-user/myapp:latest'
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'helm upgrade --install myapp ./helm'
            }
        }
    }
}
