# Week 2 ------------------------------------------------------------------
# setwd("./Google Drive/R Lecture/Week 2/")
getwd()

# 스크립트 창에 코드를 작성하고
# Ctrl + Enter(Command + Enter)를 통해서 콘솔에서 실행

# head()
# paste()
# paste0()
# cat()
# summary()
# str()

# DATA IMPORT & EXPORT ----------------------------------------------------
## 데이터를 불러오자.
## read.csv()
## read.csv("파일 경로", stringsAsFactors = FALSE)
## read.csv() 함수는 문자열을 자동으로 Factor형 데이터로 바꾼다.
## 이를 방지하려면 stringAsFactors = FALSE 옵션을 사용한다.
circle <- read.csv("circle.csv", stringsAsFactors = FALSE)
head(circle)

## 본 데이터는 원에 있는 점들에 대한 데이터다.
## 데이터 내의 점들을 순서대로 이으면 원이 나온다.
ggplot(data = circle, aes(x = x, y = y)) + 
        geom_path()

## 데이터를 저장하자.
data(iris)
head(iris)

## write.csv()
## write.csv(데이터 변수 이름, "파일 경로", row.names = FALSE)
## write.csv() 함수를 이용하여 데이터를 저장하면 반드시
## 원하지 않는 '행 이름' 칼럼이 생긴다. 이를 제거하려면
## row.names = FALSE를 사용한다. 필수적인 옵션이다.
## 저장 가능한 데이터는 일반적으로 Data.Frame과 Array이다.
write.csv(iris, "iris.csv", row.names = FALSE)

## 저장했으면 해당 폴더에 저장되었는지 확인하자.
## 일반적으로 경로를 지정하지 않았다면 작업 디렉토리에 저장된다.
## 행 번호가 생성되었다면 저장할 때 row.names = FALSE를 지정하지 않았다.


# CONTROL STATEMENTS ------------------------------------------------------
# IF, ELSE ----------------------------------------------------------------

## 1부터 100까지의 숫자를 랜덤으로 뽑아보자.
## sample(VECTOR, HOW MANY)

x <- sample(1:100, 1)
x

## if(조건){
##      실행할 내용
## } else {
##      실행할 내용
## }

## else는 if의 완전 반대 조건

if((x %% 2) == 1){
        paste0(x, "는 홀수입니다.") 
} else {
        paste0(x, "는 짝수입니다.")
}

ifelse(x %% 2 == 0, paste0(x, "는 짝수입니다."), paste0(x, "는 홀수입니다."))

## ifelse는 벡터도 지원한다.

numbers <- 1 : 30
ifelse((numbers %% 2) == 1, paste0(numbers, "는 홀수입니다."), paste0(numbers, "는 짝수입니다."))

## 조건이 여러개라면?

if(x %% 4 == 1){
        print("나머지 1")
} else if(x %% 4 == 2){
        print("나머지 2")
} else if(x %% 4 == 3){
        print("나머지 3")
} else{
        print("4의 배수")
}


# FOR ---------------------------------------------------------------------
## 반복문

sequence <- 2010:2016
sequence

for(i in sequence){
        cat("올해는", i, "년 입니다. \n")
}

paste0("올해는 ", sequence, "년 입니다.")

# \n : 한 줄 띄라는 의미 (next line)
# cat() : 메시지처럼 출력하고, 문자로 인식하지 않는다.
# paste, paste0 : 문자로 인식해서 출력

############################################
############################################
## 보통 for문을 if절과 함께 사용하는 경우가 많다.

set.seed(1234) # 난수 고정

check <- sample(x = 1:100, size = 15)
check

## 이 중 홀수가 몇 개 있는지 찾고자 한다.

count <- 0

for(i in 1:length(check)){
        if(check[i] %% 2 == 1){
                cat(check[i], "는 홀수입니다. COUNT!\n")
                count <- count + 1
        } else{
                cat(check[i], "는 짝수입니다. \n")
        }
}

## 사실 더 간단하게는..
sum(check %% 2 == 1)

## 피보나치 수열 만들어보기
## 처음 두 수는 만들고 시작해야 된다.

Fibonacci <- c(1, 1)

## 다음 수는 이전 두 수를 더해서...
## 20개까지 만들어보자.

for(i in 3:20){
        Fibonacci[i] <- Fibonacci[i - 1] + Fibonacci[i - 2]
}

Fibonacci

## 실습 : for 문을 이용해서 1부터 100까지의 수 중에서
## 홀수만 다 더해보자.

sum <- 0

for(i in 1:100){
        if(i %% 2 == 1)
                sum <- sum + i
}

sum # 2500

sum <- 0

## 사실 FOR 문은 R 에서는 비효율적인 경우가 제법 있다.
## C 언어나 JAVA의 경우 자주 사용하기는 하지만,
## R에서는 반복문을 사용한 효율적인 라이브러리가 굉장히 많기 때문이다.

## next
## 1부터 10까지 숫자 중에서 홀수만 뽑아보자.
## next는 해당 루프를 넘어간다.
for (i in 1:10) {
        if (i %% 2 == 0){
                next # 짝수면 루프 넘어가기
        }
        print(i)
}


