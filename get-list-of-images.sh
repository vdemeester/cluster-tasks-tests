#!/bin/bash

CLUSTERTASKS="$(ls -d */)"

for CT in $CLUSTERTASKS; do
  CT=${CT%%/*}
  echo "--- $CT ---"
  #echo $(oc get clustertask $CT -o yaml | grep "image-registry\|gcr\|access.redhat.com\|quay.io")
  echo $(oc get clustertask $CT -o yaml | yq '.spec' | grep "image-registry\|gcr\|access.redhat.com\|redhat.io\|quay.io")
  echo
done

