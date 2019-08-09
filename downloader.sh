#!/bin/bash

set -e
set -o pipefail

# Shitty function to download the articles
get_articles(){
  echo "Started downloading...."
  local number_of_pages=84
  local ids=()

  for number in $(seq 1 $number_of_pages); do
    ids+=$(curl -ks https://api.manshar.com/api/v1/articles?page=$number | jq --raw-output '.[].id')

    for article_id in $ids; do
      curl -ks https://api.manshar.com/api/v1/articles/$article_id -o $article_id.json
    done
  done

}

get_articles
