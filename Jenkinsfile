pipeline {
    agent any
    environment {
        APP_NAME = "python-app"
        REPOSITORY = "https://github.com/suleonal/python-web-app.git"
        VERSION = "1.0.${env.BUILD_ID}"
        FULL_CHART_NAME = "${APP_NAME}-${VERSION}.tgz"
    }
    stages {
	stage("Build Docker Image & Push to Docker Hub") {
            steps {
                container("kaniko") {
                    script {
                        def context = "."
                        def dockerfile = "Dockerfile"
                        def image = "suleonal/python-app:1.0.6"
			sh "/kaniko/executor --context ${context} --dockerfile ${dockerfile} --destination ${image}"
                    }
                }
            }
        }
    }
}
