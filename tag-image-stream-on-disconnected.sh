#!/bin/bash

if [ -z $MIRROR_REG ]; then
  echo "You need to specify mirror registry URL in variable MIRROR_REG"
  exit 1
fi

if [[ "$1" == "fedora" ]]; then
  IMAGE_STREAMS=$(oc get is fedora -o json | jq -r '.metadata.name as $is | .spec.tags[] | $is + ":" + .name + " " + .from.name')
  NAMESPACE=${NAMESPACE:-catalog-tests}
else
  IMAGE_STREAMS=$(./get-image-stream-tags.sh "$1")
  NAMESPACE=openshift
fi

echo "$IMAGE_STREAMS" | grep "$2" | grep 'quay.io\|redhat.com\|redhat.io' | while read -r line; do
  IMAGE_STREAM=($line)
  echo "Processing $IMAGE_STREAM"
  TAG=${IMAGE_STREAM[0]}
  ORIG_IMAGE=${IMAGE_STREAM[1]}
  MIRR_IMAGE=$(cut -d "/" -f2- <<< $ORIG_IMAGE)
  MIRR_IMAGE2=$(cut -d "@" -f1 <<< $MIRR_IMAGE)

  echo -e "\nMirroring image $ORIG_IMAGE for tag $TAG"
  #skopeo copy --all docker://$ORIG_IMAGE docker://$MIRROR_REG/$MIRR_IMAGE --dest-tls-verify=false --authfile=authfile
  oc image mirror $ORIG_IMAGE $MIRROR_REG/$MIRR_IMAGE2 --keep-manifest-list=true --filter-by-os=".*" -a authfile --insecure
  oc tag $MIRROR_REG/$MIRR_IMAGE $TAG -n $NAMESPACE --scheduled=true
done

