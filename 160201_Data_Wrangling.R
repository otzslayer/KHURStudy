# [Load Packages] ---------------------------------------------------------
library(dplyr)
library(ggplot2)
library(reshape2)
# -------------------------------------------------------------------------


# [Load Data] -------------------------------------------------------------

# 1. 취진처 2014년 데이터 로드
job <- read.csv("/Users/Han/Google Drive/Job Project/Data/job.csv", header = T,
                stringsAsFactors = F, fileEncoding = "CP949", encoding = "UTF-8")

# -------------------------------------------------------------------------



# [Data Cleansing and Wrangling] ------------------------------------------

# To explore data
head(job)

# Need to change the structure and the column name of 4th column
job <- tbl_df(job) # tbl_df
job <- rename(job, jinro = 진로) # change the name of 4th column into 'jinro'
job$jinro <- factor(job$jinro) # "chr" ==> "factor"


# 1. 학과별 취업률 분석 ---------------------------------------------------
# First of all, i want to figure a relation between the employment rate and
# departments out.

khu_depart_emprate <- job %>%
        select(sosok_dankwa, hakwa, hakwa_so, jinro)

# 세부 전공 이름 단일화

khu_depart_emprate$hakwa_so <- khu_depart_emprate$hakwa_so %>%
        gsub("학전공", "학", .) %>%
        gsub("전공", "학", .) %>%
        gsub("학과", "학", .) %>%
        gsub("약과학", "약학", .) %>%
        gsub("회계학", "회계ㆍ세무학", .)

levels(factor(khu_depart_emprate$hakwa_so))
# -------------------------------------------------------------------------

Employed_result <- levels(job$jinro)
isEmployed <- c()

# 기타 => 미취업, 대학원 => 대학원, 취업자 => 취업
khu_depart_emprate <- mutate(khu_depart_emprate,
                             isEmployed = ifelse(jinro %in% Employed_result[1:4], "미취업",
                                                 ifelse(jinro %in% Employed_result[6:8], "대학원", "취업")))

# isEmployed : chr => factor
khu_depart_emprate$isEmployed <- factor(khu_depart_emprate$isEmployed)

# Chaining
isEmployed_by_depart <- khu_depart_emprate %>%
        group_by(hakwa_so, isEmployed) %>%
        summarise(count = n()) %>%
        dcast(hakwa_so ~ isEmployed) %>%
        replace(is.na(.), 0)

isEmployed_by_depart

file_name <- file('학과별취업률.csv', encoding="utf8")
write.csv(isEmployed_by_depart, file=file_name, row.names = FALSE)
# -------------------------------------------------------------------------
