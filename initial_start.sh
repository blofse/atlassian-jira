#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker network create \
  --driver bridge \
  atlassian-jira-network

docker run \
  --name atlassian-jira-postgres \
  -e POSTGRES_USER=jira \
  -e POSTGRES_PASSWORD="$1" \
  -v atlassian-jira-postgres-data:/var/lib/postgresql/data \
  --net atlassian-jira-network \
  -d \
  postgres:9.5.6-alpine

docker run \
  --name atlassian-jira \
  -p 8080:8080 \
  -v atlassian-jira-home:/var/atlassian/application-data/jira \
  --net atlassian-jira-network \
  -d \
  atlassian-jira
