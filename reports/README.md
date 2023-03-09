# Report on connectivity status

## Dump reports to file

Run queries and dump to csv in `reports`:

    ./report.sh


## http reporting via pg_featureserv API 

To make connectivity queries to database via http, add functions in `sql/functions` to the `bcfishpass` database and point `pg_featurserv` to the database
