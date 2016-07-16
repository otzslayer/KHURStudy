# Week 4 ------------------------------------------------------------------
# Data Visualization II ---------------------------------------------------

# Scatter Plot ------------------------------------------------------------

# theme_set(theme_gray())

library(gcookbook)
library(dplyr)
library(ggplot2)

# 1.
heightweight

# 나이와 키 사이의 관계를 보고자 한다.
ggplot(data = heightweight, aes(x = ageYear, y = heightIn)) +
        geom_point()

ggplot(data = heightweight, aes(x = ageYear, y = heightIn)) + 
        geom_point(shape = 21)

# 성별에 따라서 색을 다르게 할 수 있다.
ggplot(data = heightweight, aes(x = ageYear, y = heightIn, colour = sex)) +
        geom_point() +
        geom_smooth(method = "lm")

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, colour = sex, shape = sex)) + 
        geom_point() +
        geom_smooth(method = "lm")

# 몸무게가 높을 수록 색을 진하게 하거나, 점의 크기를 크게 할 수 있다.
ggplot(data = heightweight, aes(x = ageYear, y = heightIn, colour = weightLb)) +
        geom_point()

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, size = weightLb)) + 
        geom_point()

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, colour = weightLb, size = weightLb)) + 
        geom_point()

# 2.
data(diamonds)
tbl_df(diamonds)

ggplot(diamonds, aes(x = carat, y = price)) +
        geom_point()

# 점이 너무 많아서 보기가 힘들다. 그럴 땐
ggplot(diamonds, aes(x = carat, y = price)) +
        geom_point(alpha = .1)

ggplot(diamonds, aes(x = carat, y = price)) + 
        geom_point(alpha = .1, position = "jitter")

ggplot(diamonds, aes(x = carat, y = price, colour = color)) +
        geom_point(alpha = .2) +
        facet_wrap( ~ cut, nrow = 1)

# 3.
tbl_df(countries)

ctr <- countries %>%
        filter(Year == 2009, healthexp > 2000)
ctr

ggplot(data = ctr, aes(x = healthexp, y = infmortality)) +
        geom_point()

ggplot(data = ctr, aes(x = healthexp, y = infmortality)) +
        geom_point() +
        geom_text(aes(label = Name), size = 3, hjust = -.15)


# Data Distribution -------------------------------------------------------

# 1. Histogram

faithful

ggplot(data = faithful, aes(x = waiting)) + 
        geom_histogram()

# stat_bin() 이 뭘까?
# bin : 뚜껑 달린 상자?

ggplot(data = faithful, aes(x = waiting)) + 
        geom_histogram(binwidth = 2)

###
### 실습
install.packages("MASS")
library(MASS)

birthwt # 저체중아 출산 요소에 대한 데이터
?birthwt

# 산모의 흡연 여부로 나누기

ggplot(birthwt, aes(x = bwt)) +
        geom_histogram(fill = "white", colour = "black") + 
        facet_grid(smoke ~ .)

# Label이 0, 1로 나오는건 그닥 도움이 되지 않는다.

birthwt %>%
        mutate(smoke_label = ifelse(birthwt$smoke == 0, "No Smoke", "Smoke")) %>%
        ggplot(aes(x = bwt)) + 
        geom_histogram(fill = "white", colour = "black") +
        facet_grid(smoke_label ~ .)

ggplot(birthwt, aes(x = bwt, fill = factor(smoke))) + 
        geom_histogram(position = "identity", alpha = .4)

# 2. Density Curve

ggplot(faithful, aes(x = waiting)) + 
        geom_density()

ggplot(faithful, aes(x = waiting)) + 
        geom_line(stat = "density")

ggplot(faithful, aes(x = waiting, y = ..density..)) + 
        geom_histogram(fill = "cornsilk", colour = "grey60") +
        geom_density()

# 3. Box plot

ggplot(birthwt, aes(x = factor(race), y = bwt)) + 
        geom_boxplot()

ggplot(birthwt, aes(x = factor(race), y = bwt)) + 
        geom_boxplot(notch = TRUE)

ggplot(birthwt, aes(x = factor(race), y = bwt)) + 
        geom_boxplot() +
        stat_summary(fun.y = "mean", geom = "point", shape = 23, size = 3, fill = "white")

# 4. Density 2D

ggplot(faithful, aes(x = eruptions, y = waiting)) +
        geom_point() +
        stat_density2d()

ggplot(faithful, aes(x = eruptions, y = waiting)) +
        geom_point() +
        stat_density2d(aes(colour = ..level..))

ggplot(faithful, aes(x = eruptions, y = waiting)) +
        stat_density2d(aes(fill = ..density..), geom = "raster", contour = FALSE)

