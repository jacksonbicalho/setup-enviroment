#!/bin/bash

set -e


images=(01-shellspec-kcov-debian-bullseye-slin)
images+=(01-shellspec-kcov-ubuntu-22.04)
images+=(01-shellspec-kcov-debian-bookworm)

for image in "${images[@]}"; do
  IMAGE=jacksonbicalho/setup-enviroment:"$image" docker compose \
  -f docker-compose.tests.yaml \
  run \
    -u root \
    shellspec \
    --kcov \
    --covdir "$image-coverage" \
    --reportdir "$image-report" \
    --format d \
    --output documentation
done
