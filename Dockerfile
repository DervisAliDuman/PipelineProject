FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    build-essential cmake clang g++ \
    clang-tidy sonar-scanner

COPY . /app
WORKDIR /app
RUN mkdir build && cd build && cmake .. && make
CMD ["./build/MyProject"]