ggplot(faithful, aes(x = eruptions, y = waiting)) +
        geom_point() +
        stat_density2d(aes(alpha = ..density..), geom = "tile", contour = FALSE)


# Maps --------------------------------------------------------------------

# install.packages("maps")
library(maps)
library(mapproj)

states_map <- map_data("state")
ggplot(states_map, aes(x = long, y = lat, group = group)) +
        geom_polygon(fill = "white", colour = "black", size = .1)

world_map <- map_data("world")
east_asia <- map_data("world",
                      region = c("Japan", "China", "North Korea", "South Korea"))

ggplot(east_asia, aes(x = long, y = lat, group = group, fill = region)) + 
        geom_polygon(alpha = .5, colour = "black", size = .1)


# 실습
USArrests

crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
crimes
head(states_map)

# 데이터를 합친다.
# crimes 데이터의 states 열과 states_map 데이터의 region 열을 기준으로 합친다.
crime_map <- merge(states_map, crimes, by.x = "region", by.y = "state")
head(crime_map)

crime_map <- crime_map %>%
        arrange(group, order)
head(crime_map)

ggplot(crime_map, aes(x = long, y = lat, group = group, fill = Assault)) + 
        geom_polygon(colour = "black", size = .1) + 
        coord_map("polyconic")

ggplot(crimes, aes(map_id = state, fill=Assault)) +
        geom_map(map = states_map, colour="black", size = .1) +
        scale_fill_gradient2(low = "#559999", mid = "grey90", high = "#BB650B",
                             midpoint = median(crimes$Assault)) +
        expand_limits(x = states_map$long, y = states_map$lat) +
        coord_map("polyconic")



# Machine Learning --------------------------------------------------------
# Linear Regression -------------------------------------------------------

# Step 1. Data Collecting -------------------------------------------------

library(dplyr)

insurance <- read.csv("insurance.csv", stringsAsFactors = TRUE)
insurance <- tbl_df(insurance)
insurance

# 각 변수들의 의미는 무엇일까?


# Step 2. Data Exploration & Preprocessing --------------------------------
str(insurance) # 1338개의 관측치, 7개의 어트리뷰트
summary(insurance)

# 의료비 분포를 확인하자.
ggplot(data = insurance, aes(x = charges)) + 
        geom_histogram(fill = "white", colour = "grey60")

ggplot(data = insurance, aes(x = 1, y = charges)) + 
        geom_boxplot() +
        stat_summary(fun.y = "mean", geom = "point", shape = 23, size = 3, fill = "white")

## 주의 : 회귀모델은 수치형 데이터가 필요하다. 범주형 데이터는 바꿀 것!

table(insurance$region) # 지역별로 굉장히 균일하다.

## 주의 : 다중공선성에 유의할 것
## 다중공선성 : 독립변수 사이의 상관관계가 높은 경우
## 상관계수를 살펴보자.

# 밑에 코드가 안될 경우 이 세 줄을 실행한다.
detach("package:MASS", unload=TRUE)
detach("package:dplyr", unload=TRUE)
library(dplyr)

insurance %>%
        select(age, bmi, children, charges) %>%
        cor()

install.packages("GGally")
library(GGally)

insurance %>%
        select(age, bmi, children, charges) %>%
        ggpairs()


# Step 3. Build a Model ---------------------------------------------------

# lm() : R에 기본으로 있는 회귀모델 함수
# 모델 만들기 : m <- lm(종속변수 ~ 독립변수, data = ???)
# 예측하기 : p <- predict(m, test_data)

ins_model <- lm(charges ~ age + children + bmi + sex + smoker + region, data  = insurance)

# 공식 다 치기 귀찮으시죠 ?

dimnames(insurance)[[2]]

independent_vars <- dimnames(insurance)[[2]][1:6]

form1 <- paste0(independent_vars, collapse = " + ")
formula <- paste("charges", form1, sep = " ~ ")
formula

ins_model <- lm(formula = formula, data = insurance)
ins_model


# Step 4. Evaluating Model ------------------------------------------------
summary(ins_model)
plot(ins_model)


# Step 5. Improving a Model -----------------------------------------------

# 1. 비만 여부로 체크해보자.
# 비만은 BMI가 30 이상일 때이므로...

insurance <- insurance %>%
        mutate(bmi30 = ifelse(insurance$bmi >= 30, 1, 0))

# BMI 는 bmi30과 다중공선성이 발생할 여지가 있으므로 빼자.

ins_model_2 <- lm(charges ~ age + children + bmi30 + sex + smoker + region, data = insurance)

summary(ins_model_2)
# 0.754

# 조금 더 좋아졌네?

# 2. 비만은 흡연과 함께 있을 때 위험하다.

ins_model_3 <- lm(charges ~ age + children + bmi30*smoker + sex + region, data = insurance)

summary(ins_model_3)
# 0.8627