pipeline {
    agent any

    tools {
        // Nom EXACT du Maven configuré dans Manage Jenkins -> Global Tool Configuration
        maven 'Maven3'
    }

    environment {
        // Nom de l'image Docker sur Docker Hub (avec TON username)
        DOCKER_IMAGE = "fedibenkhalifa/student-management"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du projet depuis GitHub...'
                git branch: 'main', url: 'https://github.com/Benkhalifafedi/devops.git'
            }
        }
 stage('Deploy to Kubernetes') {
    steps {
        echo 'Déploiement sur le cluster K8s...'
        bat """
            kubectl apply -n devops -f student-management/K8s/mysql-k8s.yaml
            kubectl apply -n devops -f student-management/K8s/spring-config.yaml
            kubectl apply -n devops -f student-management/K8s/spring-deployment.yaml
        """
    }
}



        stage('Build - mvn clean package') {
            steps {
                echo 'Build Maven (clean + package)...'
                bat "mvn clean package"
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        // 🔍 Analyse SonarQube
        stage('SonarQube Analysis') {
            steps {
                // "sonarqube" = le Name défini dans Manage Jenkins > SonarQube servers
                withSonarQubeEnv('sonarqube') {
                    bat 'mvn -B verify sonar:sonar'
                }
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
                    script {
                        // Login Docker Hub
                        bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'

                        // ✅ Push du tag numéroté (obligatoire)
                        bat 'docker push %DOCKER_IMAGE%:%BUILD_NUMBER%'

                        // ⚠️ Push du tag latest : s’il échoue, on affiche un warning mais on ne casse pas le build
                        def status = bat(
                            returnStatus: true,
                            script: 'docker push %DOCKER_IMAGE%:latest'
                        )

                        if (status != 0) {
                            echo "⚠️ Push du tag 'latest' échoué (code=${status}) mais on continue le pipeline."
                        }
                    }
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
