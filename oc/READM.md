# Create Application 
```
oc new-app https://github.com/RedHatWorkshops/welcome-php --name myapp
```
## Now apply openshift-client taskrun to do rollout
```
oc create -f oc/oc-taskrun.yaml
```
