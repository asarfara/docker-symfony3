#!/bin/bash
- docker tag ali-sarfaraz/docker-test-php:develop 550760950390.dkr.ecr.ap-southeast-2.amazonaws.com/ali-sarfaraz/docker-test-php:develop
- docker push 550760950390.dkr.ecr.ap-southeast-2.amazonaws.com/ali-sarfaraz/docker-test-php:develop
- docker tag ali-sarfaraz/docker-test-nginx:develop 550760950390.dkr.ecr.ap-southeast-2.amazonaws.com/ali-sarfaraz/docker-test-nginx:develop
- docker push 550760950390.dkr.ecr.ap-southeast-2.amazonaws.com/ali-sarfaraz/docker-test-nginx:develop