# Report on connectivity status

## Dump reports to file

Run queries and dump to csv in `reports`:

    ./report.sh


## http reporting via pg_featureserv API 

To make connectivity queries to database via http, add functions in `sql/functions` to the `bcfishpass` database and point `pg_featurserv` to the database


To add functions to the database:

    psql -f sql/functions/wcrp_barrier_count.sql
    psql -f sql/functions/wcrp_barrier_extent.sql
    psql -f sql/functions/wcrp_barrier_severity.sql
    psql -f sql/functions/wcrp_watershed_connectivity_status.sql


To ensure functions are working as expected:

    psql -c "select postgisftw.wcrp_barrier_count('HORS')"
    psql -c "select postgisftw.wcrp_barrier_extent('HORS')"
    psql -c "select postgisftw.wcrp_barrier_severity('HORS')"
    psql -c "select postgisftw.wcrp_watershed_connectivity_status('HORS')"