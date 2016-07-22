Data Handling
================
Jaeyoon Han
2016-07-22

Data Input/Output
=================

``` r
iris <- read.csv("iris.csv")
write.csv(iris, "iris.csv", row.names = FALSE)
```

Apply Functions
===============

apply()
-------

``` r
mat <- matrix(1:9, ncol = 3)
mat
```

         [,1] [,2] [,3]
    [1,]    1    4    7
    [2,]    2    5    8
    [3,]    3    6    9

주어진 행렬에 대해서 각 행의 합과 각 열의 합을 구해보자.

``` r
# mat 행렬을 행(1) 단위로 나눠서 합(sum)을 구한다.
apply(mat, 1, sum)
```

    [1] 12 15 18

``` r
# mat 행렬을 열(2) 단위로 나눠서 합(sum)을 구한다.
apply(mat, 2, sum)
```

    [1]  6 15 24

``` r
head(iris)
```

      Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    1          5.1         3.5          1.4         0.2  setosa
    2          4.9         3.0          1.4         0.2  setosa
    3          4.7         3.2          1.3         0.2  setosa
    4          4.6         3.1          1.5         0.2  setosa
    5          5.0         3.6          1.4         0.2  setosa
    6          5.4         3.9          1.7         0.4  setosa

``` r
apply(iris[, 1:4], 2, mean)
```

    Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
        5.843333     3.057333     3.758000     1.199333 

``` r
apply(iris[, 1:4], 2, median)
```

    Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
            5.80         3.00         4.35         1.30 

``` r
meanIris <- apply(iris[, 1:4], 2, mean)
class(meanIris)
```

    [1] "numeric"

lapply()
--------

무조건 열로 나눈다.

``` r
meanIris <- lapply(iris[, 1:4], mean)
meanIris
```

    $Sepal.Length
    [1] 5.843333

    $Sepal.Width
    [1] 3.057333

    $Petal.Length
    [1] 3.758

    $Petal.Width
    [1] 1.199333

``` r
class(meanIris)
```

    [1] "list"

``` r
unlist(meanIris)  # Vector
```

    Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
        5.843333     3.057333     3.758000     1.199333 

``` r
data.frame(meanIris)  # Data Frame
```

      Sepal.Length Sepal.Width Petal.Length Petal.Width
    1     5.843333    3.057333        3.758    1.199333

sapply()
--------

무조건 열로 나눈다.

``` r
meanIris <- sapply(iris[, 1:4], mean)
meanIris  # Vector
```

    Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
        5.843333     3.057333     3.758000     1.199333 

``` r
greaterThanThree <- function(x) {
    x > 3
}

check <- sapply(iris[, 1:4], greaterThanThree)
head(check)
```

         Sepal.Length Sepal.Width Petal.Length Petal.Width
    [1,]         TRUE        TRUE        FALSE       FALSE
    [2,]         TRUE       FALSE        FALSE       FALSE
    [3,]         TRUE        TRUE        FALSE       FALSE
    [4,]         TRUE        TRUE        FALSE       FALSE
    [5,]         TRUE        TRUE        FALSE       FALSE
    [6,]         TRUE        TRUE        FALSE       FALSE

``` r
head(iris)
```

      Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    1          5.1         3.5          1.4         0.2  setosa
    2          4.9         3.0          1.4         0.2  setosa
    3          4.7         3.2          1.3         0.2  setosa
    4          4.6         3.1          1.5         0.2  setosa
    5          5.0         3.6          1.4         0.2  setosa
    6          5.4         3.9          1.7         0.4  setosa

dplyr Package
=============

``` r
library(dplyr)
library(nycflights13)
```

filter()
--------

``` r
flights[flights$month == 5, ]
filter(flights, month == 7)
filter(flights, dep_time > 1630)
filter(flights, month == 7, dep_time > 1630)
```

select()
--------

``` r
flights[, c("flights", "dep_time", "arr_time")]
select(flights, dep_time, arr_time)

# 1.  1:10처럼 원하는 칼럼을 연속적으로 뽑을 수 있다.
select(flights, month:arr_delay)

# 2. 칼럼 이름에 특정 문자를 포함하고 있는 칼럼을 뽑아낼 수 있다.
select(flights, contains("time"), contains("delay"))

# 3. 조건 앞에 -를 붙이면 해당 칼럼을 뺄 수 있다.
select(flights, -year)
select(flights, -(year:day))
```

arrange()
---------

``` r
arrange(flights, distance)

arrange(flights, distance, dep_time)

arrange(flights, desc(distance))
```

mutate()
--------

``` r
flightsSpeed <- mutate(flights, speed = distance/air_time * 60)
flightsSpeed <- select(flightsSpeed, distance, air_time, speed)
flightsSpeed
```

group\_by() / summarise()
-------------------------

키노트 예제

