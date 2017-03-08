#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ $# -ne 2 ]; then
    echo "Usage: $0 beta|prod url"
    exit 1
fi
STAGE="$1"
URL="$2"


for TEST_CASE in deploy_tests/tests/{$STAGE,always}/*.sh
do
	/usr/bin/env bash "$TEST_CASE" "$URL"
	echo ""
done

echo "post-deploy tests finished"
