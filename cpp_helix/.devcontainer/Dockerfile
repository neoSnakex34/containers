# consider using debian trixie in the future
# for now oldstable is more easy

FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y \
  jq \
  curl \
  tar \
  build-essential \
  gcc \
  g++ \
  gdb \
  clangd \
  valgrind \
  cmake \
  curl \

  && apt-get clean
  
COPY ./scripts/postcreate.sh /usr/local/bin/postcreate.sh
RUN chmod +x /usr/local/bin/postcreate.sh


# CMD ["bash"]