``` r
Population <- data.frame(No = 1:6, Region = rep(c("Europe", "Asia", "N.America"), 
    each = 2), Nationality = c("England", "Germany", "Korea", "Japan", "Canada", 
    "USA"), Population = c(53.8, 80.7, 50, 126.3, 36.2, 324))
Population
```

      No    Region Nationality Population
    1  1    Europe     England       53.8
    2  2    Europe     Germany       80.7
    3  3      Asia       Korea       50.0
    4  4      Asia       Japan      126.3
    5  5 N.America      Canada       36.2
    6  6 N.America         USA      324.0

``` r
grouped <- group_by(Population, Region)
grouped
```

    Source: local data frame [6 x 4]
    Groups: Region [3]

         No    Region Nationality Population
      <int>    <fctr>      <fctr>      <dbl>
    1     1    Europe     England       53.8
    2     2    Europe     Germany       80.7
    3     3      Asia       Korea       50.0
    4     4      Asia       Japan      126.3
    5     5 N.America      Canada       36.2
    6     6 N.America         USA      324.0

``` r
summarise(grouped, Average = mean(Population))
```

    # A tibble: 3 x 2
         Region Average
         <fctr>   <dbl>
    1      Asia   88.15
    2    Europe   67.25
    3 N.America  180.10

Join
----

``` r
Nation <- data.frame(No = 1:4, Region = rep("Europe", 4), Nationality = c("England", 
    "Germany", "France", "Italy"))

Nation
```

      No Region Nationality
    1  1 Europe     England
    2  2 Europe     Germany
    3  3 Europe      France
    4  4 Europe       Italy

``` r
Capital <- data.frame(Nationality = c("Denmark", "England", "France", "Germany", 
    "Hungary", "Italy"), Capital = c("Copenhagen", "London", "Paris", "Berlin", 
    "Budapest", "Rome"))
Capital
```

      Nationality    Capital
    1     Denmark Copenhagen
    2     England     London
    3      France      Paris
    4     Germany     Berlin
    5     Hungary   Budapest
    6       Italy       Rome

``` r
left_join(Nation, Capital)
```

      No Region Nationality Capital
    1  1 Europe     England  London
    2  2 Europe     Germany  Berlin
    3  3 Europe      France   Paris
    4  4 Europe       Italy    Rome

Pipe Operator
-------------

``` r
a1 <- filter(flights, month == 7 | month == 8)
a2 <- select(a1, month:day, contains("delay"), origin, dest, distance, air_time)
a3 <- mutate(a2, speed = distance/air_time * 60)
a4 <- group_by(a3, dest)
a5 <- summarise(a4, arr_delay_mean = mean(arr_delay, na.rm = TRUE))
a6 <- arrange(a5, desc(arr_delay_mean))

# 이 무슨...

new_data <- flights %>% filter(month == 7 | month == 8) %>% select(month:day, 
    contains("delay"), origin, dest, distance, air_time) %>% mutate(speed = distance/air_time * 
    60) %>% group_by(dest) %>% summarise(arr_delay_mean = mean(arr_delay, na.rm = TRUE)) %>% 
    arrange(desc(arr_delay_mean))

head(new_data)
```

    # A tibble: 6 x 2
       dest arr_delay_mean
      <chr>          <dbl>
    1   CAE       70.06667
    2   TUL       45.19608
    3   TYS       38.93407
    4   CAK       33.70807
    5   BHM       29.82353
    6   OKC       28.88889

reshape2 package
================

Layouts
-------

-   Wide Layout : 용량이 작고, 보기엔 편하다. 높은 가독성.
-   Long Layout : 시각화 작업 시에 굉장히 편하지만 용량이 커지고 가독성이 떨어진다.

``` r
# Wide Layout
students_wide <- data.frame(student = c("A", "B"), korean = c(80, 68), math = c(72, 
    94), english = c(77, 82))

# Long Layout
students_long <- data.frame(student = rep(c("A", "B")), subject = rep(c("korean", 
    "math", "english"), each = 2), score = c(80, 68, 72, 94, 77, 82))
```

``` r
library(reshape2)
```

melt()
------

-   `id.vars` : 기존의 인스턴스들을 구분할 수 있는 칼럼
-   `measure.vars` : 하나의 칼럼으로 나타내고자 하는 칼럼의 이름들
-   `variable.name` : `measure.vars`를 포함하고 있는 칼럼의 이름
-   `value.name` : `measure.vars`의 값들을 나타내는 칼럼의 이름

``` r
# melt(data, id.vars, measure.vars, variable.name, value.name, na.rm,
# factorsAsStrings = TRUE)

molten_students <- melt(students_wide, id.vars = "student", measure.vars = c("korean", 
    "math", "english"), variable.name = "subject", value.name = "score")
molten_students
```

      student subject score
    1       A  korean    80
    2       B  korean    68
    3       A    math    72
    4       B    math    94
    5       A english    77
    6       B english    82

