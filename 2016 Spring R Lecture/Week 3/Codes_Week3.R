
# Week 3 ------------------------------------------------------------------
# Installing R Packages ---------------------------------------------------

# 패키지를 설치하려면
# install.packages("패키지 이름")
# 반드시 따옴표를 붙여야 함

# 패키지를 불러오려면
# library(패키지 이름)
# 따옴표를 안붙여도 됨


# Data Manipulation II ----------------------------------------------------
# Package : dplyr ---------------------------------------------------------

# 사용할 데이터는 2013년 뉴욕 항공 데이터다.
# 패키지를 설치한 후 불러와서 데이터를 다뤄보도록 하자.
install.packages("nycflights13")
library(nycflights13)

# 데이터를 핸들링할 때는 dplyr 패키지를 쓴다.
install.packages("dplyr")
library(dplyr)

data(flights)
flights

# 데이터를 요약하고 구조를 확인하려면 summary() 함수와 str() 함수를 사용
summary(flights)
str(flights)

# 데이터의 차원은 dim()
dim(flights)


# filter() ----------------------------------------------------------------
# 만약 5월의 비행 데이터를 보고 싶은데, dplyr() 패키지를 모른다면?
flights[flights$month == 5, ]
# 인덱스를 사용해야되고, 길이도 길고, $를 이용해서 칼럼에 접근해야 한다.

filter(flights, month == 5)

filter(flights, dep_time > 1830)

filter(flights, distance > 4000)

# 여러 개의 조건을 한꺼번에 사용할 수 있다.
# filter(data, A, B, C, ...)

filter(flights, month == 5, day == 24)


# select() ---------------------------------------------------------------
# 원하는 칼럼을 뽑는 방법은 원래...
flights[, c("dep_time", "arr_time", "flight")]
# 여전히 짜증난다.

select(flights, dep_time, arr_time, flight)

# select()는 굉장히 편한 기능들을 가지고 있다.

# 1. 연속적인 칼럼은 이렇게 뽑아낼 수 있다.
# 만약 month부터 arr_delay까지 다 뽑아내려면 8개의 이름을 다 써야할까?
select(flights, month:arr_delay)

# 2. 칼럼 이름에 특정 문자를 포함하고 있는 칼럼을 뽑아낼 수 있다.
# time, delay 가 포함된 칼럼을 다 뽑아내자.
select(flights, contains("time"), contains("delay"))
# contains : 단수 명사....?

select(flights, year:month, contains("time"), contains("delay"))

# 3. 버리고 싶은 칼럼이 있으면, 버릴 수 있다.
# year는 어차피 2013이니까 필요가 없다.
select(flights, -year)

# 연속되는 칼럼도 삭제 가능하다.
select(flights, -(year:day))

# 특정 문자를 포함하고 있는 칼럼도 삭제 가능
select(flights, -contains("time"))



# arrange() ---------------------------------------------------------------
# 선택한 칼럼을 기준으로 정렬한다.
# 기본값은 오름차순.

# 거리 기준으로 오름차순 정렬
arrange(flights, distance)

# 거리, 출발시간 순으로 정렬
arrange(flights, distance, dep_time)

# 내림차순 정렬도 가능하다. descending!
arrange(flights, desc(distance))


# mutate() ----------------------------------------------------------------
# 기존의 칼럼을 이용해서 새로운 칼럼을 생성한다.
# 이 데이터에는 항공기 속도는 나와있지 않다.
# 그럼 만들어야지?

flightsSpeed <- mutate(flights, speed = distance / air_time * 60)
flightsSpeed <- select(flightsSpeed, distance, air_time, speed)
flightsSpeed

# 새로 만든 칼럼만 뽑아내려면?
transmute(flights, speed = distance / air_time * 60)


# group_by() --------------------------------------------------------------
# 데이터를 그룹화한다.
# 각 월 별로 출발, 도착 지연시간을 구하고자 한다.
# 우선 해야할 것은 데이터를 월별로 그룹화해야한다.

grouped_flights <- group_by(flights, month)
grouped_flights

