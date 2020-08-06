#!/bin/bash

CLUSTERTASKS="$(ls -d */)"

for CT in $CLUSTERTASKS; do
  CT=${CT%%/*}
  echo "--- $CT ---"
  echo $(oc get clustertask $CT -o yaml | yq '.metadata.labels' | grep "provider-type")
  echo
done

