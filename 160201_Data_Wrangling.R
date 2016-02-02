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

file_name <- file('학과별취업률.csv')
write.csv(isEmployed_by_depart, file=file_name, row.names = FALSE)
# -------------------------------------------------------------------------
# 
# 2. 휴학 한 번도 안한 인원 추출
no_rest <- job %>%
        filter((sex == 0 & jaehak_term == 4) | (sex == 1 & jaehak_term == 6))

no_rest <- no_rest %>%
        mutate(isEmployed = ifelse(jinro %in% Employed_result[1:4], "미취업",
                                   ifelse(jinro %in% Employed_result[6:8], "대학원", "취업")))

table(no_rest$isEmployed)

# 3. 성별과 재학기간을 모두 고려해보자.
# sex = 0 : 여성 ; 4년
# sex = 1 : 남성 ; 4 + 2년 (군대 다녀왔다면)

Employed_result <- levels(job$jinro)

job <- mutate(job, isEmployed = ifelse(jinro %in% Employed_result[1:4], "미취업",
                                       ifelse(jinro %in% Employed_result[6:8], "대학원", "취업")))

job$hakwa_so <- job$hakwa_so %>%
        gsub("학전공", "학", .) %>%
        gsub("전공", "학", .) %>%
        gsub("학과", "학", .) %>%
        gsub("약과학", "약학", .) %>%
        gsub("회계학", "회계ㆍ세무학", .)


# isETS 에 군필 여부를 넣고 isTransfered에 편입 여부를 넣는다.
# 이 때 isTransfered는 "일반"으로 초기화시킨다.
job <- job %>%
        rename(isETS = 학적군필명) %>%
        mutate(isTransfered = "일반")

# isTransfered 변수에 편입 여부
index_transfered <- grep("편입", job$junhyung_type)
job$isTransfered[index_transfered] <- "편입"

# 순수 재학기간을 추출한다.
# name of variable : pure_jaehak_term
# 남자, 군필, 일반 전형 : 재학기간 - 2
# 여자, 편입 / 남자, 미필, 편입 / 남자, 군필, 편입, 재학기간 2~3 : 재학기간 + 2
# 나머지 : +-0

job <- job %>%
        mutate(pure_jaehak_term = ifelse(sex == 1 & isETS == "군필" & isTransfered == "일반", (jaehak_term - 2),
                                         ifelse((sex == 0 & isTransfered == "편입"), (jaehak_term + 2) ,
                                                ifelse((sex == 1 & isETS != "군필" & isTransfered == "편입"), (jaehak_term + 2),
                                                       ifelse(sex == 1 & isETS == "군필" & isTransfered == "편입" & jaehak_term < 4,
                                                       (jaehak_term + 2), jaehak_term)))))


write.csv(job, "160202_KHU_jobs.csv", row.names = FALSE)



# Survival Analysis -------------------------------------------------------
# data wrangling

SA_job <- job %>%
        mutate(ID = 1 : nrow(job)) %>%
        rename(ets = 학적군필) %>%
        select(ID, hakwa_so, moon_lee, sex, iphak_year, graduate_year, pure_jaehak_term, bujungong_yn, dajungong_yn, pyunip, ets, toeic, pyungjum_chiup, isEmployed) %>%
        rename(major = hakwa_so, isLiberal = moon_lee, admission_year = iphak_year, term_time = pure_jaehak_term,
               isMinor = bujungong_yn, isMultiMajor = dajungong_yn, isTransfer = pyunip, GPA = pyungjum_chiup)
        
# 문이과 여부 : 문과 : 1, 이과 : 0
SA_job$isLiberal <- ifelse(SA_job$isLiberal == "문과", 1, 0)

# 부전공 여부 : Y : 1, N : 0
SA_job$isMinor <- ifelse(SA_job$isMinor == "Y", 1, 0)

# 다전공 여부 : Y : 1, N : 0
SA_job$isMultiMajor <- ifelse(SA_job$isMultiMajor == "Y", 1, 0)

# 편입 여부 : 2 => 0
SA_job$isTransfer <- ifelse(SA_job$isTransfer == 2, 0, 1)

# toeic 점수가 없는 인원 제외
SA_job <- filter(SA_job, toeic != "NULL")

SA_job$toeic <-as.numeric(SA_job$toeic)

# 군대 전역 여부는 필요가 없을지도
SA_job <- select(SA_job, -ets)

# 생존 시간을 재학기간이라고 했을 때, 입학년도와 졸업년도는 필요가 없고, 전공 역시 필요가 없다.
# 새로운 변수를 만들다.

jobSurvival <- SA_job %>%
        select(-major) %>%
        filter(isEmployed != "대학원")

jobSurvival$ID <- 1 : nrow(jobSurvival)

# 취업 : 1, 미취업 : 0
jobSurvival$isEmployed <- ifelse(jobSurvival$isEmployed == "취업", 1, 0)

library(survival)

attach(jobSurvival)

S <- Surv(time = graduate_year - graduate_year,
          time2 = term_time,
          event = isEmployed)

surv_model <- coxph(S ~ isLiberal + isMinor + isMultiMajor + isTransfer + toeic + GPA, data = jobSurvival)

plot(survfit(surv_model), xlim = c(0, 20))


# Random Forest -----------------------------------------------------------
library(randomForest)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

Formula <- isEmployed ~ GPA + isLiberal + isMinor + isMultiMajor + term_time + toeic

rf <- randomForest(Formula, data = jobSurvival, ntree = 100, proximity = TRUE)
varImpPlot(rf)

dt <- rpart(Formula, data = jobSurvival, control = rpart.control (minsplit=10))
dt
my_tree <- fancyRpartPlot(dt)
