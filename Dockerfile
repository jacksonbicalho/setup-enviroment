FROM jacksonbicalho/shellspec-kcov
LABEL package=bicalho
RUN apt update && \
    apt dist-upgrade --yes

WORKDIR /app

