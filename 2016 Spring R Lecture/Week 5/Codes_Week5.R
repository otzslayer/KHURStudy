# Week 5 ------------------------------------------------------------------

# Libraries
install.packages("rpart")
install.packages("randomForest")
library(rpart)                  # Predict age
library(randomForest)           # Random Forest
library(dplyr)                  # Manipulating the data
library(ggplot2)                # Visualizing the data

# 1. 데이터 수집
# Titanic 데이터
titanic <- read.csv("titanic.csv", stringsAsFactors = FALSE)
titanic <- tbl_df(titanic)
titanic
View(titanic)

# 2. 데이터 탐색 및 전처리
# 이전과 다르게 데이터가 굉장히 지저분하다.
# 따라서 전처리에 심혈을 기울여야 한다.
# 전처리를 하기 위해선 데이터의 분포, 결측값 등을 확인해야 한다.

str(titanic)
summary(titanic)

titanic$Sex <- as.factor(titanic$Sex)
titanic$Embarked <- as.factor(titanic$Embarked)
titanic$Survived <- as.factor(titanic$Survived)
titanic$Pclass <- as.factor(titanic$Pclass)

# 1등실, 2등실, 3등실의 분포를 확인하자.
# 하나의 데이터만 다룰 때는 attach() 함수를 이용해서
# 더 편하게 다룰 수 있다.
attach(titanic)                                 # 모든 칼럼이 변수화되었다.

table(Pclass)                                   # 3등실의 인원이 굉장히 많다.
table(Pclass, Sex)                              # 남녀의 비율을 볼 수 있다.
prop.table(table(Pclass, Sex), margin = 1)      # 전체적으로 남자가 많다.

# 결측값이 굉장히 많다.
# 당장에 나이 칼럼은 263개가 결측값이다.
# 우선 Fare 칼럼의 결측값 하나를 처리하자.

# Handle the missing data (1) : Fare
# 결측값이 하나다. 분포를 확인해보자.
ggplot(data = titanic, aes(x = Fare)) + 
        geom_density()                          # 왼쪽에 치우친 분포다.
summary(Fare)

# 중앙값이 평균에 비해 굉장히 작은 것을 알 수 있다.
# 결측값이 있는 경우, 데이터를 지우거나, 그 값을 채우면 된다.
# 이번엔, 전체 분포에 문제없도록 중앙값을 넣도록 한다.

titanic$Fare[is.na(Fare)] <- median(Fare, na.rm = T)

# Handle the missing data (2) : Embarked
# 이번엔 탑승지 데이터를 보도록 하자.
table(Embarked)                                 # 빈 데이터가 두 개가 있다.
# C : Cherbourg, Q : Queenstown, S : Southampton
# 빈 값들은 S로 바꿔주자. 제일 많기 때문에 두 개가 늘어도 문제가 없다.
titanic$Embarked[Embarked == ''] <- "S"
table(titanic$Embarked)
# 빈 곳에 0 이 있다. 없애려면
titanic$Embarked <- as.factor(as.character(titanic$Embarked))


# Handle the missing data (3) : Age
# 나이는 결측값이 263개나 되기 때문에, 기존의 방법으론 불가능하다.

ggplot(data = titanic, aes(x = 1, y = Age)) + 
        geom_boxplot()

table(ceiling(Age))

ggplot(data = titanic, aes(x = ceiling(Age), fill = Sex)) + 
        geom_bar(position = "dodge")

ggplot(data = titanic, aes(x = ceiling(Age), fill = Sex)) + 
        geom_bar() +
        facet_wrap( ~ Sex)

# 결측값을 제외하고 나이를 올림해서 막대그래프를 그리면 다음과 같다.
# 20세 근처의 승객이 가장 많고, 생각보다 1~10세가 많다.

# 어렵지만 선형회귀법을 사용해서 나이를 예측하자.
# 의사결정나무로도 예측할 수 있다. 하지만, 결과가 너무 이분법적으로 나옴
Agefit <- lm(Age ~ Sex + Fare + Embarked + Sibsp + Parch,
                data = titanic[!is.na(Age), ])

summary(Agefit)         # 모델이 심히 안좋다. 기본으로 29살로 시작해서 +- 3살

titanic$Age[is.na(Age)] <- predict(Agefit, titanic[is.na(titanic$Age), ])
summary(titanic$Age)                            # 결측값이 사라졌다.

titanic$Age[titanic$Age < 0] <- 1

ggplot(data = titanic, aes(x = ceiling(Age), fill = Sex)) + 
        geom_bar() +
        facet_wrap( ~ Sex)

# 기본적인 결측값 제거 작업은 완료했다.
# 훈련 데이터와 테스트 데이터를 나눠준다.
# 7:3 비율로 만들기 위해서 sample_frac() 함수를 사용하자.

set.seed(1234)                          # for reproducibility
train <- sample_frac(titanic, 0.7)
train <- train %>%
        arrange(Passengerid)