# ???
# 바뀐게 없네?

# 그럴리가

# summarise() -------------------------------------------------------------

summarise(grouped_flights,
          dep_delay_mean = mean(dep_delay, na.rm = T),
          arr_delay_mean = mean(arr_delay, na.rm = T))


# Chaining ----------------------------------------------------------------
# Pipe Operator

a1 <- filter(flights, month == 7 | month == 8)
a2 <- select(a1, month:day, contains("delay"), origin, dest, distance, air_time)
a3 <- mutate(a2, speed = distance / air_time * 60)
a4 <- group_by(a3, dest)
a5 <- summarise(a4,
                arr_delay_mean = mean(arr_delay, na.rm = TRUE))
a6 <- arrange(a5, desc(arr_delay_mean))

# 이 무슨...

new_data <- flights %>%
        filter(month == 7 | month == 8) %>%
        select(month:day, contains("delay"), origin, dest, distance, air_time) %>%
        mutate(speed = distance / air_time * 60) %>%
        group_by(dest) %>%
        summarise(arr_delay_mean = mean(arr_delay, na.rm = TRUE)) %>%
        arrange(desc(arr_delay_mean))

new_data


# Package : reshape2 ------------------------------------------------------
# Layouts -----------------------------------------------------------------
# 와이드 레이아웃의 장점과 롱 레이아웃의 장점
# 와이드 레이아웃 : 용량이 작고, 보기엔 편하다.
# 롱 레이아웃 : 시각화 작업 시에 굉장히 용이하다. 모델링에도 용이함.

# 와이드 레이아웃
students_wide <- data.frame(student = c("A", "B"),
                            korean = c(80, 68),
                            math = c(72, 94),
                            english = c(77, 82))

# 롱 레이아웃
students_long <- data.frame(student = rep(c("A", "B")),
                            subject = rep(c("korean", "math", "english"), each = 2),
                            score = c(80, 68, 72, 94, 77, 82))

install.packages("reshape2")
library(reshape2)

# melt(data, id.vars, measure.vars, variable.name,
#      value.name, na.rm, factorsAsStrings = TRUE)

# id.vars : 기존의 객체들을 구분할 수 있는 칼럼
# measure.vars : 하나의 칼럼으로 나타내고자 하는 기존 데이터의 칼럼
# variable.name : 위의 measure.vars들이 포함될 칼럼의 이름
# value.name : measure.vars의 값들을 나타내는 칼럼의 이름

molten_students <- melt(students_wide, id.vars = "student",
                        measure.vars = c("korean", "math", "english"),
                        variable.name = "subject",
                        value.name = "score")
molten_students

# 만약 measure.vars 의 대상이 모든 칼럼일 때는, 빼도 된다!
molten_students <- melt(students_wide, id.vars = "student",
                        variable.name = "subject",
                        value.name = "score")
molten_students

# dcast(data, formula)
dcast(molten_students, student ~ subject)

# 실습해보자.
# airquality 데이터

data("airquality")
str(airquality)
head(airquality)
summary(airquality)

# 결측값이 제법 있다. 이걸 잘 다뤄야 데이터가 깔끔해진다.

# 열 이름이 대문자 ===> 소문자로 바꾸고 싶다.
names(airquality) <- tolower(names(airquality))

# 얘는 무슨 레이아웃일까?
# Wide, now.

# long-layout으로 바꿔주자
# 어떤걸로 데이터를 구분해야할까? : 월, 일 => id.vars
# 하나의 칼럼으로 나타낼 수 있는건? : 대기질 데이터들 (나머지 칼럼 전부)
# 변수 이름을 좀 더 의미있게 써주는 것이 좋다
# 그러므로, climate_variable 로 이름을 정하자.

molten_airq <- melt(airquality, id.vars = c("month", "day"),
                    variable.name = "climate_variable", 
                    value.name = "climate_value")
head(molten_airq)

# 결측값이 꼴보기 싫다면
molten_airq <- melt(airquality, id.vars = c("month", "day"),
                    variable.name = "climate_variable", 
                    value.name = "climate_value",
                    na.rm = TRUE)