# WHILE -------------------------------------------------------------------
## for문은 정해진 횟수로 반복
## while은 조건이 거짓이 되면 반복 중지

## 100까지의 수 중에서, 7의 배수만 뽑아보자.
## for문을 사용하면

for(i in 1:100){
        if(i %% 7 == 0){
                print(i)
        }
}

## while문을 사용하면

i <- 1 # 반드시 선언할 것
while(i <= 100){
        if(i %% 7 == 0){
                print(i)
        }
        
        i <- i + 1 # 하나를 더해주지 않으면 무한 반복이 일어난다.
}

## 데이터 분석에서는 보통 while보다는 for를 많이 썼던 것 같음.
## 보통 정해진 구간 내에서 반복을 실행하기 때문
## 실제 프로그래밍에서는 while을 더 선호함
## 
## break
## 반복문 안에 사용하며, if 절과 함께 사용한다.

i <- 0
sum <- 0

while(TRUE){
        i <- i + 1
        sum <- sum + i
        
        if(sum > 100){
                cat("합이 100을 넘었습니다. \n")
                cat(i, "까지 더했습니다.")
                break
        }
}

## 실습 : 연속된 수의 합이 517에 도달하려면 몇까지 더해야될까?
## 단, 517을 넘어선 안된다.

sum <- 0
i <- 0

while(sum <= 517){
        i <- i + 1
        sum <- sum + i
        
        if(sum > 517){
                i <- i - 1
                break;
        }
}

i



# Apply Functions ---------------------------------------------------------
# apply() -----------------------------------------------------------------
sum(1:10)

# 3x3 행렬을 만든다.
d <- matrix(1:9, ncol = 3)
d

# 행렬의 각 행의 합을 구하고자 한다.
apply(d, 1, sum)

# 행렬의 각 열의 합을 구하고자 한다.
apply(d, 2, sum)

data(iris)
head(iris)
str(iris)

# 데이터에서 수치형 데이터를 열 단위로 평균을 내고자 한다.
# 수치형 데이터는? : 첫 번째 열부터 네 번째 열
# 계산할 방향은? : 열(column)
# 합을 구하는 함수는? : sum()
# 평균을 구하는 함수는? : mean()

apply(iris[, 1:4], 2, mean)
colSums(iris[, 1:4])

apply(iris[, 1:4], 2, mean)
colMeans(iris[, 1:4])

# lapply() ----------------------------------------------------------------
result <- lapply(1:3, function(x) { x*2 })
result

# apply() 함수를 이용해서 같은 결과를 얻어보자.
as.list(apply(matrix(1:3), 1, function(x) {x*2}))

# 그냥 apply(1:3, 1, function(x) {x*2})) 은 어떻게 될까?

# 결과물에 직접 접근하려면 index를 사용한다.
result[[1]]

# input으로 list가 가능하다.
x <- list(a = 1:3, b = 4:6)
x

lapply(x, mean)

# iris 데이터에도 적용할 수 있다.
lapply(iris[, 1:4], mean)

# apply 함수와 똑같은 결과를 얻으려면?
apply(iris[, 1:4], 2, mean)
unlist(lapply(iris[, 1:4], mean))


# sapply() ----------------------------------------------------------------

iris_mean <- sapply(iris[, 1:4], mean)
iris_mean
class(iris_mean)

# 결과물을 데이터 프레임으로 저장하고 싶다면
as.data.frame(iris_mean)

# 결과물이 원하는 형태가 아닌 것 같은데?
as.data.frame(t(iris_mean))

# 각 변수가 어떤 형태인지도 알 수 있다.
sapply(iris, class)

# 모든 수치 데이터에서 3보다 큰 것이 뭔지 알고 싶다.
greater_than_three <- sapply(iris[, 1:4], function(x) { x > 3 })
head(greater_than_three)

# sapply()는 한 가지 데이터 타입만 반환한다.
# 
# 

# tapply() ----------------------------------------------------------------

# 홀수와 짝수를 따로따로 더하고 싶다.
# 홀수와 짝수를 어떻게 구분하지?

1:10
odd.even <- 1:10 %% 2 == 1
odd.even[odd.even == TRUE] <- "Odd"
odd.even[odd.even == "FALSE"] <- "Even"
odd.even

tapply(1:10, odd.even , sum)

# iris 데이터를 다시 사용한다.
# 꽃받침의 길이를 붓꽃의 종류별로 평균을 구하고 싶다.

tapply(iris$Sepal.Length, iris$Species, mean)
tapply(iris$Sepal.Length, iris$Species, median)
tapply(iris$Sepal.Length, iris$Species, max)
tapply(iris$Sepal.Length, iris$Species, min)

# 조금 더 현실적인 데이터를 생각해보자.
season <- c("Spring", "Summer", "Fall", "Winter")
sex <- c("Male", "Female")
sales <- matrix(1:8, ncol = 2, dimnames=list(season, sex))

# S/S, F/W 남성, 여성별로 집계하고 싶다.
# 각각을 하나의 카테고리로 잡으면...
index <- matrix(rep(1:4, each = 2), ncol = 2)
index

# 이제 결과를 출력해보자.
result <- tapply(sales, index, sum)
names(result) <- c("Male S/S", "Male F/W", "Female S/S", "Female F/W")
result