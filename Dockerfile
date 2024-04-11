FROM debian:bookworm as app
LABEL package=bicalho
RUN apt update && \
    apt dist-upgrade --yes

WORKDIR /app


FROM app as test
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

  COPY ./tests /usr/bin/tests
  RUN chmod +x /usr/bin/tests

  RUN useradd \
    --system \
    --shell /usr/bin/zsh \
    --uid 1001 \
    test

USER test

CMD [ "/usr/bin/tests" ]
