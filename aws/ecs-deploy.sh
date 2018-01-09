#!/usr/bin/env bash

TIMEOUT=600
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
          echo "AWS default region set to $AWS_DEFAULT_REGION. OK";
    fi

}

# Register the new task definition, and store its ARN
function registerTaskDefinition() {
    echo "Registering revision for task definition based on aws/taskDefinition.json";
    NEW_TASKDEF=`$AWS_ECS register-task-definition --cli-input-json file://$TRAVIS_BUILD_DIR/aws/taskDefinition.json| jq -r .taskDefinition.taskDefinitionArn`
    echo "New task definition: $NEW_TASKDEF";
}

function updateService() {
    # Update the service
    UPDATE=`$AWS_ECS update-service --cluster $CLUSTER --service $SERVICE --task-definition $NEW_TASKDEF`

    # Only excepts RUNNING state from services whose desired-count > 0
    SERVICE_DESIREDCOUNT=`$AWS_ECS describe-services --cluster $CLUSTER --service $SERVICE | jq '.services[]|.desiredCount'`
    if [ $SERVICE_DESIREDCOUNT -gt 0 ]; then
        # See if the service is able to come up again
        every=10
        i=0
        while [ $i -lt $TIMEOUT ]
        do
            # Scan the list of running tasks for that service, and see if one of them is the
            # new version of the task definition

            RUNNING_TASKS=$($AWS_ECS list-tasks --cluster "$CLUSTER"  --service-name "$SERVICE" --desired-status RUNNING \
                | jq -r '.taskArns[]')

            if [[ ! -z $RUNNING_TASKS ]] ; then
                RUNNING=$($AWS_ECS describe-tasks --cluster "$CLUSTER" --tasks $RUNNING_TASKS \
                    | jq ".tasks[]| if .taskDefinitionArn == \"$NEW_TASKDEF\" then . else empty end|.lastStatus" \
                    | grep -e "RUNNING") || :

                if [ "$RUNNING" ]; then
                    echo "Service updated successfully, new task definition running.";

                    if [[ $MAX_DEFINITIONS -gt 0 ]]; then
                        FAMILY_PREFIX=${TASK_DEFINITION_ARN##*:task-definition/}
                        FAMILY_PREFIX=${FAMILY_PREFIX%*:[0-9]*}
                        TASK_REVISIONS=`$AWS_ECS list-task-definitions --family-prefix $FAMILY_PREFIX --status ACTIVE --sort ASC`
                        NUM_ACTIVE_REVISIONS=$(echo "$TASK_REVISIONS" | jq ".taskDefinitionArns|length")
                        if [[ $NUM_ACTIVE_REVISIONS -gt $MAX_DEFINITIONS ]]; then
                            LAST_OUTDATED_INDEX=$(($NUM_ACTIVE_REVISIONS - $MAX_DEFINITIONS - 1))
                            for i in $(seq 0 $LAST_OUTDATED_INDEX); do
                                OUTDATED_REVISION_ARN=$(echo "$TASK_REVISIONS" | jq -r ".taskDefinitionArns[$i]")

                                echo "Deregistering outdated task revision: $OUTDATED_REVISION_ARN"

                              $AWS_ECS deregister-task-definition --task-definition "$OUTDATED_REVISION_ARN" > /dev/null
                            done
                        fi

                    fi
                    break
                fi
            fi

            sleep $every
            i=$(( $i + $every ))
        done
    else
        echo "Skipping check for running task definition, as desired-count <= 0"
    fi
}

function waitForGreenDeployment {
  every=2
  i=0
  echo "Waiting for service deployment to complete..."
  while [ $i -lt $TIMEOUT ]
  do
    NUM_DEPLOYMENTS=$($AWS_ECS describe-services --services $SERVICE --cluster $CLUSTER | jq "[.services[].deployments[]] | length")

    # Wait to see if more than 1 deployment stays running
    if [ $NUM_DEPLOYMENTS -eq 1 ]; then
      echo "Service deployment successful."
      # Exit the loop.
      i=$TIMEOUT
    else
      sleep $every
      i=$(( $i + $every ))
    fi
  done
}

# Check for AWS and AWS Command Line Interface
require aws

# Check for jq, Command-line JSON processor
require jq

# Validate arguments to make sure we have everything we need.
checkRequiredVariables

# Register a new revision for task definition.
registerTaskDefinition

# Update service by adding the revision of task definition created above.
updateService

# Validate if running count has stabilized.
waitForGreenDeployment




