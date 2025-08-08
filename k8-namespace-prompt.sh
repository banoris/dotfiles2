#!/usr/bin/env bash

__k8_ps1() {
    # Get current context, filter to the format: <CLUSTER>/<NAMESPACE>
    # E.g., mycluster01/mynamespace01
    CONTEXT=$(kubectl config current-context | awk -F'/' '{split($2, A, "-"); print A[2] "/" $1}' 2> /dev/null)

    if [ -n "$CONTEXT" ]; then
        echo "${CONTEXT}"
    fi
}
