#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ $# -eq 0 ]; then
    echo "No arguments provided in $0"
    exit 1
fi
URL="$1"

function check {
    if "$@"; then
        echo "OK"
    else
        echo "FAIL "
    fi
}

function match {
 	echo "$1" | grep --silent "${@:2}" &> /dev/null
}

function test-case {
	echo -n "$@"
}

echo "Test head content:"
HEAD="$(curl --silent --show-error --location "$URL" | tr -d "\n" | grep -o '<head>.*</head>')"


test-case "og:title - "
check match "$HEAD" "<meta property=[\"']og:title[\"'] content=[\"'][^>]\+[\"']>"
 
test-case "description - "
check match "$HEAD" "<meta \(property\|name\)=[\"']\(og:\)\?description[\"'] content=[\"'][^>]\+[\"']>"
    

