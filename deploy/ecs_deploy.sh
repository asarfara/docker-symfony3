#! /bin/bash
# Deploy only if it's not a pull request
if [ -z "$TRAVIS_PULL_REQUEST" ] || [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  # Deploy only if we're testing the master branch
  if [ "$TRAVIS_BRANCH" == "develop" ]; then
    echo "Deploying $TRAVIS_BRANCH on $TASK_DEFINITION"
    $TRAVIS_BUILD_DIR/deploy/ecs-deploy.sh -c docker-test-symfony -n $SERVICE -i $REMOTE_IMAGE_URL/$PHP_IMAGE_NAME:latest
    $TRAVIS_BUILD_DIR/deploy/ecs-deploy.sh -c docker-test-symfony -n $SERVICE -i $REMOTE_IMAGE_URL/$WEB_IMAGE_NAME:latest
  else
    echo "Skipping deploy because it's not an allowed branch"
  fi
else
  echo "Skipping deploy because it's a PR"
fi