``` r
# 만약 measure.vars 의 대상이 모든 칼럼일 때는, 빼도 된다!
molten_students <- melt(students_wide, id.vars = "student", variable.name = "subject", 
    value.name = "score")
molten_students
```

      student subject score
    1       A  korean    80
    2       B  korean    68
    3       A    math    72
    4       B    math    94
    5       A english    77
    6       B english    82

dcast()
-------

``` r
# dcast(data, formula)
dcast(molten_students, student ~ subject)
```

      student korean math english
    1       A     80   72      77
    2       B     68   94      82

Airquality
----------

``` r
data("airquality")
str(airquality)
```

    'data.frame':   153 obs. of  6 variables:
     $ Ozone  : int  41 36 12 18 NA 28 23 19 8 NA ...
     $ Solar.R: int  190 118 149 313 NA NA 299 99 19 194 ...
     $ Wind   : num  7.4 8 12.6 11.5 14.3 14.9 8.6 13.8 20.1 8.6 ...
     $ Temp   : int  67 72 74 62 56 66 65 59 61 69 ...
     $ Month  : int  5 5 5 5 5 5 5 5 5 5 ...
     $ Day    : int  1 2 3 4 5 6 7 8 9 10 ...

``` r
head(airquality)
```

      Ozone Solar.R Wind Temp Month Day
    1    41     190  7.4   67     5   1
    2    36     118  8.0   72     5   2
    3    12     149 12.6   74     5   3
    4    18     313 11.5   62     5   4
    5    NA      NA 14.3   56     5   5
    6    28      NA 14.9   66     5   6

``` r
summary(airquality)
```

         Ozone           Solar.R           Wind             Temp      
     Min.   :  1.00   Min.   :  7.0   Min.   : 1.700   Min.   :56.00  
     1st Qu.: 18.00   1st Qu.:115.8   1st Qu.: 7.400   1st Qu.:72.00  
     Median : 31.50   Median :205.0   Median : 9.700   Median :79.00  
     Mean   : 42.13   Mean   :185.9   Mean   : 9.958   Mean   :77.88  
     3rd Qu.: 63.25   3rd Qu.:258.8   3rd Qu.:11.500   3rd Qu.:85.00  
     Max.   :168.00   Max.   :334.0   Max.   :20.700   Max.   :97.00  
     NA's   :37       NA's   :7                                       
         Month            Day      
     Min.   :5.000   Min.   : 1.0  
     1st Qu.:6.000   1st Qu.: 8.0  
     Median :7.000   Median :16.0  
     Mean   :6.993   Mean   :15.8  
     3rd Qu.:8.000   3rd Qu.:23.0  
     Max.   :9.000   Max.   :31.0  
                                   

``` r
# 결측값이 제법 있다. 이걸 잘 다뤄야 데이터가 깔끔해진다.

# 열 이름이 대문자 ===> 소문자로 바꾸고 싶다.
names(airquality) <- tolower(names(airquality))

# 얘는 무슨 레이아웃일까?  Wide, now.

# long-layout으로 바꿔주자 어떤걸로 데이터를 구분해야할까? : 월, 일 =>
# id.vars 하나의 칼럼으로 나타낼 수 있는건? : 대기질 데이터들 (나머지 칼럼
# 전부) 변수 이름을 좀 더 의미있게 써주는 것이 좋다 그러므로,
# climate_variable 로 이름을 정하자.

molten_airq <- melt(airquality, id.vars = c("month", "day"), variable.name = "climate_variable", 
    value.name = "climate_value")
head(molten_airq)
```

      month day climate_variable climate_value
    1     5   1            ozone            41
    2     5   2            ozone            36
    3     5   3            ozone            12
    4     5   4            ozone            18
    5     5   5            ozone            NA
    6     5   6            ozone            28

``` r
# 결측값이 꼴보기 싫다면
molten_airq <- melt(airquality, id.vars = c("month", "day"), variable.name = "climate_variable", 
    value.name = "climate_value", na.rm = TRUE)
head(molten_airq)
```

      month day climate_variable climate_value
    1     5   1            ozone            41
    2     5   2            ozone            36
    3     5   3            ozone            12
    4     5   4            ozone            18
    6     5   6            ozone            28
    7     5   7            ozone            23

``` r
# 다시 wide-layout으로 바꿔주자.  데이터 프레임 형태로 반환하려고 한다.
wide_airq <- dcast(molten_airq, month + day ~ climate_variable, value.var = "climate_value")
head(wide_airq)
```

      month day ozone solar.r wind temp
    1     5   1    41     190  7.4   67
    2     5   2    36     118  8.0   72
    3     5   3    12     149 12.6   74
    4     5   4    18     313 11.5   62
    5     5   5    NA      NA 14.3   56
    6     5   6    28      NA 14.9   66
