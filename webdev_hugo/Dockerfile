FROM debian:bookworm-slim 

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y \
  curl \
  tar \
  build-essential \
  gcc \
  g++ \
  make \
  wget \
  go \
  hugo \ 
  nodejs \
  npm \

  && apt-get clean


CMD ["/bin/bash"]
