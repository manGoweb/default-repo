#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


STAGE=prod
URL='mangoweb.cz'


for TEST_CASE in deploy_tests/tests/{$STAGE,always}/*.sh
do
	/usr/bin/env bash "$TEST_CASE" "$URL"
	echo ""
done
