---
title: "Textmining with tm package"
author: "Jaeyoon Han"
date: "2016년 2월 1일"
output: html_document
---


{% highlight r %}
library(tm)
library(magrittr)
library(SnowballC)

setwd("~/KHURStudy/Machine Learning/")

jobs <- readLines("./data/steve.txt")
jobs <- iconv(jobs,"WINDOWS-1252","UTF-8") # 맥 사용자만 하시면 됩니다.

head(jobs)
{% endhighlight %}



{% highlight text %}
## [1] "'You've got to find what you love,' Jobs says"                                                                                                                                                                                                                                                                          
## [2] ""                                                                                                                                                                                                                                                                                                                       
## [3] "This is the text of the Commencement address by Steve Jobs, CEO of Apple Computer and of Pixar Animation Studios, delivered on June 12, 2005."                                                                                                                                                                          
## [4] ""                                                                                                                                                                                                                                                                                                                       
## [5] " "                                                                                                                                                                                                                                                                                                                      
## [6] "I am honored to be with you today at your commencement from one of the finest universities in the world. I never graduated from college. Truth be told, this is the closest I've ever gotten to a college graduation. Today I want to tell you three stories from my life. That's it. No big deal. Just three stories. "
{% endhighlight %}



{% highlight r %}
steve_jobs <- jobs %>%
        tolower %>%
        removeNumbers %>%
        removeWords(stopwords()) %>%
        removePunctuation %>%
        stemDocument %>%
        stripWhitespace

write(unlist(steve_jobs), "./data/jobs.txt")

jobs <- read.table("./data/jobs.txt", fill = TRUE)
jobs <- as.list(jobs)

jobs_words <- c()
for(i in 1 : length(jobs)){
        jobs_words <- c(jobs_words, as.character(jobs[[i]]))
}

write(unlist(jobs_words), "./data/jobs_words.txt")
jobs_words <- read.table("./data/jobs_words.txt")
{% endhighlight %}

