#!/bin/bash
set -e

# remove all stoped countainers and dangling images older then 1 hour

exclude_images="node|golang|alpine|gitlab\/gitlab-runner-helper|ubuntu|debian|docker|nginx|willhallonline\/ansible"
periods_to_delete="hour|day|week|month"
waiting=360

function docker_status
  {
    ps aux |tr -s ' '| grep -P " docker ($(docker --help | grep -Po "  [a-z]{2,}"| tr -d ' '| tr -s '\n' '|')) "
  }


# Waiting while all docker jobs are done
while [  ! -z "$(docker_status)" ] && [ ! -z "$(sleep 1 && docker_status)"  ]
do
  echo Docker running, waiting $waiting...
  waiting=$(($waiting-1))
  # Exit script if waiting time is over
  if [[ "$waiting" -le "0" ]]
  then
    echo "Waiting time is over, exiting."
    exit 0
  fi
done

# Get containers ids
containers_ids=$(docker container ls -a | grep -G "Exited "| cut -d' ' -f1 )
# If ids exist - removing
if [ ! -z "$containers_ids" ]
then
  echo "Removing containers:"
  docker container rm $containers_ids
else
  echo "No containers to remove"
fi

# Get images ids
images_ids=$(docker images -a | grep -P "([0-9]{1,2}|About an) ($periods_to_delete)s? ago"| grep -Pv "^($exclude_images)"| grep -Po "[0-9a-z]{12}"||true)
# If ids exist - removing
if [ ! -z "$images_ids" ]
then
  echo "Removing images:"
  docker rmi $images_ids||true
else
  echo "No images to remove"
fi

echo Done.


