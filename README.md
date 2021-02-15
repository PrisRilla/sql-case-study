# Case Study: Setting Up SQL Server in Docker

## Background
Create sqlserver db using local data to help answer case study questions


## Getting Started

1. Run `% docker-compose up` to build container. This will set up your data base using image from Dockerfile (which in this case uses data volume already backed up)  
2. `% mssql -u sa -p reallyStrongPwd123` to enter mssql interactive mode/cli. You will be able to create tables and make queries. Please be sure to backkup and save as new image should you make a fundamentally different image you need in future.
3. `% docker exec -it [container id] /bin/bash/` allows for interactive mode, allowing for bash to hijack shell


## Some useful commands
- `% docker images` to view all images; please note that this will show your current directory and service (e.g. interview_mssql) as its own image in addition to the image you are working out of `casestudy-datasetup`. Please do not touch either of these.  
- `% docker container ls` to view all containers  
- `% docker container prune -f` to remove all stopped containers



## Components
- Dockerfile: creates image that is recipe for the database  
- docker-compose.yml: Builds the image; Note that local ports that can run mssql are 1434, 1433, 1431  

** Please note that to get image casestudy-datasetup, I ran `Docker commit image [image id]` in order to backup the database data.**  

Below are commands I ran in mssql cli to set up database and tables prior to committing image. Please note to be careful when committing image. Need to make sure processes are idle before copying, otherwise if something is half written, then the copy of that data will be corrupted.


```
CREATE TABLE Claims(claim_number NVARCHAR(10), dos DATE, procedure_code INT, Member_ID NVARCHAR(10))
INSERT INTO Claims VALUES ('CL1','2017-01-03',9931,'MM1')
INSERT INTO Claims VALUES ('CL2','2017-12-12',9922,'MM2')
INSERT INTO Claims VALUES ('CL3','2017-11-13',9866,'MM3')
INSERT INTO Claims VALUES ('CL4','2018-01-02',9931,'MM1')
INSERT INTO Claims VALUES ('CL5','2017-12-27',9931,'MM4')
INSERT INTO Claims VALUES ('CL6','2018-01-24',9922,'MM2')

CREATE TABLE Procedures(Procedure_Code INT, Effective_Date DATE, Cost DECIMAL(13,2), Type NVARCHAR(50))
INSERT INTO Procedures VALUES(9866,'2017-01-01', 150.00, 'Lab Test')
INSERT INTO Procedures VALUES(9866,'2018-01-01', 151.00, 'Lab Test')
INSERT INTO Procedures VALUES(9887,'2017-01-01', 275.00, 'Minor Surgery')
INSERT INTO Procedures VALUES(9887,'2018-01-01', 275.00, 'Minor Surgery')
INSERT INTO Procedures VALUES(9921,'2017-01-01', 50.00, 'Evaluation')
INSERT INTO Procedures VALUES(9922,'2017-01-01', 50.00, 'Evaluation')
INSERT INTO Procedures VALUES(9931,'2017-01-01', 200.00, 'Minor Surgery')
INSERT INTO Procedures VALUES(9931,'2018-01-01', 215.00, 'Minor Surgery')

CREATE TABLE Members(Member_ID NVARCHAR(10),Policy NVARCHAR(50),Effective_Date DATE, Termination_Date DATE)
INSERT INTO Members VALUES('MM1','Oscar Gold','2017-01-01','2017-12-31')
INSERT INTO Members VALUES('MM2','Oscar Silver','2017-02-01','2017-12-31')
INSERT INTO Members VALUES('MM3','Oscar Gold','2017-04-01','2017-10-31')
INSERT INTO Members VALUES('MM4','Oscar Platinum','2017-01-01','2018-12-31')
INSERT INTO Members VALUES('MM1','Oscar Silver','2018-01-01','2018-04-30')
INSERT INTO Members VALUES('MM2','Oscar Silver','2017-01-01','2018-12-31')
INSERT INTO Members VALUES('MM3','Oscar Bronze','2018-01-01','2018-12-31')

```

## Data Persistance
Please note all data used in creation of casestudy-datasetup image automatically saved via `-v <host directory>/data:/var/opt/mssql/data`. Host directory `/var/opt/mssql/data` is mounted as data volume in container and can be used as backup.
