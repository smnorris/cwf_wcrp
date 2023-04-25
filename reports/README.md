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


To ensure functions are working as expected, test directly:

    psql $DATABASE_URL -c "select postgisftw.wcrp_barrier_count('HORS')"
    psql $DATABASE_URL -c "select postgisftw.wcrp_barrier_extent('HORS')"
    psql $DATABASE_URL -c "select postgisftw.wcrp_barrier_severity('HORS')"
    psql $DATABASE_URL -c "select postgisftw.wcrp_watershed_connectivity_status('HORS')"


Grant the pgfs user/role access to the functions:

    psql $DATABASE_URL -c "GRANT EXECUTE ON FUNCTION postgisftw.wcrp_barrier_count TO pgfs"
    psql $DATABASE_URL -c "GRANT EXECUTE ON FUNCTION postgisftw.wcrp_barrier_extent TO pgfs"
    psql $DATABASE_URL -c "GRANT EXECUTE ON FUNCTION postgisftw.wcrp_barrier_severity TO pgfs"
    psql $DATABASE_URL -c "GRANT EXECUTE ON FUNCTION postgisftw.wcrp_watershed_connectivity_status TO pgfs"

And test that they are being served:

    http://<url>/functions/postgisftw.wcrp_barrier_severity/items.json?watershed_group_code=HORS
    http://<url>/functions/postgisftw.wcrp_barrier_extent/items.json?watershed_group_code=HORS
    http://<url>/functions/postgisftw.wcrp_barrier_severity/items.json?watershed_group_code=HORS
    http://<url>/functions/postgisftw.wcrp_watershed_connectivity_status/items.json?watershed_group_code=HORS
