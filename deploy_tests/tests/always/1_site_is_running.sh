#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ $# -ne 1 ]; then
    echo "Usage: $0 url"
    exit 1
fi
URL="$1"


echo -n "Test site return code - "

RETURN_CODE="$(curl "$URL" --silent --show-error --head --location --output /dev/null --write-out '%{http_code}')"
if [[ "$RETURN_CODE" != "200" ]]; then
    echo "failed: $RETURN_CODE"
    exit 1
fi
echo "200 OK"

