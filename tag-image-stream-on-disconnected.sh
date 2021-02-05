#!/bin/bash

if [ -z $MIRROR_REG ]; then
  echo "You need to specify mirror registry URL in variable MIRROR_REG"
  exit 1
fi

./get-image-stream-tags.sh "$1" | grep "$2" | grep 'quay.io\|redhat.com\|redhat.io' | while read -r line; do
  IMAGE_STREAM=($line)
  TAG=${IMAGE_STREAM[0]}
  ORIG_IMAGE=${IMAGE_STREAM[1]}
  MIRR_IMAGE=$(cut -d "/" -f2- <<< $ORIG_IMAGE)

  echo -e "\nMirroring image $ORIG_IMAGE for tag $TAG"
  skopeo copy --all docker://$ORIG_IMAGE docker://$MIRROR_REG/$MIRR_IMAGE --dest-tls-verify=false --authfile=authfile
  oc tag $MIRROR_REG/$MIRR_IMAGE $TAG -n openshift
done

