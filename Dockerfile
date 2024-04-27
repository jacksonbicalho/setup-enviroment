FROM debian:bookworm as app
LABEL package=bicalho
RUN apt update && \
    apt dist-upgrade --yes

WORKDIR /app


FROM app as tests
ARG DOCKER_USER_UID
ENV DOCKER_USER_UID=${DOCKER_USER_UID}
RUN apt update && \
  apt dist-upgrade --yes && \
  apt install --yes \
  build-essential \
  binutils-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  zlib1g-dev \
  libdw-dev \
  libiberty-dev \
  python3 \
  cmake \
  wget \
  git



RUN wget -O- https://git.io/shellspec | sh -s -- --yes --prefix /usr

RUN git config --global init.defaultBranch master && \
    git clone https://github.com/SimonKagstrom/kcov.git && \
        cd kcov && \
        mkdir build && \
        cd build && \
        cmake ..  && \
        make  && \
        make install

COPY ./scripts/docker-tests-entrypoint /usr/local/bin/

RUN useradd \
  --shell /usr/bin/zsh \
  --uid ${DOCKER_USER_UID} \
  test

USER test

ENTRYPOINT ["docker-tests-entrypoint"]
