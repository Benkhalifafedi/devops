pipeline {
    agent any

    tools {
        maven 'M3'   // le nom du Maven configuré dans Jenkins (si différent, adapte)
    }

    environment {
        // Nom de l'image Docker sur Docker Hub
        // ⚠️ Mets ici TON username Docker Hub
        DOCKER_IMAGE = "benkhalifafedi/student-management"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du projet depuis GitHub...'
                git branch: 'main', url: 'https://github.com/Benkhalifafedi/devops.git'
            }
        }

        stage('Build - mvn clean package') {
            steps {
                echo 'Build Maven (clean + package)...'
                bat "mvn clean package"
                // Archive le JAR
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construction de l’image Docker...'
                bat """
                    docker version
                    docker build -t %DOCKER_IMAGE%:%BUILD_NUMBER% .
                    docker tag %DOCKER_IMAGE%:%BUILD_NUMBER% %DOCKER_IMAGE%:latest
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Push de l’image sur Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                        docker push %DOCKER_IMAGE%:%BUILD_NUMBER%
                        docker push %DOCKER_IMAGE%:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Build réussi ! Jar archivé & image Docker poussée sur Docker Hub.'
        }
        failure {
            echo 'Build échoué.'
        }
    }
}
