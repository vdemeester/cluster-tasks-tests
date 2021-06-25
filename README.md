# Test suite for OpenShift Pipelines cluster tasks

## Prerequisites

* Install OpenShift Pipelines operator
* Install OpenShift Serverless operator
* (On disconnected cluster) mirror images used by standard image streams

## Run cluster tasks E2E tests

The test suite runs in namespace `catalog-tests` by default. It's recommended to use a custom namespace
so that it doesn't interfere with another run, e.g.

```
export NAMESPACE=my-catalog-tests
```

When running the test suite for the first time, run

```
./demo prepare
```

Followingly, start the tests

```
./demo test                (to run all tests)
./demo test buildah s2i-go (to run buildah and s2i-go tests)
./demo test s2i-*          (to run s2i-go, s2i-java, s2i-perl etc.)
./demo test-disconnected   (to run selected tests specific to disconnected clusters)
```

## Re-running the same test

It's not possible to run the same tests twice without first removing the pipeline (by design, safer approach).
Run one of these commands

```
 ./demo prepare
 oc delete project $NAMESPACE
```

## Notes for Maven tasks

Tasks `maven` and `jib-maven` require Maven image which is not hard-coded so that the test work on multiple
architectures. It will be automatically populated for you when you run the test but be aware that you need
to revert the change when task or image changes. Run the following command to identify which image you use:

```
git diff jib-maven maven
```
