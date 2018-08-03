setwd("/Users/marcellamorris/Documents/Workshops:Summer Schools/BIGSSS CSS 2018/Values")
plotplay<- read.csv("plotplay.csv")

library(ggplot2)
library(dplyr)

###CREATE INDIVIDUAL RATIOS FOR INDIVIDUAL VALUES BY TOTAL VALUE WORDS
plotplay$SE_value_ratio <- plotplay$Values_SE/plotplay$value_sum
plotplay$CO_value_ratio <- plotplay$Values_CO/plotplay$value_sum
plotplay$BE_value_ratio <- plotplay$Values_BE/plotplay$value_sum
plotplay$UN_value_ratio <- plotplay$Values_UN/plotplay$value_sum
plotplay$SD_value_ratio <- plotplay$Values_SD/plotplay$value_sum
plotplay$ST_value_ratio <- plotplay$Values_ST/plotplay$value_sum
plotplay$HE_value_ratio <- plotplay$Values_HE/plotplay$value_sum
plotplay$AC_value_ratio <- plotplay$Values_AC/plotplay$value_sum
plotplay$PO_value_ratio <- plotplay$Values_PO/plotplay$value_sum

####CREATE VALUE WORD BY TOTAL WORD COUNT RATIOS
plotplay$SE_wordcount_ratio <- plotplay$Values_SE/plotplay$terms
plotplay$CO_wordcount_ratio <- plotplay$Values_CO/plotplay$terms
plotplay$BE_wordcount_ratio <- plotplay$Values_BE/plotplay$terms
plotplay$UN_wordcount_ratio <- plotplay$Values_UN/plotplay$terms
plotplay$SD_wordcount_ratio <- plotplay$Values_SD/plotplay$terms
plotplay$ST_wordcount_ratio <- plotplay$Values_ST/plotplay$terms
plotplay$HE_wordcount_ratio <- plotplay$Values_HE/plotplay$terms
plotplay$AC_wordcount_ratio <- plotplay$Values_AC/plotplay$terms
plotplay$PO_wordcount_ratio <- plotplay$Values_PO/plotplay$terms

####CREATE TOTAL VALUE WORD TO WORD COUNT RATIO
plotplay$SE_totalvalue_totalword_ratio <- plotplay$value_sum/plotplay$terms


