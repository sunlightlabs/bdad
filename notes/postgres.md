To connect to the database server:

    psql -U bdad -h smokehouse bdad_dev

To get the PostgreSQL version:

    bdad_dev=> SELECT version();

I got "PostgreSQL 8.4.5 on x86_64-pc-linux-gnu..."

Show columns in a table:

    \d bgs;

