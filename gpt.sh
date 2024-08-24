#!/bin/bash

# Proje ismi
PROJECT_NAME="my-cpp-project"

# Proje dizinini oluştur
echo "Proje dizini oluşturuluyor..."
mkdir -p $PROJECT_NAME/{src,include,tests,docs,scripts,build}

# src dizinine main.cpp ve utils.cpp'yi ekle
echo "Kaynak dosyaları oluşturuluyor..."
cat <<EOL > $PROJECT_NAME/src/main.cpp
#include "utils.h"
#include <iostream>

int main() {
    std::cout << "Result: " << add(5, 10) << std::endl;
    return 0;
}
EOL

cat <<EOL > $PROJECT_NAME/src/utils.cpp
#include "utils.h"

int add(int a, int b) {
    return a + b;
}
EOL

# include dizinine utils.h'yi ekle
cat <<EOL > $PROJECT_NAME/include/utils.h
#ifndef UTILS_H
#define UTILS_H

int add(int a, int b);

#endif // UTILS_H
EOL

# Test dosyalarını oluştur
echo "Test dosyaları oluşturuluyor..."
cat <<EOL > $PROJECT_NAME/tests/test_utils.cpp
#include "utils.h"
#include <cassert>

int main() {
    assert(add(1, 2) == 3);
    assert(add(10, 20) == 30);
    return 0;
}
EOL

# CMakeLists.txt oluştur
echo "CMakeLists.txt oluşturuluyor..."
cat <<EOL > $PROJECT_NAME/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)

project(MyCppProject VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include_directories(include)
add_executable(MyCppProject src/main.cpp src/utils.cpp)

enable_testing()
add_executable(run_tests tests/test_utils.cpp src/utils.cpp)
add_test(NAME RunTests COMMAND run_tests)
EOL

# Jenkinsfile oluştur
echo "Jenkinsfile oluşturuluyor..."
cat <<EOL > $PROJECT_NAME/Jenkinsfile
pipeline {
    agent any

    environment {
        BUILD_DIR = "build"
        SONAR_TOKEN = credentials('SONAR_TOKEN')
    }

    stages {
        stage('Clean') {
            steps {
                echo 'Cleaning previous build artifacts...'
                sh 'rm -rf \${BUILD_DIR}'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'mkdir -p \${BUILD_DIR} && cd \${BUILD_DIR} && cmake .. && make'
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
                echo 'Running SonarQube analysis...'
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'TOKEN')]) {
                    sh "sonar-scanner -Dsonar.projectKey=MyCppProject -Dsonar.sources=src -Dsonar.login=\${TOKEN}"
                }
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
                sh 'cd \${BUILD_DIR} && cpack'
            }
        }
    }

    post {
        always {
            echo 'Cleaning workspace...'
            deleteDir()
        }
    }
}
EOL

# SonarQube ayar dosyasını oluştur
echo "SonarQube ayar dosyası oluşturuluyor..."
cat <<EOL > $PROJECT_NAME/sonar-project.properties
sonar.projectKey=MyCppProject
sonar.projectName=MyCppProject
sonar.projectVersion=1.0
sonar.sources=src
sonar.language=cpp
sonar.sourceEncoding=UTF-8
EOL

# Doxygen konfigürasyonunu oluştur
echo "Doxygen yapılandırma dosyası oluşturuluyor..."
cat <<EOL > $PROJECT_NAME/docs/Doxyfile
PROJECT_NAME = "MyCppProject"
OUTPUT_DIRECTORY = docs/output
INPUT = src include
RECURSIVE = YES
GENERATE_LATEX = NO
GENERATE_HTML = YES
EOL

# Test scripti oluştur
echo "Test scripti oluşturuluyor..."
cat <<EOL > $PROJECT_NAME/scripts/run_tests.sh
#!/bin/bash
cd build
ctest --output-on-failure
EOL
chmod +x $PROJECT_NAME/scripts/run_tests.sh

# Build scripti oluştur
echo "Build scripti oluşturuluyor..."
cat <<EOL > $PROJECT_NAME/scripts/build_project.sh
#!/bin/bash
mkdir -p build
cd build
cmake ..
make
EOL
chmod +x $PROJECT_NAME/scripts/build_project.sh

echo "Proje başarıyla oluşturuldu."
