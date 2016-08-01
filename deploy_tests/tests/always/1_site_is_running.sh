#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

printf "Test site return code - "

response=$(curl -sSLI "$1" 2>&1)
if [[ $? -eq 0 ]]; then
    return_codes=`printf "$response" | grep 'HTTP/1.1'`
    ok_return_code=`printf "$return_codes" | grep '200 OK' | cut -d" " -f2`
    if [[ "$ok_return_code" = '200' ]]; then
    	echo "OK $ok_return_code"
    	exit 0
    else
    	echo "failed: $return_codes"
    	exit 1
    fi
else
	echo "failed: $response"
	exit 1
fi
