#!/bin/bash

source /scripts/common.sh
source /scripts/bootstrap-helm.sh


run_tests() {
    echo Running tests...

    wait_pod_ready substrate-telemetry-backend-core default 2/2
    wait_pod_ready substrate-telemetry-backend-shard
    wait_pod_ready substrate-telemetry-frontend
}

teardown() {
    helm delete substrate-telemetry
}

main(){
    if [ -z "$KEEP_W3F_SUBSTRATE_TELEMETRY" ]; then
        trap teardown EXIT
    fi

    /scripts/build-helm.sh \
        --set environment=ci \
        --set image.tag="${CIRCLE_SHA1}" \
        substrate-telemetry \
        ./charts/substrate-telemetry

    run_tests
}

main
