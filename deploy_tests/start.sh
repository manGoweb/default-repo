#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Předpokládm nějakou hodnotu (prod/live) v prom $stage
stage=prod
# v druhém parametru je url
url='https://mangoweb.cz'


for test in `find deploy_tests/tests -regex 'deploy_tests/tests/'"$stage"'/.*\.sh' -o -regex 'deploy_tests/tests/always/.*\.sh'`
do
	"$test" "$url"
	printf "\n"
done
