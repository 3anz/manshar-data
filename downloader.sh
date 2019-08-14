#!/bin/bash

set -euo pipefail

# Stolen from: https://unix.stackexchange.com/a/415450/162906
prog() {
    local w=80 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /.};
    # print those dots on a fixed-width space plus the percentage etc. 
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
}

# Shitty function to download the data
fetch_data(){
  echo "Started downloading...."
  local number_of_pages=$2
  local query=$1

  for number in $(seq 1 $number_of_pages); do
    local ids=()

    prog "$number"

    ids+=$(curl -ks https://api.manshar.com/api/v1/$query?page=$number | jq --raw-output '.[].id')

    for resource_id in $ids; do
      curl -ks https://api.manshar.com/api/v1/$query/$resource_id -o $resource_id.json
    done

    unset ids
  done

}

users="users"
articles="articles"
users_pages_count=27
articles_pages_count=84

fetch_data $users $users_pages_count
