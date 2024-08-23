pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh './scripts/build.sh'
            }
        }
        stage('Lint') {
            steps {
                sh 'clang-tidy src/*.cpp -- -std=c++17'
            }
        }
        stage('Static Analysis') {
            steps {
                sh 'sonar-scanner'
            }
        }
        stage('Test') {
            steps {
                sh './scripts/run_tests.sh'
            }
        }
    }
    post {
        always {
            junit 'build/test-results.xml'
        }
    }
}
