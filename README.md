# atlassian-jira - A docker image containing version 7.3.6 based on alpine linux, with mysql / postgres support
A Docker container for Jira Server with both mysql and postgres to be able to be used. 
This version uses a jira user to run a process rather than a default user.
The intent is to use this image as a restartable service and run your jira  server.

Any feedback let me know - its all welcome!

This is based from [this git hub repo](https://github.com/cptactionhank/docker-atlassian-jira), however with some good additions.

# Pre-req

Before running this docker image, please [clone / download the repo](https://github.com/blofse/atlassian-jira), inlcuding the script files.

# How to use this image
## (optional) build docker image

To build the local docker image, run the following command:

```
./optional/build_local.sh
```

## Initialise
Run the following command, replacing *** with your desired db password:
```
./initial_start.sh '***'
```
This will setup: 
* Two containers:  
	* atlassian-jira-postgres - a container to store your jira db data
	* atlassian-jira - the container containing the jira server
* Two Volumes:
	* atlassian-jira-postgres-data - used for jira db data
	* atlassian-jira-home - used for jira home directory.
* A network:
	* atlassian-jira-network - a bridge network for jira

## Using the JIRA setup

For either setup, to access the DB initially, the following details are required:

Host: atlassian-jira-postgres
Database: jira
User: jira
Pass: *** Entered from earlier
(leave the rest the same and hit "Test Connection")

If you are setting up a new instance, you can either use the default or custom setup option on the initial page.

If you are importing an existing instance of JIRA, you will need to select the custom option, setup the DB and then when prompted for the company information, run the import tool provided with this github repo then use the import tool supplied with JIRA.

To export an existing JIRA, use the JIRA export tool to export the instance as an xml.zip file.
Then, place that file in the following location:
* imports/xml-backup.zip

Then run the following script to import that data into the JIRA container (when at the "Set up application properties" screen of the JIRA setup):
```
./optional/migrate_existing_db.sh
```
Then, once at the application properties screen, hit "import your data" rather than enter in your company details. Under file name, use "xml-backup.zip" as the file name an enter in your license as required and select your "Outgoing Mail" option.
Once entered, hit "Import" and the JIRA web interface should begin importing your old JIRA data.

## (optional) setting up as a service

Once initialised and perhaps migrated, the docker container can then be run as a service. 
Included in the repo is the service for centos 7 based os's and to install run:
```
./optional/copy_install_and_start_as_service.sh
```

## (optional) remove all (for this image)

Running the command below will remove all trace of this docker image, services, containers, volumes and networks:

```
./optional/remove_all.sh
```

