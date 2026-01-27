#!/bin/bash

set -euo pipefail
set -x

if [ -z "${OVH_APPLICATION_KEY}" ]; then
  echo "OVH_APP_KEY is not set"
  exit 1
fi

curl -H "Content-type: application/json" -H "X-Ovh-Application: ${OVH_APPLICATION_KEY}" https://eu.api.ovh.com/1.0/auth/credential \
  -d '{"accessRules": [{"method": "GET", "path": "/*"}, {"method": "POST", "path": "/*"}, {"method": "DELETE", "path": "/*"}, {"method": "PUT", "path": "/*"}]}'
