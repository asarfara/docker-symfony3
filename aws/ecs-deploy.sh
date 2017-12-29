#!/usr/bin/env bash

AWS_CLI=$(which aws)
AWS_ECS="$AWS_CLI --output json ecs"

# Check requirements
function require() {
    command -v "$1" > /dev/null 2>&1 || {
        echo "Some of the required software is not installed:"
        echo "    please install $1" >&2;
        exit 4;
    }
}

# Validate all variables are set correctly
function checkRequiredVariables() {

    if [ -z ${AWS_ACCESS_KEY_ID+x} ];
        then
            unset AWS_ACCESS_KEY_ID;
        else
            echo "AWS access key provided. OK";
    fi

    if [ -z ${AWS_SECRET_ACCESS_KEY+x} ];
        then
            unset AWS_SECRET_ACCESS_KEY;
        else
            echo "AWS secret access key provided. OK";
    fi

    if [ -z ${AWS_DEFAULT_REGION+x} ];
      then
          unset AWS_DEFAULT_REGION
      else
          AWS_ECS="$AWS_ECS --region $AWS_DEFAULT_REGION"
          echo "AWS default region provided. OK";
    fi

}

function registerTaskDefinition() {
    echo "Registering revision for task definition based on aws/taskDefinition.json";
    $AWS_ECS register-task-definition --cli-input-json file://$TRAVIS_BUILD_DIR/aws/taskDefinition.json
}

# Check for AWS, AWS Command Line Interface
require aws

checkRequiredVariables
registerTaskDefinition

# Todo: Make task definition a cli argument.




