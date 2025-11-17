pipeline {
    agent any

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
                // Windows → bat, Linux → sh
                bat 'mvn clean package'
            }
        }
    }

    post {
        success {
            echo 'Build réussi ! Archivage des artefacts...'
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        failure {
            echo 'Build échoué, vérifier les logs.'
        }
    }
}
