# clean us 

############ DESCRIPTION ############
# This is the data cleaning script for US

############ LIBRARIES ############

library(stm)
library(wordcloud)
library(stringr)
library(car)
library(dplyr)
library(lubridate)
library(ff)

############ CONSTANTS ############
# replace with your own directories

base_dir <- "~/Documents/BIGSSS" # change to be your own path
hoc_data <- "Data/canada/hoc_us_clean.csv"
dict_file <- "Data/parameters/dict.csv"
stopword_file <- "Data/parameters/mystopwords.csv"
us_corpus_file = "my_us_corpus_file.RData" # replace with your own



#### Load Data ####
setwd(base_dir)


# loads rdata 
dataUS <-load("congress_us_clean.RData")
#keeps only the vars here listed to cut the size of the dataset
dataUS <- subset(df, select = c(speech_id, date, speech, party, firstname, lastname))

dataUS <- rename.vars(dataUS, c("speech_id", "date", "speech", "party"), c("basepk", "speechdate", "speechtext", "speakerparty"))

#saves the dataframe as csv
write.csv(dataUS, hoc_data)

#reads the csv file
data <- read.csv(hoc_data, header = T)

drop <- c('P', 'A')
speech_data <- data[ !grepl(paste(drop, collapse="|"), data$speakerparty),]

#adds migration terms
dict <- c( "immigr", "refuge" ,"asylum")

#adds stopwords 
mystopwords <- read.csv(stopword_file, header=T)
mystopwords <- trim(as.character(mystopwords$words))


dict_words <- paste(dict, collapse='|')


# ref https://stackoverflow.com/questions/22850026/filtering-row-which-contains-a-certain-string-using-dplyr
# ref https://stackoverflow.com/questions/7597559/grep-using-a-character-vector-with-multiple-patterns
matches <- str_detect(speech_data$speechtext, dict_words)
speech_data <- speech_data[!matches,]


#creates a corpus
processed <- textProcessor(speech_data$speechtext, metadata = speech_data, 
                           customstopwords = mystopwords)

out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

is.Date(out$meta$speechdate)

# save data as a corpus object

save(out, file = us_corpus_file)
