pipeline {
    agent any

    tools {
        // Nom EXACT du Maven configuré dans Manage Jenkins -> Global Tool Configuration
        maven 'Maven3'
    }

   environment {
    // Nom de l'image Docker sur Docker Hub
    // ⚠️ Mets bien TON username Docker Hub ici
    DOCKER_IMAGE = "fedibenkhalifa/student-management"
}


    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du projet depuis GitHub...'
                git branch: 'main', url: 'https://github.com/Benkhalifafedi/devops.git'
            }
        }
           // 🔍 NOUVEAU STAGE SONAR
        stage('SonarQube Analysis') {
            steps {
                // "sonarqube" = le Name défini dans Manage Jenkins > SonarQube servers
                withSonarQubeEnv('sonarqube') {
                    bat 'mvn -B verify sonar:sonar'
                }
            }
        }

        stage('Build - mvn clean package') {
            steps {
                echo 'Build Maven (clean + package)...'
                bat "mvn clean package"
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
