# install.packages("gapminder")
help(package = "gapminder")
library(gapminder)
?gapminder
gapminder

head(gapminder)

tail(gapminder)

library(dplyr)
glimpse(gapminder)


gapminder$lifeExp
gapminder$gdpPercap
gapminder[, c('lifeExp', 'gdpPercap')]
gapminder %>% select(gdpPercap, lifeExp)

# 요약통계량과 상관관계
summary(gapminder$lifeExp)
summary(gapminder$gdpPercap)
cor(gapminder$lifeExp, gapminder$gdpPercap)


# 베이스 패키지 시각화
opar = par(mfrow=c(2,2))
hist(gapminder$lifeExp)
hist(gapminder$gdpPercap, nclass=50)
# hist(sqrt(gapminder$gdpPercap), nclass=50)
hist(log10(gapminder$gdpPercap), nclass=50)
plot(log10(gapminder$gdpPercap), gapminder$lifeExp, cex=.5)
par(opar)



cor(gapminder$lifeExp, log10(gapminder$gdpPercap))

# 앤스콤의 사인방(Anscombe's quartet)
# https://en.wikipedia.org/wiki/Anscombe%27s_quartet
# https://commons.wikimedia.org/wiki/File:Anscombe%27s_quartet_3.svg
svg("Anscombe's quartet 3.svg", width=11, height=8)
op <- par(las=1, mfrow=c(2,2), mar=1.5+c(4,4,1,1), oma=c(0,0,0,0),
          lab=c(6,6,7), cex.lab=2.0, cex.axis=1.3, mgp=c(3,1,0))
ff <- y ~ x
for(i in 1:4) {
  ff[[2]] <- as.name(paste("y", i, sep=""))
  ff[[3]] <- as.name(paste("x", i, sep=""))
  lmi <- lm(ff, data= anscombe)
  xl <- substitute(expression(x[i]), list(i=i))
  yl <- substitute(expression(y[i]), list(i=i))
  plot(ff, data=anscombe, col="red", pch=21, cex=2.4, bg = "orange",
       xlim=c(3,19), ylim=c(3,13)
       , xlab=eval(xl), ylab=yl  # for version 3
  )
  abline(lmi, col="blue")
}
par(op)
dev.off()

# gapminder 예제의 시각화를 ggplot2로 해보자 (그림 xxx):

library(ggplot2)
library(dplyr)
gapminder %>% ggplot(aes(x=lifeExp)) + geom_histogram()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram() +
  scale_x_log10()
gapminder %>% ggplot(aes(x=gdpPercap, y=lifeExp)) + geom_point() +
  scale_x_log10() + geom_smooth()




library(ggplot2)
?ggplot
example(ggplot)

df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),
                 y = rnorm(30))
glimpse(df)

ds <- df %>% group_by(gp) %>% summarize(mean = mean(y), sd = sd(y))
ds


ggplot(df, aes(x = gp, y = y)) +
   geom_point() +
   geom_point(data = ds, aes(y = mean),
              colour = 'red', size = 3)


ggplot(df) +
   geom_point(aes(x = gp, y = y)) +
   geom_point(data = ds, aes(x = gp, y = mean),
                 colour = 'red', size = 3)


ggplot() +
  geom_point(data = df, aes(x = gp, y = y)) +
  geom_point(data = ds, aes(x = gp, y = mean),
                        colour = 'red', size = 3) +
  geom_errorbar(data = ds, aes(x = gp,
                    ymin = mean - sd, ymax = mean + sd),
                    colour = 'red', width = 0.4)


ggplot(gapminder, aes(lifeExp)) + geom_histogram()
gapminder %>% ggplot(aes(lifeExp)) + geom_histogram()


?diamonds
?mpg
glimpse(diamonds)
glimpse(mpg)

# 1. 한 수량형 변수

library(gapminder)
library(ggplot2)
library(dplyr)
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram() +
  scale_x_log10()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_freqpoly() +
  scale_x_log10()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_density() +
  scale_x_log10()


