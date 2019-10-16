        echo "Run shell scripts linting!"
        ./test/lint-scripts.sh
       export  CHART_TESTING_IMAGE=quay.io/helmpack/chart-testing
       export  CHART_TESTING_TAG=v2.3.3
       export  TEST_IMAGE=gcr.io/kubernetes-charts-ci/test-image
       export  TEST_IMAGE_TAG=v3.3.2
       export  CHARTS_REPO=https://github.com/ygqygq2/charts
       export  K8S_VERSION=v1.15.3
       export  KIND_VERSION=v0.5.1
       export  KUBEVAL_VERSION=0.13.0
       export  HELM_VERSION=v2.14.2
       export  CHART_TESTING_ARGS=""
         echo "Run chart-testing linting!"
         ./test/lint-charts.sh 
         echo "lint chart $?"
          if cat tmp/lint.log | grep "No chart changes detected" > /dev/null; then
              echo "No chart changes detected, stopping TravisCI pipeline!"
              exit 0
          fi
        echo "Run charts-testing install test!"
        # https://docs.travis-ci.com/user/common-build-problems/#build-times-out-because-no-output-was-received
        ./test/e2e-github.sh

