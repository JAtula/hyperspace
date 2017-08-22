FROM alpine:3.6
MAINTAINER Juhani Atula <juhaniatula@gmail.com>

ADD https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 /usr/local/bin/docker
ARG CLI_VERSION

RUN apk update && \
  apk --update add ruby ruby-json ruby-bigdecimal ruby-io-console \
  ca-certificates libssl1.0 openssl libstdc++ bash bash-completion bash-doc && \
  chmod +x /usr/local/bin/docker

RUN apk --update add --virtual build-dependencies ruby-dev build-base openssl-dev && \
  gem install kontena-cli --no-rdoc --no-ri -v ${CLI_VERSION} && \
  apk del build-dependencies

VOLUME ["/home/kontena"]
WORKDIR /home/kontena
ENTRYPOINT ["/bin/bash"]