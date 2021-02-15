# SQL Server in Docker

## Background
Create sqlserver db using local data for case study


## Getting Started

1. Run `docker-compose up` to build container. This will set up your data base using image from Dockerfile (which in this case uses data volume already abcked up)  
2. `mssql -u sa -p reallyStrongPwd123` to enter mssql interactive mode/cli. You will be able to create tables and make queries. Please be sure to backkup and save as new image should you make a fundamentally different image you need in future.
3. `docker exec -it [container id] /bin/bash/` allows for interactive mode, allowing for bash to hijack shell
4. Clean up any unused containers via `docker container prune -f`


## Some useful commands
- `docker images` to view all images; please note that this will show your current directory and service (e.g. interview_mssql) as its own image in addition to the image you are working out of `casestudy-datasetup`. Please do not touch either of these.  
- `docker container ls` to view all containers  
- `docker container prune -f` to remove all stopped containers



## Components
- Dockerfile: creates image that is recipe for the database  
- docker-compose.yml: Builds the image  
** Please note that to get image casestudy-datasetup, I ran `Docker commit image [image id]` in order to backup the database data.**

## Data Persistance
Please note all data used in creation of casestudy-datasetup image automatically saved via `-v <host directory>/data:/var/opt/mssql/data`. Host directory `/var/opt/mssql/data` is mounted as data volume in container and can be used as backup.
