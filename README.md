# atlassian-jira
A Docker container for Jira Server with both mysql and postgres to be able to be used. 
This version uses a jira user to run a process rather than a default user.
The intent is to use this image as a restartable service and run your jira  server.

Any feedback let me know - its all welcome!

This is based heavily from [this git hub repo](https://github.com/cptactionhank/docker-atlassian-jira), however with some good additions.

# Pre-reqs
JIRA postgres must be setup prior to running this. To do so perform the following command, replacing *** with your own password:
```
docker run --name jira-postgres -e POSTGRES_USER=jira -e POSTGRES_PASSWORD='***' -d postgres:9.5.6-alpine
```

# How to use this image
Run the following command:
```
docker run -d --name atlassian-jira --link jira-postgres:pgjira -p 8080:8080 atlassian-jira
```
When asked for DB information as part of the setup, use the following:
Host: pgjira
User: jira
Pass: *** Entered from earlier
(leave the rest the same and hit "Test Connection")

# Running as a service
An example service file is provided as part of the repo to run from CentOS 7 + systemd
