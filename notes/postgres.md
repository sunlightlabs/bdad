To connect to the database server:

    psql -U bdad -h smokehouse bdad_dev

To get the PostgreSQL version:

    bdad_dev=> SELECT version();

I got "PostgreSQL 8.4.5 on x86_64-pc-linux-gnu..."

Show columns in a table:

    \d bgs;

Dump all data from a database:

    pg_dump -h smokehouse -U bdad -a bdad_dev > bdad.sql

Dump data from a table from a database:

    pg_dump -h smokehouse -U bdad -t districts -a bdad_dev > bdad_districts.sql
    -a, --data-only             dump only the data, not the schema