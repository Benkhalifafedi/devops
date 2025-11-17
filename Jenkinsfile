pipeline {
    agent any

    tools {
        jdk 'JDK17'      // adapte au nom de ton JDK dans Jenkins
        maven 'M3'       // adapte au nom de ta config Maven dans Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                echo '🔁 Récupération du projet depuis GitHub...'
                git branch: 'main', url: 'https://github.com/Benkhalifafedi/devops.git'
            }
        }

        stage('Build - mvn clean package') {
            steps {
                echo '⚙️ Build Maven (clean + package)...'
                bat 'mvn clean package'
            }
        }
    }

    post {
        success {
            echo '✅ Build réussi ! Archivage des artefacts...'
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        failure {
            echo '❌ Build échoué, vérifier les logs.'
        }
    }
}
