############ DESCRIPTION ############

# provide description of script 


############ EXAMPLE ############

# provide example commands

############ LIBRARIES ############

library(stm)
library(wordcloud)
library(stringr)
library(car)
library(dplyr)
library(lubridate)

############ CONSTANTS ############

base_dir <- "~/Documents/BIGSSS"
hoc_data <- "Data/canada/hoc_can_clean.RData"
dict_file <- "Data/parameters/dict.csv"
stopword_file <- "Data/parameters/mystopwords.csv"

############ FUNCTIONS ############

# trim trailing and leading whitespace
# ref https://stackoverflow.com/questions/2261079/how-to-trim-leading-and-trailing-whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

############ IMPLEMENTATION ############

#### Load Data ####
setwd(base_dir)
load(hoc_data)
speech_data <- df
rm(df)

#adds Marcella's migration dictionary
dict <- read.csv(dict_file, header = T)
dict <- trim(as.character(dict$words))

#adds stopwords from Marcella's topic models
mystopwords <- read.csv(stopword_file, header=T)
mystopwords <- trim(as.character(mystopwords$words))

#makes a copy of original speakerparty var in case we still want it for something
speech_data$partycopy<- speech_data$speakerparty

#### CLEAN DATA ####

#replaces every spelling of "Bloc Quebecois" to "Bloc" 
speech_data$speakerparty <- gsub("^(Bloc).*", "Bloc", speech_data$speakerparty)

#recodes conservative parties as "Conservative" and others as "Liberal", see Ty's guide on Can parties
party_recode_str <- "c('Conservative','Canadian Alliance','Progressive Conservative', 'Reform')='conservative'; c('Liberal','Bloc','New Democratic Party')='liberal'"
speech_data$speakerparty<-recode(speech_data$speakerparty, party_recode_str)

#splits into separate datasets for Liberals and Conservatives
#libdata<- subset(speech_data, speakerparty=="liberal")
#consdata<- subset(speech_data, speakerparty=="conservative")

# should still figure ngram subsetting here. e.g. what it currently does is simply take all the rows that have any of the strings from dictmarce, including "act" which is obviously not ideal.
dict_words <- paste(dict, collapse='|')

# just take subset to debug code
speech_data <- speech_data[1:10000,]

# ref https://stackoverflow.com/questions/22850026/filtering-row-which-contains-a-certain-string-using-dplyr
# ref https://stackoverflow.com/questions/7597559/grep-using-a-character-vector-with-multiple-patterns
matches <- str_detect(speech_data$speechtext, dict_words)
speech_data <- speech_data[matches,]

# take only meta data
meta_data <- speech_data[,!c('speechtext')]

#checks if the date variable is coded as date var. Here it is date, but later after processing into corpus not anymore a date, which screws up plotting.
speech_data$speechdate_formatted <- as.Date(speech_data$speechdate)

#creates a corpus
processed <- textProcessor(speech_data$speechtext, metadata = meta_data, 
                           customstopwords = mystopwords)

out <- prepDocuments(processed$documents, processed$vocab, processed$meta)

docs <- out$documents
vocab <- out$vocab
meta <-out$meta

is.Date(out$meta$speechdate)
#not sure why the date in meta is not anymore recognized as date. This screws up the plotting later

#decides what is a good way to cut words, using plotting function. Then cuts it accordingly
plotRemoved(processed$documents, lower.thresh = seq(1, 300, by = 50))
out <- prepDocuments(processed$documents, processed$vocab,
                     processed$meta, lower.thresh = 50, upper.thresh = 300)

#topic modelling going on here. Number of topics is 5, maximal number of iteration is 70, used method is spectral as according to the guidelines it provides "optimal results". Gamma prios is L1 as with such a small number of iterations the model would have otherwise not converged. Can be removed if the n. of iterations is increased to allow model to converge. We identify the covariate we are interested in under prevalence.

can_new <- stm(documents = out$documents, vocab = out$vocab,
               K = 10, max.em.its = 70, data = out$meta, init.type =  "Spectral", gamma.prior='L1', prevalence =~ speakerparty)

#should identify the "optimal" number of topics. For me it suggests its 32
can_stm5 <- stm(documents = out$documents, vocab = out$vocab, K = 0, max.em.its = 70, data = out$meta, init.type = "Spectral", prevalence =~ speakerparty)

