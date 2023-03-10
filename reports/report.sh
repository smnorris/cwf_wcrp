#!/bin/bash
set -euxo pipefail

mkdir -p reports

psql2csv $DATABASE_URL < sql/watershed_summary.sql > reports/watershed_summary.csv

# just one value for each of these
psql2csv $DATABASE_URL < sql/dci_elkr_above_elko.sql > reports/dci_elkr_above_elko.csv
psql2csv $DATABASE_URL < sql/dci_elkr_below_elko.sql > reports/dci_elkr_below_elko.csv