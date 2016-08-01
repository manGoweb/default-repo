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

printf "Test head content:\n"
head=`curl -sSL "$1" | tr -d "\n" | grep -o '<head>.*</head>'`

printf "og:title - "
printf "$head" | grep "<meta property=[\"']og:title[\"'] content=[\"'][^>]\+[\"']>" > /dev/null
check
 
printf "description - "
printf "$head" | grep "<meta \(property\|name\)=[\"']\(og\)\?description[\"'] content=[\"'][^>]\+[\"']>" > /dev/null
check
    
exit $return_value
