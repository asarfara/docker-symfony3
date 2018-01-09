#! /bin/bash

# This is needed to login on AWS and push the image on ECR
# Change it accordingly to your docker repo
pip install --user awscli
export PATH=$PATH:$HOME/.local/bin
eval $(aws ecr get-login --no-include-email --region $AWS_DEFAULT_REGION | sed 's|https://||')

# Build and push
docker build -t $PHP_IMAGE_NAME -f .docker/php/Dockerfile .
echo "Pushing $PHP_IMAGE_NAME:latest"
docker tag $PHP_IMAGE_NAME:latest "$REMOTE_IMAGE_URL/$PHP_IMAGE_NAME:latest"
docker push "$REMOTE_IMAGE_URL/$PHP_IMAGE_NAME:latest"
echo "Pushed $PHP_IMAGE_NAME:latest"

# Build and push
docker build -t $WEB_IMAGE_NAME -f .docker/web/Dockerfile .
echo "Pushing $WEB_IMAGE_NAME:latest"
docker tag $WEB_IMAGE_NAME:latest "$REMOTE_IMAGE_URL/$WEB_IMAGE_NAME:latest"
docker push "$REMOTE_IMAGE_URL/$WEB_IMAGE_NAME:latest"
echo "Pushed $WEB_IMAGE_NAME:latest"