#!/bin/bash

# Proje kök dizini
PROJECT_NAME="MyProject"
cd $PROJECT_NAME

# GoogleTest Submodule ekleme
git submodule add https://github.com/google/googletest.git
git submodule update --init

# .clang-tidy dosyasını oluşturma
cat <<EOF > .clang-tidy
Checks: '*, -llvm-*, -cert-*, -google-*'
EOF

# SonarQube yapılandırması
cat <<EOF > sonar-project.properties
sonar.projectKey=MyProject
sonar.sources=src
sonar.tests=tests
sonar.cfamily.build-wrapper-output=build_wrapper_output_directory
sonar.cfamily.threads=4
EOF

# CPack ile Paketleme
# (Zaten CMakeLists.txt'ye eklenmişti)

# Doxygen Dokümantasyonunu Oluşturma
cat <<EOF > Doxyfile
# Doxyfile configuration file
PROJECT_NAME           = MyProject
OUTPUT_DIRECTORY       = docs
CREATE_SUBDIRS         = YES
RECURSIVE              = YES
GENERATE_HTML          = YES
GENERATE_XML           = YES
EXTRACT_ALL            = YES
EOF

# CMake ile cross-platform ayarları
# (Gerekli düzenlemeler CMakeLists.txt'de yapılabilir)

# Güvenlik araçları ve performans analizi
# (Ek komutlar burada belirtilebilir, örneğin cppcheck)

# Dockerfile'ı optimize et
cat <<EOF > Dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y \\
    build-essential cmake clang g++ \\
    clang-tidy sonar-scanner cppcheck

COPY . /app
WORKDIR /app
RUN mkdir build && cd build && cmake .. && make
CMD ["./build/MyProject"]
EOF

echo "Eksiklikler tamamlandı ve yapılandırmalar güncellendi."
