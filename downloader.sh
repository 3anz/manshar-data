#!/bin/bash

set -e
set -o pipefail

# Stolen from: https://unix.stackexchange.com/a/415450/162906
prog() {
    local w=80 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /.};
    # print those dots on a fixed-width space plus the percentage etc. 
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
}

# Shitty function to download the articles
get_articles(){
  echo "Started downloading...."
  local number_of_pages=84

  for number in $(seq 1 $number_of_pages); do
    local ids=()

    prog "$number"

    ids+=$(curl -ks https://api.manshar.com/api/v1/articles?page=$number | jq --raw-output '.[].id')

    for article_id in $ids; do
      curl -ks https://api.manshar.com/api/v1/articles/$article_id -o $article_id.json
    done

    unset ids
  done

}

get_articles
