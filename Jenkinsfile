pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vishnu2663/my-spring-app"  // change this to DOCKERHUB_USERNAME
        APP_SERVER_IP = "13.203.94.209"             // change this to app_server_public_ip
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                // or: git 'https://github.com/yourname/yourrepo.git'
            }
        }

        stage('Build JAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

    stage('Build & Push Docker Image') {
    steps {
        script {
            def image = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
        }

        withCredentials([usernamePassword(
            credentialsId: 'dockerhub-creds',
            usernameVariable: 'DOCKERHUB_USER',
            passwordVariable: 'DOCKERHUB_PASS'
        )]) {
            sh '''
                echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                docker push ${DOCKER_IMAGE}:latest
            '''
        }
    }
}


        stage('Deploy to App Server') {
            steps {
                sshagent(credentials: ['app-server-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${APP_SERVER_IP} '
                          docker pull ${DOCKER_IMAGE}:latest &&
                          cd /opt/myapp &&
                          docker compose -f docker-compose.yml up -d
                        '
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
