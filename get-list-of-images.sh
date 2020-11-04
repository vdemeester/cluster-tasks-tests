#!/bin/bash

if [ ! -z $1 ]; then
  CLUSTERTASKS=$1
else
  CLUSTERTASKS="$(ls -d */)"
fi

for CT in $CLUSTERTASKS; do
  CT=${CT%%/*}
  echo "--- $CT ---"
  #echo $(oc get clustertask $CT -o yaml | grep "image-registry\|gcr\|access.redhat.com\|quay.io")
  echo $(oc get clustertask $CT -o yaml | yq '.spec' | grep "image-registry\|gcr\|access.redhat.com\|redhat.io\|quay.io")
  echo
done

#kubectl get clustertasks  -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.steps[*]}{.image}{", "}{end}{end}' |sort