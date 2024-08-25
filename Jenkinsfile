pipeline {
    agent any

    environment {
        BUILD_DIR = "build"
    }

    stages {
        stage('Clean Build Directory') {
            steps {
                echo 'Cleaning previous build directories...'
                sh 'rm -rf ${BUILD_DIR}/*'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR} && cmake .. && make'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}
