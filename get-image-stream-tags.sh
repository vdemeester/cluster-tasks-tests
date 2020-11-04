#!/bin/bash

if [ ! -z $1 ]; then
  image_streams=($1)
else
  image_streams=("cli" "dotnet" "golang" "java" "nodejs" "perl" "php" "python" "ruby")
fi

for IS in "${image_streams[@]}"; do
  oc get is $IS -n openshift -o json | jq -r '.metadata.name as $is | .spec.tags[] | $is + ":" + .name + " " + .from.name'
done
