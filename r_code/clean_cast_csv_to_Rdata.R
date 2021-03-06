# make files into rdata format
library(data.table)

# base dir is the location where the data is stored for you
base_dir = "/Users/ty/Documents/BIGSSS/Data"

setwd(base_dir)

# Read in canada data produced by the psql command and python script
# to do: move python script from jupyter-notebook into a proper script
# this data has only speeches after 1993-12-31
df = fread("canada/hoc_can_clean.csv", sep = "|")

# move into the canada directory 
setwd(paste(base_dir, "canada", sep = "/"))

# save the file as rdata
save(df, file = "hoc_can_clean.RData")

rm(df)

setwd(base_dir)

# Read in us data produced by the sql query
# this data is already filtered
df = fread("us/congress_us_clean.csv", sep = "|")

# move into the us directory 
setwd(paste(base_dir, "us", sep = "/"))

# save the file as rdata
save(df, file = "congress_us_clean.RData")
