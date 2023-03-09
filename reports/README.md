# Report on connectivity status

## Setup

Ensure the `$DATABASE_URL` environment variable to point at the database of interest.


## Dump reports to file

 Run queries and dump results to csv in `reports`:

    ./report.sh


## http reporting via pg_featureserv API 

To make connectivity queries to database via http, add functions in `sql/functions` to the `bcfishpass` database and point `pg_featurserv` to the database


To add functions to the database:

    psql $DATABASE_URL -f sql/functions/wcrp_barrier_count.sql
    psql $DATABASE_URL -f sql/functions/wcrp_barrier_extent.sql
    psql $DATABASE_URL -f sql/functions/wcrp_barrier_severity.sql
    psql $DATABASE_URL -f sql/functions/wcrp_watershed_connectivity_status.sql


To ensure functions are working as expected:

    psql $DATABASE_URL -c "select postgisftw.wcrp_barrier_count('HORS')"
    psql $DATABASE_URL -c "select postgisftw.wcrp_barrier_extent('HORS')"
    psql $DATABASE_URL -c "select postgisftw.wcrp_barrier_severity('HORS')"
    psql $DATABASE_URL -c "select postgisftw.wcrp_watershed_connectivity_status('HORS')"