summary(gapminder)


# 2. 한 범주형 변수

diamonds %>% ggplot(aes(cut)) + geom_bar()

table(diamonds$cut)

prop.table(table(diamonds$cut))

round(prop.table(table(diamonds$cut))*100, 1)

diamonds %>%
  group_by(cut) %>%
  tally() %>%
  mutate(pct = round(n / sum(n) * 100, 1))


# 3. 두 수량형 변수

diamonds %>% ggplot(aes(carat, price)) + geom_point()
diamonds %>% ggplot(aes(carat, price)) + geom_point(alpha=.01)
mpg %>% ggplot(aes(cyl, hwy)) + geom_point()
mpg %>% ggplot(aes(cyl, hwy)) + geom_jitter()


pairs(diamonds %>% sample_n(1000))


# 4. 수량형 변수와 범주형 변수

mpg %>% ggplot(aes(class, hwy)) + geom_boxplot()


mpg %>% ggplot(aes(class, hwy)) + geom_jitter(col='gray') +
  geom_boxplot(alpha=.5)

mpg %>% mutate(class=reorder(class, hwy, median)) %>%
  ggplot(aes(class, hwy)) + geom_jitter(col='gray') +
  geom_boxplot(alpha=.5)

mpg %>%
  mutate(class=factor(class, levels=
                    c("2seater", "subcompact", "compact", "midsize",
                          "minivan", "suv", "pickup"))) %>%
  ggplot(aes(class, hwy)) + geom_jitter(col='gray') +
  geom_boxplot(alpha=.5)

mpg %>%
  mutate(class=factor(class, levels=
                    c("2seater", "subcompact", "compact", "midsize",
                          "minivan", "suv", "pickup"))) %>%
  ggplot(aes(class, hwy)) + geom_jitter(col='gray') +
  geom_boxplot(alpha=.5) + coord_flip()



# 5. 두 범주형 변수

glimpse(data.frame(Titanic))

xtabs(Freq ~ Class + Sex + Age + Survived, data.frame(Titanic))


?Titanic
Titanic


mosaicplot(Titanic, main = "Survival on the Titanic")

mosaicplot(Titanic, main = "Survival on the Titanic", color=TRUE)

# 아이들 사이에 생존률이 더 높을까?
apply(Titanic, c(3, 4), sum)

round(prop.table(apply(Titanic, c(3, 4), sum), margin = 1),3)

# 남-녀 생존률의 비교
apply(Titanic, c(2, 4), sum)

round(prop.table(apply(Titanic, c(2, 4), sum), margin = 1),3)


t2 = data.frame(Titanic)

t2 %>% group_by(Sex) %>%
    summarize(n = sum(Freq),
              survivors=sum(ifelse(Survived=="Yes", Freq, 0))) %>%
    mutate(rate_survival=survivors/n)


# 6. 더 많은 변수를 보여주는 기술 (1): 각 geom 의 다른 속성들을 사용한다.

gapminder %>% filter(year==2007) %>%
  ggplot(aes(gdpPercap, lifeExp)) +
  geom_point() + scale_x_log10() +
  ggtitle("Gapminder data for 2007")


gapminder %>% filter(year==2002) %>%
  ggplot(aes(gdpPercap, lifeExp)) +
  geom_point(aes(size=pop, col=continent)) + scale_x_log10() +
  ggtitle("Gapminder data for 2007")


# 7. 더 많은 변수를 보여주는 기술 (2). facet_* 함수를 사용한다.

gapminder %>%
  ggplot(aes(year, lifeExp, group=country)) +
  geom_line()


gapminder %>%
  ggplot(aes(year, lifeExp, group=country, col=continent)) +
  geom_line()


gapminder %>%
  ggplot(aes(year, lifeExp, group=country)) +
  geom_line() +
  facet_wrap(~ continent)


