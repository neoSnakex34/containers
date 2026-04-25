FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libc6-dev \
    gdb \
    clangd \
    valgrind \
    cmake \
    curl \
    tar \
    jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
