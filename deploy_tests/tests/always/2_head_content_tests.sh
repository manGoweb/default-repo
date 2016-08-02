#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function check {
    if "$@"; then
        echo "OK"
    else
        echo "FAIL "
    fi
}

function match {
  echo "$1" | grep "${@:2}" &> /dev/null
}

echo "Test head content:"
HEAD="$(curl --silent --show-error --location "$1" | tr -d "\n" | grep -o '<head>.*</head>')"


echo -n "og:title - "
check match "$HEAD" "<meta property=[\"']og:title[\"'] content=[\"'][^>]\+[\"']>"
 
echo -n "description - "
check match "<meta \(property\|name\)=[\"']\(og:\)\?description[\"'] content=[\"'][^>]\+[\"']>"
    

