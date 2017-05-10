# atlassian-jira
A Docker container for Jira Server with both mysql and postgres to be able to be used. 
This version uses a jira user to run a process rather than a default user.
The intent is to use this image as a restartable service and run your jira  server.

Any feedback let me know - its all welcome!

This is based heavily from [this git hub repo](https://github.com/cptactionhank/docker-atlassian-jira), however with some good additions.

# Pre-req

Before running this docker image, please [clone / download the repo](https://github.com/blofse/atlassian-jira), inlcuding the script files.

# How to use this image
## Initialise
Run the following command, replacing *** with your desired db password:
```
initial_start.sh "***"
```
This will setup two containers: 
* atlassian-jira-postgres - a container to store your jira db data
* atlassian-jira - the container containing the jira server

You can now use the jira installer to import existing data. However to access the DB initially, the following details are required:

Host: pgjira
User: jira
Pass: *** Entered from earlier
(leave the rest the same and hit "Test Connection")

## (optional) setting up as a service

Once initialised and perhaps migrated, the docker container can then be run as a service. 
Included in the repo is the service for centos 7 based os's and to install run:
```
copy_install_and_start_as_service.sh
```

