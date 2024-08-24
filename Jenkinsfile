pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'echo "Hello, World!"'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}
