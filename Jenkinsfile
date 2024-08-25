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

        stage('Cppcheck') {
            steps {
                echo 'Running Cppcheck...'
                sh 'cppcheck --enable=all --xml --xml-version=2 src/ 2> cppcheck_report.xml'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo 'Checking SonarQube scanner version...'
                sh '/opt/sonar-scanner-4.8.0.2856-linux/bin/sonar-scanner --version'
                
                echo 'Running SonarQube analysis...'
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'TOKEN')]) {
                    sh """
                        /opt/sonar-scanner-4.8.0.2856-linux/bin/sonar-scanner \
                        -Dsonar.projectKey=MyCppProject \
                        -Dsonar.sources=src \
                        -Dsonar.login=${TOKEN} \
                        -Dsonar.host.url=${SONAR_HOST_URL}
                    """
                }
                echo 'SonarQube analysis completed.'
            }
        }
        stage('Unit Tests') {
            steps {
                echo 'Running unit tests...'
                sh './scripts/run_tests.sh'
            }
            post {
                always {
                    junit 'build/test-results.xml'
                }
            }
        }

        stage('Documentation') {
            steps {
                echo 'Generating documentation...'
                sh 'doxygen docs/Doxyfile'
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging the project...'
                sh 'cd ${BUILD_DIR} && cpack'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}
