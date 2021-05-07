#!/bin/sh
tag=$(git describe --tags --exact-match 2> /dev/null)
if [ -z $tag ]; then
  branch=$(git symbolic-ref -q --short HEAD)
  if [ -z $branch ]; then
    commit=$(git rev-parse --short HEAD)
  fi
fi

if [[ ! -z $tag ]]; then
  echo releases/${tag}
elif [[ ! -z $branch ]]; then
  echo ${branch/\//-}
else
  echo commits
fi