training_index <- train$Passengerid
test <- titanic[-training_index, ]

# 테스트 데이터에는 생존 여부 데이터가 있으면 안되므로 다른 곳에 저장한다.
survived_test <- test$Survived
test$Survived <- NULL


# 랜덤 포레스트를 적용시켜본다.
set.seed(1234)                          # for reproducibility
firstRF <- randomForest(Survived ~ Pclass + Sex + Age + Fare + Embarked + Sibsp + Parch,
                        data = train,
                        importance = TRUE,
                        ntree = 2000)

firstPredict <- predict(firstRF, test, type = "class")
varImpPlot(firstRF)

# 평가 방법은 Accuracy
# 올바른 예측 / 전체 관측치

accuracy <- function(predict, answer = survived_test){
        identical <- predict == answer
        return(sum(identical)/length(answer))
}

accuracy(firstPredict)                 

# 제법 높은 정확도지만, 새로운 변수를 만들어서 정확도를 높여보자.
# 번거롭지만 원래 데이터에 작업을 하고 다시 훈련 데이터와 테스트 데이터를 나누자.

# 1. Child
# 위키피디아 등을 통해서 어린이의 구조율이 제법 높음을 알 수 있다.
# 18세 미만을 Child로 정의하자.

titanic$Child <- 0

titanic$Child[titanic$Age < 18] <- 1
titanic$Child <- as.factor(titanic$Child)

train <- titanic[training_index, ]
test <- titanic[-training_index, ]

set.seed(1234)                          # for reproducibility
secondRF <- randomForest(Survived ~ Pclass + Sex + Age + Fare + Embarked + Sibsp + Parch + Child,
                        data = train,
                        importance = TRUE,
                        ntree = 2000)

secondPredict <- predict(secondRF, test, type = "class")
varImpPlot(secondRF)
accuracy(secondPredict)                 

# 2. 이름에서 사회적 지위를 알 수 있다.
Name[1]
strsplit("Allen, Miss. Elisabeth Walton", split = '[.,]')
# 두 번째가 Title을 의미한다. 이걸 빼내면 된다.
strsplit("Allen, Miss. Elisabeth Walton", split = '[.,]')[[1]][2]

splitToTitle <- function(x){
        strsplit(x, split = '[.,]')[[1]][2]
}

# sapply() 함수 기억 나시나요? :)
titanic$Title <- sapply(titanic$Name, FUN = splitToTitle)
titanic$Title <- sub(' ', '', titanic$Title)        # 빈공간 제거
table(titanic$Title)

# Mlle = Mademoiselle = Miss, Mme = Madame = Mrs
titanic$Title[titanic$Title == "Mlle"] <- "Miss"
titanic$Title[titanic$Title == "Mme"] <- "Mrs"
titanic$Title[titanic$Title %in% c("Capt", "Don", "Major", "Sir", "Col")] <- "Sir"
titanic$Title[titanic$Title %in% c("Dona", "Lady", "the Countess", "Jonkheer")] <- "Lady"
titanic$Title <- as.factor(titanic$Title)

titanic$Age <- Age

ageModel <- lm(formula = Age ~ Title + Fare + Sibsp + Parch,
               data = titanic[!is.na(Age)])

summary(ageModel)

titanic$Age[is.na(Age)] <- predict(ageModel, titanic[is.na(titanic$Age), ])

titanic$Age[titanic$Age < 0] <- 1

titanic$Child <- 0
titanic$Child[titanic$Age < 18] <- 1
titanic$Child <- as.factor(titanic$Child)

train <- titanic[training_index, ]
test <- titanic[-training_index, ]

set.seed(1234)                          # for reproducibility
thirdRF <- randomForest(Survived ~ Pclass + Sex + Age + Fare + Embarked + Sibsp + Parch + Child + Title,
                         data = train,
                         importance = TRUE,
                         ntree = 2000)

thirdPredict <- predict(thirdRF, test, type = "class")
varImpPlot(thirdRF)
accuracy(thirdPredict)                 

# 3. 가족 크기가 생존율에 영향을 미쳤을까?

titanic <- titanic %>%
        mutate(FamilySize = Sibsp + Parch + 1)
table(titanic$FamilySize)

train <- titanic[training_index, ]
test <- titanic[-training_index, ]

set.seed(1234)                          # for reproducibility
fourthRF <- randomForest(Survived ~ Pclass + Sex + Age + Fare + Embarked + Sibsp + Parch + Child + Title + FamilySize,
                        data = train,
                        importance = TRUE,
                        ntree = 2000)

fourthPredict <- predict(fourthRF, test, type = "class")
varImpPlot(fourthRF)
accuracy(fourthPredict)   

# 너무 변수가 많으면 과적합이 일어날 수 있다.
# 중요하지 않아보이는 변수들은 하나씩 제거해보자.
# 가장 높은 정확도를 보여주는 모델을 채택하면 된다.