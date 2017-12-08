#!/bin/bash
- docker tag ali-sarfaraz/docker-test-php:latest 550760950390.dkr.ecr.ap-southeast-2.amazonaws.com/ali-sarfaraz/docker-test-php:latest
- docker push 550760950390.dkr.ecr.ap-southeast-2.amazonaws.com/ali-sarfaraz/docker-test-php:latest
- docker tag ali-sarfaraz/docker-test-nginx:latest 550760950390.dkr.ecr.ap-southeast-2.amazonaws.com/ali-sarfaraz/docker-test-nginx:latest
- docker push 550760950390.dkr.ecr.ap-southeast-2.amazonaws.com/ali-sarfaraz/docker-test-nginx:latest