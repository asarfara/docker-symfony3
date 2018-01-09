# Docker Symfony 3 project

A Symfony 3 project created in docker with continuous deployment using travis and AWS ECS.

## INSTALL

- Clone this repo
- Make sure that you have Docker installed and running
- Run composer install -d symfony
- Run docker-compose up -d
- Run http://localhost/ in your browser. You should see the symfony 3 default page.

## Travis

- Travis works in two stages i.e. test and deploy.
- Test:
    - Test stage only runs unit test and integration test. This was done so that we can run unit tests and integration tests separately with composer dev profile. But we dont want composer dev libraries to be installed on production environment.
- Deploy:
    - Deploy is currently configured to run on develop branch.
    - We can extend to have two stages i.e deploy-uat and deploy-prd. Each stage will look at a condition to see which branch is getting deployed. If its develop, we want it to deploy to either ECS or another instance through another way. For production we want travis to deploy to ECS.
    - Deploy uses docker_push and ecs-deploy.
        - docker_push creates containers and pushes them to aws ecs repositories. This can be extended so that if we want to use ecs for uat, we can tag instances as develop instead of latest to deploy to uat instead of production.
        - ecs-deploy takes care of updating services with task definition provided in aws folder. We could have created the revision of last successfull task definition but if a task definition fails, we dont want it to create a revision based on failed task definition. Also we can create task definition per environment i.e. uat and production. Production will only hold latest tagged images, while uat will hold develop tagged images.