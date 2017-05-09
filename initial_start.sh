#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Expecting one argument'
    exit 0
fi

docker run --name atlassian-jira-postgres -e POSTGRES_USER=jira -e POSTGRES_PASSWORD="$1" -d postgres:9.5.6-alpine
docker run -d --name atlassian-jira --link atlassian-jira-postgres:pgjira -p 8080:8080 atlassian-jira
