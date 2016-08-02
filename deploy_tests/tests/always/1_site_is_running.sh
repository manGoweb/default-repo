#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo -n "Test site return code - "

RETURN_CODE="$(curl "$1" --silent --show-error --head --location --output /dev/null --write-out '%{http_code}')"
if [[ "$RETURN_CODE" != "200" ]]; then
    echo "failed: $RETURN_CODE"
    exit 1
else
	echo "200 OK"
fi
