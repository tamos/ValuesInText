setwd("~/Downloads/blogs")
packages <- c("lavaan","semPlot","semTools","psych","mirt","tidyLPA", "tidyverse","stringr","tidytext","stm","stmBrowser","quanteda","apaTables","ggplot2","ggcorrplot",
              "cluster","fpc")

for(i in packages){
  if(!require(i, character.only = T)) install.packages(i, dependencies=T)
  library(i, character.only = T)
}

options(knitr.kable.NA = '')

library(future)
library(ggplot2)
library(quanteda)
plan(multicore)

########################################
#
# using a pre-formatted Blog Authorship corpus (https://www.kaggle.com/rtatman/blog-authorship-corpus)
#
########################################
btdf <- read_csv("blogtext.csv")
attach(btdf)
colnames(btdf)
a$text<-as.character(a$text)

corpus.dfm <- dfm(btdf$text, remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE, tolower = TRUE, remove = stopwords("english"))
corpus.dfm.trim <- dfm_trim(corpus.dfm, min_docfreq = 0.005, max_docfreq = 0.95, docfreq_type = "prop") # min 2,5% / max 90%

########################################
#
# using all the words in the dictionary
#
########################################
setwd("~/Downloads/blogs/rest")
dic <- dictionary (file= "Full.txt", format = "LIWC")

########################################
#
# counting the nulls separately for each value
#
########################################
corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$SE)
df <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df)
for(i in 1:nrow(df)){
  a<-df[i,2:b]
  df$breadthSE[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$CO)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthCO[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$TR)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthTR[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$BE)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthBE[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$UN)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthUN[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$SD)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthSD[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$ST)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthST[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$HE)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthHE[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$AC)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthAC[i]<-sum(a!=0)
  rm(a)
}

corpus.s.dic <- dfm_select(corpus.dfm.trim, dic$PO)
df2 <- convert(corpus.s.dic, to = "data.frame")
b<-ncol(df2)
for(i in 1:nrow(df)){
  a<-df2[i,2:b]
  df$breadthPO[i]<-sum(a!=0)
  rm(a)
}

vars <- c("breadthSE", "breadthCO", "breadthTR", "breadthBE", "breadthUN", "breadthSD", "breadthST","breadthHE", "breadthAC", "breadthPO")
df2 <- df[vars]
df3<-bind_cols(btdf, df2)
rm(btdf)

#count words in strings
df3$terms<-lengths(gregexpr("\\W+", df3$text))+1


df3$bSE<-df3$breadthSE/df3$terms*1000
df3$bCO<-df3$breadthCO/df3$terms*1000
df3$bTR<-df3$breadthTR/df3$terms*1000
df3$bBE<-df3$breadthBE/df3$terms*1000
df3$bUN<-df3$breadthUN/df3$terms*1000
df3$bSD<-df3$breadthSD/df3$terms*1000
df3$bST<-df3$breadthST/df3$terms*1000
df3$bHE<-df3$breadthHE/df3$terms*1000
df3$bAC<-df3$breadthAC/df3$terms*1000
df3$bPO<-df3$breadthPO/df3$terms*1000

df3$bSE<-scale(df3$bSE, center=TRUE, scale=TRUE)
df3$bCO<-scale(df3$bCO, center=TRUE, scale=TRUE)
df3$bTR<-scale(df3$bTR, center=TRUE, scale=TRUE)
df3$bBE<-scale(df3$bBE, center=TRUE, scale=TRUE)
df3$bUN<-scale(df3$bUN, center=TRUE, scale=TRUE)
df3$bSD<-scale(df3$bSD, center=TRUE, scale=TRUE)
df3$bST<-scale(df3$bST, center=TRUE, scale=TRUE)
df3$bHE<-scale(df3$bHE, center=TRUE, scale=TRUE)
df3$bAC<-scale(df3$bAC, center=TRUE, scale=TRUE)
df3$bPO<-scale(df3$bPO, center=TRUE, scale=TRUE)


df3$hCO<-df3$bTR+df3$bCO+df3$bSE
df3$hOC<-df3$bSD+df3$bST
df3$hSE<-df3$bAC+df3$bPO
df3$hST<-df3$bBE+df3$bUN


write.csv(df3, 'blogs_individual.csv')

vars <- c("hCO", "hOC", "hSE", "hST")
df2 <- df3[vars]
c<-cor(df2)
c

vars <- c("bSE", "bCO", "bTR", "bBE", "bUN", "bSD", "bST", "bHE", "bAC", "bPO")
df2 <- df3[vars]
c<-cor(df2, use="p")
c


#Multidimensional Scaling
vars <- c("hCO", "hOC", "hSE", "hST")
df2 <- df3[vars]
c<-cor(df2, use="p")
c<-1-c
fit<-cmdscale(c, eig=TRUE, k=2)
fit
x <- fit$points[,1]
y <- fit$points[,2]
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", 
     main="Metric	MDS",	type="n")
text(x, y, labels = row.names(c), cex=.7)


#other stuff
df3 <- df3[df3$terms > 2000,]
df3 <- df3[df3$terms < 5000,]

ggplot(df3, aes(x=factor(age), y=bSE)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bCO)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bTR)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bBE)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bUN)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bSD)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bST)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bHE)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bAC)) + stat_summary(fun.y="mean", geom="bar")
ggplot(df3, aes(x=factor(age), y=bPO)) + stat_summary(fun.y="mean", geom="bar")

df3$gender<-as.factor(df3$gender)

res <- wilcox.test(bUN ~ gender, data = df3,
                   exact = FALSE)
res

res <- t.test(bSE ~ gender, data = df3,
                   exact = FALSE)
res
res <- t.test(bCO ~ gender, data = df3,
              exact = FALSE)
res
res <- t.test(bTR ~ gender, data = df3,
              exact = FALSE)
res
res <- t.test(bBE ~ gender, data = df3,
              exact = FALSE)
res
res <- t.test(bUN ~ gender, data = df3,
              exact = FALSE)
res
res <- t.test(bSD ~ gender, data = df3,
              exact = FALSE)
res
res <- t.test(bST ~ gender, data = df3,
              exact = FALSE)
res
res <- t.test(bHE ~ gender, data = df3,
              exact = FALSE)
res
res <- t.test(bAC ~ gender, data = df3,
              exact = FALSE)
res
res <- t.test(bPO ~ gender, data = df3,
              exact = FALSE)
res

SE(0)CO(m+)TR(m+)BE(f+)UN(m+)SD(m+)ST(m+)HE(f+)AC(m+)PO(m+)