#should help with the selection of an optimal model when the number of topcs is fixed
#max.em.its. should be increased and the number of models to be tested, with this set up there is no convergence, but otherwise it takes a long time to run it..
model_sel <- selectModel(out$documents, out$vocab, K = 26,
                         prevalence =~ speakerparty, max.em.its = 70, gamma.prior='L1', data = out$meta, runs = 10, seed = 8458159)

#plots the models to help selection. each symbol is a topic, models visualised under pch
plotModels(model_sel, pch=c(1,2,3,4), legend.position="bottomright")

#selects a model, here model 2
selectedmodel <- model_sel$runout[[2]]

#plots topics based on exclusivity and semantic coherence for the selected model
rr2 <- topicQuality(selectedmodel, out$documents, xlab="Semantic Coherence", ylab="Exclusivity", labels=1:ncol(selectedmodel$theta), M=10)


#plots topics for the first model we got. My interpretation is that upper right corner topics would be "better", but it also depends on the scale
rr1 <- topicQuality(can_new, out$documents, xlab="Semantic Coherence", ylab="Exclusivity", labels=1:ncol(can_new$theta), M=10)

#displays words associated with each of the topics from the first model
labelTopics(can_new, c(1:10))
labelTopics(selectedmodel, c(1:26))
labelTopics(can_stm5)

#checks if conservative vs. liberal makes a difference with regards to influence on the topics

out$meta$speakerparty <- as.factor(out$meta$speakerparty)
prep <- estimateEffect(1:10 ~ speakerparty, can_new, meta = out$meta, uncertainty = "Global")
summary(prep, topics=1:10)

plot(can_new, type = "summary", xlim = c(0, .3))

#visualizes the differences between cons and lib parties for selected topics. here topics 7 and 8 which were then named accordingly
plot(prep, covariate = "speakerparty", topics = c(7, 8),
     model = can_new, method = "difference", cov.value1 = "Liberal", cov.value2 = "Conservative", main = "Effect of Liberal vs. Conservative", xlim = c(-.1, .1), labeltype = "custom", custom.labels = c('nationa and community', 'industry'))

#uses metadata though content option, previous just prevalence, ie.how a particular topic is discussed and not merely frequency of the words in a topic as in prevalence (see pg 9 in stm vignette)
can_stm1 <- stm(out$documents, out$vocab, K = 20,
                prevalence =~ speakerparty + speechdate, content =~ speakerparty,
                max.em.its = 10, gamma.prior= 'L1', data = out$meta, init.type = "Spectral")


#shows which words within a topic are more associated with one covariate value versus another. 
plot(can_stm1, type = "perspectives", topics = 1)

#factors an interaction effect of the speakerparty and speechdate with regards to the frequency of the used words
interaction <- stm(out$documents, out$vocab, K = 20,
                   prevalence =~ speakerparty * speechdate, max.em.its = 15,
                   data = out$meta,gamma.prior='L1', init.type = "Spectral")

#this is where speechdate would have been useful, but some conversion between date is happening that I dont know how to correct
#the following step also does not work unless speechdate is converted to numerical
out$meta$speechdate <- as.numeric(out$meta$speechdate)
head(out$speechdate, 5)
min(out$meta$speechdate)
max(out$meta$speechdate)
out$data$speechdate <- as.Date(out$data$speechdate, format = "%d/%m/%y")
head(out$data$speechdate, 5)

#this could be really cool if the numbers that are inserted as date are not completely bogus. 
prep <- estimateEffect(c(4) ~ speakerparty * speechdate, interaction,
                       metadata = out$meta, uncertainty = "None")


plot(prep, covariate = "speechdate", model =interaction,
     method = "continuous", xlab = "date", moderator = "speakerparty", ci.level = 0.95,
     moderator.value = "Liberal", linecol = "blue", ylim = c(.02, .12),  printlegend = F)
plot(prep, covariate = "speechdate", model = interaction,
     method = "continuous", xlab = "date", moderator = "speakerparty",
     moderator.value = "Conservative", linecol = "red", add = T, printlegend = F)

legend(18500, .12, c("Liberal", "Conservative"), lwd = 2, col = c("blue", "red"))

#word clouds - nice visualization?
cloud(can_new, topic = 4, scale = c(2,.25))

plot(can_new, type = "summary", xlim = c(0, .3))

mod.out.corr <- topicCorr(can_new)
plot(mod.out.corr)

library("stmCorrVizz")
stmCorrViz(can_new, "corrviz.html",
           documents_raw=data$speechtext,
           documents_matrix=data$out)
