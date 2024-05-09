#!/bin/bash
#
# test runner

set -e

#######################################
# docker_image array
# array com as imagens docker a serem usadas nos testes
# Para cada imagem docker declarada, será criado um diretório para
# coveraga e report
#######################################
docker_images=(
  01-shellspec-kcov-debian-bullseye-slin
  01-shellspec-kcov-ubuntu-22.04
  01-shellspec-kcov-debian-bookworm
)

function main() {
  for docker_image in "${@}"; do
    IMAGE=jacksonbicalho/setup-enviroment:"$docker_image" docker-compose \
      -f docker-compose.test.yaml \
      run \
      -u root \
      --rm \
      shellspec \
      --kcov \
      --covdir "$docker_image-coverage" \
      --format d \
      --reportdir "$docker_image"-report \
      --output documentation
  done
}

main "${docker_images[@]}"
