Introduction
================
Jaeyoon Han
2016-07-17

R Basic Syntax
==============

Calculation
-----------

``` r
10 + 20
```

    [1] 30

``` r
10 - 20
```

    [1] -10

``` r
10 * 20
```

    [1] 200

``` r
10/20
```

    [1] 0.5

``` r
10^2
```

    [1] 100

``` r
10%%20  # Remainder
```

    [1] 10

``` r
25%/%7  # Quotient
```

    [1] 3

``` r
log(100)
```

    [1] 4.60517

``` r
log(100, base = 10)  # 밑이 10인 로그 (상용로그)
```

    [1] 2

``` r
exp(2)
```

    [1] 7.389056

``` r
log(exp(2))
```

    [1] 2

Variable
--------

``` r
one <- 1
two <- 2
one
```

    [1] 1

``` r
two
```

    [1] 2

``` r
one + two
```

    [1] 3

``` r
three <- one + two
three
```

    [1] 3

``` r
# 이미 저장되어 있는 변수들
pi
```

    [1] 3.141593

``` r
letters
```

     [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
    [18] "r" "s" "t" "u" "v" "w" "x" "y" "z"

``` r
LETTERS
```

     [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q"
    [18] "R" "S" "T" "U" "V" "W" "X" "Y" "Z"

``` r
# 문자열 저장도 가능하다.
hi <- "hi"
hi
```

    [1] "hi"

``` r
introduce <- "My Name Is"
name <- "NAME"
paste(introduce, name)  # paste : 두 문자열을 붙이는 함수
```

    [1] "My Name Is NAME"

``` r
one
```

    [1] 1

``` r
hi
```

    [1] "hi"

``` r
class(one)  # numeric : 숫자, 수치형
```

    [1] "numeric"

``` r
class(hi)  # character : 스트링, 문자열
```

    [1] "character"

``` r
class(1)
```

    [1] "numeric"

``` r
class("1")
```

    [1] "character"

``` r
# A == B : A 와 B가 같습니까?  logical : 논리값
1 == 2  # FALSE
```

    [1] FALSE

``` r
one == 1  # TRUE
```

    [1] TRUE

``` r
TRUE & TRUE
```

    [1] TRUE

``` r
TRUE & FALSE
```

    [1] FALSE

``` r
TRUE | FALSE
```

    [1] TRUE

``` r
FALSE | FALSE
```

    [1] FALSE

Missing Value
-------------

결측값은 데이터 핸들링, 예측 모델 구축 등 모든 작업에 있어서 올바른 연산값을 반환하지 않는다. 따라서 데이터 전처리 과정에서 반드시 다뤄야하는 값들이다. 삭제하거나, 메꾸거나.

``` r
NA
```

    [1] NA

``` r
1 + NA  # 알고 있는 것 + 알 수 없는 것
```

    [1] NA

``` r
is.na(NA)  # NA 확인법
```

    [1] TRUE

``` r
is.na(1)
```

    [1] FALSE

``` r
NaN
```

    [1] NaN

``` r
1 + NaN  # 숫자 + 숫자 아닌 것
```

    [1] NaN

``` r
0/0
```

    [1] NaN

``` r
is.nan(NaN)
```

    [1] TRUE

``` r
NULL
```

    NULL

``` r
is.null(NULL)
```

    [1] TRUE

``` r
1 + NULL
```

    numeric(0)

Data Type
=========

Vector
------

`1`, `2`와 같이 하나씩 있는 것들을 **스칼라(Scalar)**라고 한다. 이들을 모아놓으면 **벡터(Vector)**가 된다.

``` r
x <- c(1, 2, 3, 4, 5)
x
```

    [1] 1 2 3 4 5

``` r
1:5
```

    [1] 1 2 3 4 5

``` r
class(x)
```

    [1] "numeric"

``` r
x <- c("1", "2", "3")
x
```

    [1] "1" "2" "3"

``` r
class(x)
```

    [1] "character"

``` r
x <- as.numeric(x)
x
```

    [1] 1 2 3

``` r
class(x)
```

    [1] "numeric"

`seq()` 함수와 `rep()` 함수를 쓰면 원하는 숫자 나열을 얻어낼 수 있다.

``` r
seq(1, 10)  # 1부터 10까지
```

     [1]  1  2  3  4  5  6  7  8  9 10

``` r
seq(1, 10, by = 2)  # 1부터 10까지, 한 칸씩 띄어서
```

    [1] 1 3 5 7 9

``` r
rep(1:4, 2)  # 1부터 4까지 2 번 반복
```

    [1] 1 2 3 4 1 2 3 4

``` r
rep(1:4, each = 2)  # 1부터 4까지 숫자를 각각 2번씩 반복
```

    [1] 1 1 2 2 3 3 4 4

벡터에 있는 값들에 직접 접근하려면 인덱스 개념을 사용한다.

``` r
letters
```

     [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
    [18] "r" "s" "t" "u" "v" "w" "x" "y" "z"

``` r
letters[c(1, 3, 5)]
```

    [1] "a" "c" "e"

Factor
------

``` r
gender <- c(rep("male", 20), rep("female", 30))
gender <- factor(gender)
gender
```

     [1] male   male   male   male   male   male   male   male   male   male  
    [11] male   male   male   male   male   male   male   male   male   male  
    [21] female female female female female female female female female female
    [31] female female female female female female female female female female
    [41] female female female female female female female female female female
    Levels: female male

``` r
summary(gender)
```

    female   male 
        30     20 

``` r
levels(gender) <- c("여성", "남성")
summary(gender)
```

    여성 남성 
      30   20 

``` r
mat <- matrix(data = 1:9, ncol = 3)
mat
```

         [,1] [,2] [,3]
    [1,]    1    4    7
    [2,]    2    5    8
    [3,]    3    6    9

``` r
matrix(data = 1:9, nrow = 3)
```

         [,1] [,2] [,3]
    [1,]    1    4    7
    [2,]    2    5    8
    [3,]    3    6    9

``` r
mat <- matrix(data = 1:9, nrow = 3, byrow = TRUE)
mat
```

         [,1] [,2] [,3]
    [1,]    1    2    3
    [2,]    4    5    6
    [3,]    7    8    9

``` r
mat[1, ]
```

    [1] 1 2 3

``` r
mat[, 1]
```

    [1] 1 4 7

``` r
mat[2, 2]
```

    [1] 5

``` r
mat * 2
```

         [,1] [,2] [,3]
    [1,]    2    4    6
    [2,]    8   10   12
    [3,]   14   16   18

``` r
mat/2
```

         [,1] [,2] [,3]
    [1,]  0.5  1.0  1.5
    [2,]  2.0  2.5  3.0
    [3,]  3.5  4.0  4.5

``` r
dim(mat)
```

    [1] 3 3

``` r
grade <- list(name = c("A", "B", "C"), score = c(90, 80, 70), grade = c("A+", 
    "B+", "B0"))

grade[1]
```

    $name
    [1] "A" "B" "C"

``` r
grade[2]
```

    $score
    [1] 90 80 70

``` r
grade[3]
```

    $grade
    [1] "A+" "B+" "B0"

``` r
grade[[1]]
```

    [1] "A" "B" "C"

``` r
grade[[2]]
```

    [1] 90 80 70

``` r
grade[[3]]
```

    [1] "A+" "B+" "B0"

``` r
grade[[1]][1]
```

    [1] "A"

``` r
grade_df <- data.frame(name = c("A", "B", "C"), score = c(90, 80, 70), grade = c("A+", 
    "B+", "B0"))

as.data.frame(grade)
```

      name score grade
    1    A    90    A+
    2    B    80    B+
    3    C    70    B0

``` r
identical(as.data.frame(grade), grade_df)
```

    [1] TRUE

Control Statement
=================

if, else
--------

``` r
## if(조건){ 실행할 내용 } else { 실행할 내용 }

x <- sample(1:100, 1)
x
```

    [1] 40

``` r
if ((x%%2) == 1) {
    paste0(x, "는 홀수입니다.")
} else {
    paste0(x, "는 짝수입니다.")
}
```

    [1] "40는 짝수입니다."

``` r
x <- 1:10
if ((x%%2) == 1) {
    paste0(x, "는 홀수입니다.")
} else {
    paste0(x, "는 짝수입니다.")
}
```

     [1] "1는 홀수입니다."  "2는 홀수입니다."  "3는 홀수입니다." 
     [4] "4는 홀수입니다."  "5는 홀수입니다."  "6는 홀수입니다." 
     [7] "7는 홀수입니다."  "8는 홀수입니다."  "9는 홀수입니다." 
    [10] "10는 홀수입니다."

``` r
# Warning!

ifelse(x%%2 == 0, paste0(x, "는 짝수입니다."), paste0(x, "는 홀수입니다."))
```

     [1] "1는 홀수입니다."  "2는 짝수입니다."  "3는 홀수입니다." 
     [4] "4는 짝수입니다."  "5는 홀수입니다."  "6는 짝수입니다." 
     [7] "7는 홀수입니다."  "8는 짝수입니다."  "9는 홀수입니다." 
    [10] "10는 짝수입니다."

``` r
x <- 18
x%%4
```

    [1] 2

``` r
switch(x%%4, "나머지 1", "나머지 2", "나머지 3", "4의 배수")
```

    [1] "나머지 2"

For Loop
--------

``` r
sequence <- 2010:2016
sequence
```

    [1] 2010 2011 2012 2013 2014 2015 2016

``` r
for (i in sequence) {
    cat("올해는", i, "년 입니다. \n")
}
```

    올해는 2010 년 입니다. 
    올해는 2011 년 입니다. 
    올해는 2012 년 입니다. 
    올해는 2013 년 입니다. 
    올해는 2014 년 입니다. 
    올해는 2015 년 입니다. 
    올해는 2016 년 입니다. 

``` r
set.seed(1234)  # 난수 고정
check <- sample(x = 1:100, size = 15)
check
```

     [1] 12 62 60 61 83 97  1 22 99 47 63 49 25 81 26

``` r
## 이 중 홀수가 몇 개 있는지 찾고자 한다.
count <- 0
for (i in 1:length(check)) {
    if (check[i]%%2 == 1) {
        cat(check[i], "는 홀수입니다. COUNT!\n")
        count <- count + 1
    } else {
        cat(check[i], "는 짝수입니다. \n")
    }
}
```

    12 는 짝수입니다. 
    62 는 짝수입니다. 
    60 는 짝수입니다. 
    61 는 홀수입니다. COUNT!
    83 는 홀수입니다. COUNT!
    97 는 홀수입니다. COUNT!
    1 는 홀수입니다. COUNT!
    22 는 짝수입니다. 
    99 는 홀수입니다. COUNT!
    47 는 홀수입니다. COUNT!
    63 는 홀수입니다. COUNT!
    49 는 홀수입니다. COUNT!
    25 는 홀수입니다. COUNT!
    81 는 홀수입니다. COUNT!
    26 는 짝수입니다. 

``` r
## next 1부터 10까지 숫자 중에서 홀수만 뽑아보자.  next는 해당 루프를
## 넘어간다.
for (i in 1:10) {
    if (i%%2 == 0) {
        next  # 짝수면 루프 넘어가기
    }
    print(i)
}
```

    [1] 1
    [1] 3
    [1] 5
    [1] 7
    [1] 9

While loop
----------

``` r
for (i in 1:100) {
    if (i%%7 == 0) {
        print(i)
    }
}
```

    [1] 7
    [1] 14
    [1] 21
    [1] 28
    [1] 35
    [1] 42
    [1] 49
    [1] 56
    [1] 63
    [1] 70
    [1] 77
    [1] 84
    [1] 91
    [1] 98

``` r
## while문을 사용하면

i <- 1  # 반드시 선언할 것
while (i <= 100) {
    if (i%%7 == 0) {
        print(i)
    }
    
    i <- i + 1  # 하나를 더해주지 않으면 무한 반복이 일어난다.
}
```

    [1] 7
    [1] 14
    [1] 21
    [1] 28
    [1] 35
    [1] 42
    [1] 49
    [1] 56
    [1] 63
    [1] 70
    [1] 77
    [1] 84
    [1] 91
    [1] 98
