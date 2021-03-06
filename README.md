# Replication Materials

Relevant data files are available at: https://uchicago.box.com/s/sdbpddyjky7s29mhnqra2fayx8dak5ko

## Cleaning

Data cleaning was done as follows:

1. Download datasets from the Data Sources links (below)
2. Run shell_code/join_us_data.sh to collect all US files together (see file for instructions)
3. Run sql_code/create_us_database.sql to create a Sqlite3 database (see file for instructions)
4. Run sql_code/query_us_database.sql to extract the contents of the database to a file (see file for instructions)
5. Query Canadian (Lipad) PostGRES database with a full join across all tables to output to a csv. This can take some time/memory, so the output file is provided instead of the SQL command.
6. Run r_code/clean_cast_csv_to_Rdata.R for both US and Canada to create RData objects
7. Run r_code/190507_cleancanada.R, r_code/190507_cleanus.R to clean data

## Model Training

1. Run r_code/190507_train_stm.R for each country corpus.

## Plotting 

1. Run r_code/190507_plot_can_us.Rmd to generate plots 

## Data Sources


__Canadian Parliament__

https://www.lipad.ca


__US Congress__


https://data.stanford.edu/congress_text
