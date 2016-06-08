### Week 1
### R BASIC SYNTAX

#==========================================================#
#==========================================================#
## 작업 디렉토리 설정
# R에서 작업한 모든 변수, 명령어, 코드 들은 히스토리, rData 파일 등에 모두 저장됨
# 특정 위치에 작업한 것들을 모두 저장해 놓으면 나중에 다시 불러올 수 있다.
setwd("C:/R_Lecture")
getwd()

# 명령어로 설정해놓으면, R을 실행할 때마다 위 코드를 실행해야된다.
# 번거로움을 피하고 싶으면 환경 설정에서 바꾸면 된다!
# 저 폴더에 circle.csv 를 다운로드한다.

#==========================================================#
#==========================================================#
# 계산 기능은 덤
10 + 20
10 - 20
10 * 20
10 / 20
10 ^ 2
10 %% 20
10 %/% 20

log(100)
log(100, base = 10)

exp(2)
log(exp(2))

#==========================================================#
#==========================================================#
## 변수
1 + 2

# 이 값을 어딘가에 저장해서 계속해서 사용하고 싶다.
three <- 1 + 2
three
ls() # 지금까지 저장한 변수들을 확인할 수 있다.
print(three)

zero <- 0
one <- 1
two <- 2
one + two
one / zero

# R에 기본적으로 이미 저장되어 있는 변수들도 있다.
pi
# round는 반올림 해주는 함수다.
# digits는 나타낼 소숫점 자리를 정해준다. 3이라면 세 번째 자리까지.
# 왠만한 기능들은 다 함수로 존재한다.
round(pi, digits = 2)

# 숫자 말고 다른 것들도 저장이 가능하다.
hi <- "Hello, World!"
hi

# 이런 것도 가능하다.
introduce <- "My Name Is"
name <- "Jaeyoon Han"
paste(introduce, name) # paste 는 두 문자열을 합치는 기능을 가지고 있다.


## 각 변수들의 종류를 알아보자.
# numeric, character, logical, factor
one
name

class(one)
class(name)

class(1)
class("1")

equal <- one == name
equal
class(equal)

TRUE & TRUE
TRUE & FALSE
TRUE | FALSE
FALSE | FALSE

# NA, NaN, NULL
# NA : Not Available (사용 불가능)
NA
1 + NA
# 알 수 없는 것과 알고 있는 것을 연산하면 알 수 없는 것이 나온다.
is.na(NA)

# NaN : Not a Number (숫자가 아니다)
NaN
1 + NaN
is.nan(NaN)

# NULL : 아무것도 없는 것
NULL
is.null(NULL)
1 + NULL

sum(1, 2)
sum(1, 2, NA)
sum(1, 2, NaN)
sum(1, 2, NULL)

sum(1, 2, NA, na.rm = T)

#==========================================================#
#==========================================================#
## DATA TYPE
## 1. VECTOR
# Vector는 여러 개의 스칼라 타입 데이터를 포함하고 있다.

# 숫자 다섯 개를 넣어보자.
x <- c(1, 2, 3, 4, 5)
x
class(x)

x <- c("1", "2", "3")
x
class(x)
x <- as.numeric(x)
class(x)

x <- c(1, 2, "3")
x
class(x)

1:5
5:1
-10:4

seq(1, 10)
seq(1, 10, by = 2)

rep(1:4, 2)
rep(1:4, each = 2)

letters
LETTERS

letters[c(1, 3, 5)]
letters[-c(1, 3, 5)]

length(letters)

"a" %in% letters
"A" %in% letters

c(letters, LETTERS)

## 2. FACTOR

gender <- c(rep("male", 20), rep("female", 30))
gender <- factor(gender)
summary(gender)

levels(gender) <- c("여성", "남성")
summary(gender)

size <- c("small", "medium", "large")
size <- ordered(size)
factor(size, levels(size)[3:1])

## 3. MATRIX
mat <- matrix(data = 1:9, ncol = 3)
mat

matrix(data = 1:9, nrow = 3)
mat <- matrix(data = 1:9, nrow = 3, byrow = TRUE)
mat

mat[1, ]
mat[, 1]
mat[2, 2]

mat * 2
mat / 2
mat * mat
mat %*% mat
t(mat)
dim(mat)

two_by_two <- matrix(data = 1:4, nrow = 2)
inverse <- solve(two_by_two)
inverse %*% two_by_two

## 4. ARRAY
iris3

## 5. LIST

grade <- list(name = c("A", "B", "C"),
              score = c(90, 80, 70),
              grade = c("A+", "B+", "B0"))

grade[1]
grade[2]
grade[3]

grade[[1]]
grade[[2]]
grade[[3]]

grade[[1]][1]

## 6. DATA FRAME

grade_df <- data.frame(name = c("A", "B", "C"),
                       score = c(90, 80, 70),
                       grade = c("A+", "B+", "B0"))

as.data.frame(grade_df)

identical(as.data.frame(grade), grade_df)


## IRIS 데이터
iris

# 칼럼 접근하기
# 행 접근하기
# 기본적인 시각화 보여주기
# summary(), str(), table

# read.csv / circle.csv
# 이게 뭐게?
