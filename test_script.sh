#!/bin/bash
set -e

last_command="$3"
script="$2"
script_name=$(echo $script| cut -d' ' -f1)
echo $script_name
docker_image="$1"

if [[ -f $script_name ]]
then
  docker container stop $script_name 2>&1 > /dev/null|true
  docker container rm $script_name 2>&1 > /dev/null|true
  docker image rm $script_name 2>&1 > /dev/null|true
  echo "FROM $docker_image" > Dockerfile
  echo "COPY $script_name ." >> Dockerfile
  echo "CMD ./$script &&$last_command&& exit 0" >> Dockerfile
  docker build . -t $script_name
  docker run --name $script_name  $script_name
  [[ $? ]] && echo "It work!" || echo "Script done with error exit code!"
else
  echo "Script $script_name not exist."
  echo 'Usage:   ./test_script.sh DOCKER_IMAGE:TAG    "SCRIPT_NAME SCRIPT_ARGS"    "CHECK_COMMAND CHECK_ARGS"'
  echo 'Example: ./test_script.sh debian:buster-slim "install_docker.sh debian" "docker run hello-world"'
fi
