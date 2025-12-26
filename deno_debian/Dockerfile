FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y curl wget unzip && \  
    curl -fsSL https://deno.land/install.sh | sh

ENV PATH="~/.deno/bin/:${PATH}"
   

WORKDIR /app
