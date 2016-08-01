#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function check {
    if [[ $? -eq 0 ]]; then
        echo "OK"
    else
        echo "FAIL"
        return_value=1
    fi
}

return_value=0

head=`curl -sSL "$1" | tr -d "\n" | grep -o '<head>.*</head>'`
echo "Test head content:"

echo -n "og:title - "
echo "$head" | grep "<meta property=[\"']og:title[\"'] content=[\"'][^>]\+[\"']>" > /dev/null
check
 
echo -n "description - "
echo "$head" | grep "<meta \(property\|name\)=[\"']\(og\)\?description[\"'] content=[\"'][^>]\+[\"']>" > /dev/null
check
    
exit $return_value
