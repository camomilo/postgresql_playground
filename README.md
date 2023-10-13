# Setting up Logical Replication

Hello,

This is one "script" for setting up containers and out of this create replication and partitioning on flight with near zero downtime.

I decided to use one logical created by myself for the challenge. I know the pgslice but I prefered to create it by my own.

**Instructions:**

Docker compose will create the base of all:
 - the two containers running postgresql
 - it will replication user
 - base tables
 - procedure for insertint data
 - Publisher and subscriber
 - Port 5432 is master and port 5433 is replica.

Pre requisites:
- Docker installed
- Docker compose isntalled
- Linux or MacOs. On Windows I have no way to test.

There are two for executing it manual and via shell script. For both you need to be at rpository folder where the docker-compose.yml is.

-- Manual:

Open 3 terminals.
In terminal 1 execute:
1. docker-compose up -d
After the return of the command execute and leave it open for keep writing to table or execute it on background by adding & at the end:
2. PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5432 -c"CALL insert_sample_data();"
In terminal 2:
3. PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5432 < ./scripts/master_preparation.sql
4. PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5433 < ./scripts/replica_preparation.sql
5. PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5432 < ./scripts/moving_old_data.sql
6. PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5432 < ./scripts/migration.sql
7. PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5433 < ./scripts/migration.sql
8. PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5432 < ./scripts/cleaning.sql
9. PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5433 < ./scripts/cleaning.sql

In terminal 3:
You can use to test the migration and monitor if the data is still coming without error or stopping.
Samples of monitoring below.
`PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5433 -c "select count(*) AS "PG_REPLICA" from orders;" && PGPASSWORD=postgres psql -Upostgres -hlocalhost -dtestdb -p5432 -c "select count(*) AS "PG_MASTER" from orders;"`

-- Via shell script

The script accepts one parameter for wait x seconds before the migration.
The default value for this parameter is 5 seconds.
./scripts/execution.sh 10

-- For removing the docker containers
docker rm pg_replica pg_master --force