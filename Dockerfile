FROM debian:bookworm
LABEL package=bicalho
RUN apt update && \
    apt dist-upgrade --yes && \
    apt install --yes \
    sudo
WORKDIR /app
