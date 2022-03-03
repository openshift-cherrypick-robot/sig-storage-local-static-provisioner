#!/bin/bash

# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT

if ! which golint > /dev/null; then
    go get -u golang.org/x/lint/golint
fi

PKGS=($(go list ./... | grep -v /vendor/))

errors=$(golint ${PKGS[*]} | grep -v -P '(zz_generated\.\w+\.go|generated\.pb\.go)') || true 

if [[ -n "${errors}" ]]; then
    echo "${errors}"
    exit 1
else
    echo "$0 passed"
fi