head(molten_airq)

# 다시 wide-layout으로 바꿔주자.
# 데이터 프레임 형태로 반환하려고 한다.
wide_airq <- dcast(molten_airq,
                   month + day ~ climate_variable,
                   value.var = "climate_value")
head(wide_airq)


# ggplot2 -----------------------------------------------------------------
# 세팅을 조금만 해주자.

# ggplot2의 단점은 한글 출력이 제법 어렵다는 점이다.
# 우선은 영어로 사용하되, 한글로 출력하려면 다음의 과정이 필요하다.

# Windows 사용자
windowsFonts(malgun = windowsFont("맑은 고딕"))

# mac 사용자 : 밑 사이트 참조
# http://freesearch.pe.kr/archives/4446

# 시간이 허락한다면, 추후에 한글 출력에 대해서 수업할 예정


# 1. 막대그래프 ----------------------------------------------------------------
library(ggplot2)
library(gcookbook)
library(dplyr)

## 1. 
pgMean <- PlantGrowth %>%
        group_by(group) %>%
        summarise(weight = mean(weight))

# 각 그룹별로 무게를 나타내보자.

ggplot(data = pgMean, aes(x = group, y = weight)) +
        geom_bar(stat = "identity")

## 2.

BOD # Time == 6 이 없다.
ggplot(BOD, aes(x = Time, y = demand)) +
        geom_bar(stat = "identity")

ggplot(BOD, aes(x = factor(Time), y = demand)) +
        geom_bar(stat = "identity")

## 3.

cabbage_exp

ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
        geom_bar(stat = "identity")

ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
        geom_bar(stat = "identity", position = "dodge")


diamonds

ggplot(diamonds, aes(x = cut)) +
        geom_bar()

## 5.

uspopchange

upc <- uspopchange %>%
        filter(rank(Change) > 40)
upc

ggplot(upc, aes(x = Abb, y = Change, fill = Region)) + 
        geom_bar(stat = "identity")

## 6.

csub <- climate %>%
        filter(Source == "Berkeley" & Year >= 1900) %>%
        mutate(pos = Anomaly10y >= 0)

ggplot(csub, aes(x = Year, y = Anomaly10y)) + 
        geom_bar(stat = "identity", position = "identity")


ggplot(csub, aes(x = Year, y = Anomaly10y, fill = pos)) + 
        geom_bar(stat = "identity", position = "identity")


# 2. 선 그래프 ----------------------------------------------------------------

## 1.

BOD

ggplot(BOD, aes(x = Time, y = demand)) + 
        geom_line()

ggplot(BOD, aes(x = factor(Time), y = demand, group = 1)) + 
        geom_line()

ggplot(BOD, aes(x = Time, y = demand)) + 
        geom_line() +
        ylim(0, max(BOD$demand))

ggplot(BOD, aes(x = Time, y = demand)) + 
        geom_line() + 
        geom_point()

## 2.

ToothGrowth

tg <- ToothGrowth %>%
        group_by(supp, dose) %>%
        summarise(length = mean(len))
tg

ggplot(tg, aes(x = dose, y = length, colour = supp)) +
        geom_line()

ggplot(tg, aes(x = dose, y = length, linetype = supp)) +
        geom_line()

# 실수하지 말 것 !
ggplot(tg, aes(x = dose, y = length)) +
        geom_line()

ggplot(tg, aes(x = dose, y = length, colour = supp)) + 
        geom_line(linetype = "dashed") + 
        geom_point(shape = 22, size = 3, fill = "white")

## 3.
head(uspopage)

ggplot(uspopage, aes(x = Year, y = Thousands, fill = AgeGroup)) + 
        geom_area()

ggplot(uspopage, aes(x = Year, y = Thousands, fill = AgeGroup)) +
        geom_area(colour = "black", size = .2, alpha = .4) + 
        scale_fill_brewer(palette="Blues", breaks = rev(levels(uspopage$AgeGroup)))
