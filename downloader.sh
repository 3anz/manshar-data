#!/bin/bash

set -euo pipefail

prog() {
    local p=$1

    printf "${p} downloaded \n";
}

# Shitty function to download the data
fetch_data(){
  local number_of_pages=$2
  local query=$1

  for number in $(seq 1 $number_of_pages); do
    local ids=()

    ids+=$(curl -ks https://api.manshar.com/api/v1/$query?page=$number | jq --raw-output '.[].id')

    if [ $3 == "article_ids" ]; then
      echo $ids
      continue
    fi

    prog $number
    for resource_id in $ids; do
      curl -ks https://api.manshar.com/api/v1/$query/$resource_id -o $resource_id.json
    done

    unset ids
  done

}

users_data(){
  local users="users"
  local users_pages_count=27

  fetch_data $users $users_pages_count
}

comments_data(){
  local articles_pages_count=84
  local articles="articles"
  local flag="article_ids"

  for article_id in $(fetch_data $articles $articles_pages_count $flag); do
    prog $article_id

    curl -ks https://api.manshar.com/api/v1/articles/$article_id/comments -o ${article_id}_comments.json
  done
}

comments_data
