# Replication Materials

## Cleaning

Data cleaning was done as follows:

1. Download datasets from the Data Sources links (below)
2. Run shell_code/join_us_data.sh (see file for instructions)
3. Run sql_code/create_us_database.sql (see file for instructions)
4. Run sql_code/query_us_database.sql (see file for instructions)
5. Query Canadian (Lipad) PostGRES database with a full join across all tables, output to a csv (output file is provided)
6. Run r_code/clean_cast_csv_to_Rdata.R for both US and Canada to create RData objects
7. Run r_code/190507_cleancanada.R to clean Canada


## Model Training

1. Run r_code/190507_train_stm.R for each country corpus.

## Data Sources


__Canadian Parliament__

https://www.lipad.ca


__US Congress__


https://data.stanford.edu/congress_text
