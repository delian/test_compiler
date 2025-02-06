FROM mcr.microsoft.com/devcontainers/base:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN sudo apt update && \
    sudo apt upgrade -y && \
    sudo apt install -y cmake ninja-build python3-pip build-essential bison flex gdb && \
    sudo pip install conan
