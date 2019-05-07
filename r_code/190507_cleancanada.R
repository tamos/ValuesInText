

############ DESCRIPTION ############
# This is the data cleaning script for Canada

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
hoc_data <- "Data/canada/hoc_can_clean.csv"
dict_file <- "Data/parameters/dict.csv"
stopword_file <- "Data/parameters/mystopwords.csv"
can_corpus_file = "my_can_corpus_file.RData" # replace with your own

############ FUNCTIONS ############

# trim trailing and leading whitespace
# ref https://stackoverflow.com/questions/2261079/how-to-trim-leading-and-trailing-whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

############ IMPLEMENTATION ############

#### Load Data ####
setwd(base_dir)
# ref https://www.r-bloggers.com/opening-large-csv-files-in-r/
speech_data <- read.csv.ffdf(file=hoc_data, header=TRUE,
                             VERBOSE=TRUE, first.rows=10000, 
                             next.rows=50000, colClasses=NA)
speech_data <- speech_data[,]

#adds migration terms
dict <- c( "immigr", "refuge" ,"asylum")

#adds stopwords 
mystopwords <- read.csv(stopword_file, header=T)
mystopwords <- trim(as.character(mystopwords$words))

#makes a copy of original speakerparty var in case we still want it for something
speech_data$partycopy<- speech_data$speakerparty

#### CLEAN DATA ####

#replaces every spelling of "Bloc Quebecois" to "Bloc" 
speech_data$speakerparty <- gsub("^(Bloc).*", "Bloc", speech_data$speakerparty)

#recodes conservative parties as "Conservative" and others as "Liberal", see Ty's guide on Can parties
party_recode_str <- "c('Conservative','Canadian Alliance','Progressive Conservative', 'Reform')='conservative'; c('Liberal','Bloc','New Democratic Party', 'NDP', 'Green', 'Green Party', 'Québec debout', 'GPQ (ex-Bloc)', 'Forces et Démocratie' )='liberal'"
speech_data$speakerparty<-car::recode(speech_data$speakerparty, party_recode_str)


# remove 2017,18 speeches
dict_words = paste(c("2017", "2018"), collapse = "|")
speech_data$speechdate = as.character(speech_data$speechdate)
matches <- str_detect(speech_data$speechdate, dict_words)
speech_data <- speech_data[!matches,] # drop 2017, 18
speech_data$speechdate = as.factor(speech_data$speechdate)

dict_words <- paste(dict, collapse='|')


# ref https://stackoverflow.com/questions/22850026/filtering-row-which-contains-a-certain-string-using-dplyr
# ref https://stackoverflow.com/questions/7597559/grep-using-a-character-vector-with-multiple-patterns
matches <- str_detect(speech_data$speechtext, dict_words)
speech_data <- speech_data[!matches,]

# recode date variable as a date
speech_data$speechdate_formatted <- as.Date(speech_data$speechdate)

#creates a corpus
processed <- textProcessor(speech_data$speechtext, metadata = speech_data, 
                           customstopwords = mystopwords)

out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

is.Date(out$meta$speechdate)

# save data as a corpus object

save(out, file = can_corpus_file)