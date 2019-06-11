library(ggplot2)
library(tidyr)
library(dplyr)
topicClassUSA <-rbind("Migration Core","Migration Core", "Irrelevant", "Irrelevant", "Culture", "Irrelevant",
                "Human Rights", "Human Rights", "Irrelevant", "Security", "Irrelevant", "Economy", "Economy",
                "Irrelevant", "Culture", "Security", "Security", "Economy", "Human Rights", "Irrelevant")
USA <- rbind("United States", "United States", "United States", "United States", "United States", "United States", 
             "United States", "United States", "United States", "United States", "United States", "United States", 
             "United States", "United States", "United States", "United States", "United States", "United States", 
             "United States", "United States")
topicClassUSA <- as.data.frame(cbind(topicClassUSA, USA))
colnames(topicClassUSA)[1] <- "Category"
colnames(topicClassUSA)[2] <- "Country"

topicClassCAN <- rbind("Economy", "Migration Core", "Irrelevant", "Irrelevant", "Migration Core",
                       "Culture", "Economy", "Security", "Culture", "Migration Core", "Culture", "Economy", 
                       "Economy", "Security","Human Rights", "Economy", "Security", "Security", "Irrelevant", "Economy")
CAN <- rbind("Canada", "Canada", "Canada", "Canada", "Canada", "Canada", "Canada", "Canada", "Canada", "Canada", 
             "Canada", "Canada", "Canada", "Canada", "Canada", "Canada", "Canada", "Canada", "Canada", "Canada")
topicClassCAN <- as.data.frame(cbind(topicClassCAN, CAN))
colnames(topicClassCAN)[1] <- "Category"
colnames(topicClassCAN)[2] <- "Country"
dat <- rbind(topicClassUSA, topicClassCAN)
#write.csv(dat, "data.BIGSSS.csv")
#here, i took it into excel to add the counts, I know there's a tidyr way to do it but alas, here we are.
#dat<- read.csv("data.fortopiccategorization.BIGSSS.csv")
# ref https://stackoverflow.com/questions/2479689/crosstab-with-multiple-items
dat_sum = data.frame(xtabs(~Country+Category, data = dat))
#dat_sum$Country = factor(dat_sum$Country, levels = rev(levels(dat_sum$Country)))

Both_Plot = ggplot(data=dat_sum, aes(Category, Freq)) +
  geom_bar(aes(fill=Country), position = position_dodge(width = 1), stat="identity") +
  scale_fill_grey(start = 0.25, end = 0.75) +
  xlab("Categorization of Topic") + 
  coord_flip() +
  ylab("Count" ) +
  ggtitle("Topic Classification")



Both_Plot +  guides(fill =  guide_legend(reverse = TRUE))

Both_Plot
