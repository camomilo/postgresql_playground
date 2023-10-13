#!/bin/bash
PASS=postgres
WAIT="${1:-5}"
echo "====>>>>  Initialing docker-compose"
docker-compose up -d
sleep 5
echo "Inserting data"
PGPASSWORD=$PASS psql -Upostgres -hlocalhost -dtestdb -p5432 -c"CALL insert_sample_data();" &
echo "====>>>>  Preparing databases"
echo "Master"
PGPASSWORD=$PASS psql -Upostgres -hlocalhost -dtestdb -p5432 < ./scripts/master_preparation.sql
echo "Replica"
PGPASSWORD=$PASS psql -Upostgres -hlocalhost -dtestdb -p5433 < ./scripts/replica_preparation.sql
echo "Waiting $WAIT Seconds before the switch tables"
sleep $WAIT
echo "====>>>>  Migrating old data"
echo "Master"
PGPASSWORD=$PASS psql -Upostgres -hlocalhost -dtestdb -p5432 < ./scripts/moving_old_data.sql
echo "====>>>>  Migrating"
echo "Master"
PGPASSWORD=$PASS psql -Upostgres -hlocalhost -dtestdb -p5432 < ./scripts/migration.sql
echo "Replica"
PGPASSWORD=$PASS psql -Upostgres -hlocalhost -dtestdb -p5433 < ./scripts/migration.sql
echo "====>>>>  Cleaning"
echo "Master"
PGPASSWORD=$PASS psql -Upostgres -hlocalhost -dtestdb -p5432 < ./scripts/cleaning.sql
echo "Replica"
PGPASSWORD=$PASS psql -Upostgres -hlocalhost -dtestdb -p5433 < ./scripts/cleaning.sql