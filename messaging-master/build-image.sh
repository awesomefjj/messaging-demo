#!/bin/sh
set -e
IMAGE_NAME=$(echo $(git remote get-url origin)|sed -e 's/git@gitlab.tanmer.com:\(.*\).git/docker.corp.tanmer.com\/\1/')
IMAGE_NAME=${@:-$IMAGE_NAME}

branch_name=$(git rev-parse --abbrev-ref HEAD)
# commit_hash=$(git rev-parse --short HEAD)
commit_hash=$(git rev-parse HEAD)
tag=$(git tag --points-at HEAD)

if [[ ! -z $tag ]]; then
  version=/${tag}
elif [[ "$branch_name" == "HEAD" ]]; then
  version=""
else
  version=/${branch_name}
fi

IMAGE_FULLNAME=${IMAGE_NAME}${version}:${commit_hash}

echo Build for ${IMAGE_FULLNAME}, press to continue...
read

# timestamp=$(date +%Y%m%d%H%S)

docker build \
  --build-arg BUNDLE_GEMS__TANMER__COM=${BUNDLE_GEMS__TANMER__COM} \
  -f Dockerfile \
  -t ${IMAGE_FULLNAME} . && echo "

you can push image to out reigistry with this command:
    docker push ${IMAGE_FULLNAME}
"
