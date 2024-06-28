##Final Report R script
##248STG01 김다빈



###############################QUESTION 1###############################

## 1. load data
setwd("C:/Users/DaBin/Desktop/대학원/1학기/회귀분석론/Final Report")
load('ElkData.Rdata')
head(ElkData)
summary(ElkData)
attach(ElkData)


## 2. Plot and technical statistics

# correlation of  numerical covariates

cor(ElkData[,c('num.seen','elev','perc.forest','perc.open.water','perc.developed','obs.days')])


# plot with pairs optin in R
plot(ElkData)
par(mfrow = c(1,3))
plot(perc.developed, num.seen)
plot(perc.forest, num.seen)
plot(perc.open.water,num.seen)


# plot with perc.forest - perc.open.water
ggplot(data = ElkData, aes(x = perc.forest, y = perc.open.water)) + geom_point()



# mean of the number of elk by season
  library(dplyr)
  ElkData %>% 
    group_by(season) %>% 
    summarise(mean_number = mean(num.seen))


#Y분포 확인

library(ggplot2)
 ggplot(data = ElkData, aes(num.seen) ) + geom_bar()

## 3. GLM trial model


# check residual , multicollinearity, and outlier 
 
# infulential point는 없다고 판단 (혹은 339686, 376612)


##Fit 1
fit1 <- glm(num.seen~., family = 'poisson', data = ElkData)
summary(fit1)

# check residual , multicollinearity, and outlier 

# infulential point는 없다고 판단 
par(mfrow = c(1,4))
plot(fit1)
source('prp for glm.r')

library(car)
crPlots(fit1) 
outlierTest(fit1)
cd=cooks.distance(fit1)
plot(cd)

source('prp for glm.r')
prp(fit1, ElkData, names = 'elev')
# comparison method

# AIC
AIC(fit1)

#simulated
muhat <- predict(fit1, type = 'response')
ysim <- rpois(length(muhat), lambda = muhat)
fit.sim <- glm(num.seen~ season + elev + perc.open.water + perc.developed + 
                 obs.days, family = 'poisson', data = ElkData)
par(mfrow = c(2,4))
plot(fit1)
plot(fit.sim)

# MSPE
mean((num.seen - muhat)^2)



## Fit 2: AIC based 

fit.aic <- step(fit1)
formula(fit.aic)

fit2 <- glm(num.seen~elev + season + perc.open.water + perc.developed + obs.days, 
               family = 'poisson', data = ElkData)
summary(fit2)


AIC(fit2) #25009.29
muhat <- predict(fit2, type = 'response')
mean((num.seen - muhat)^2) #1.058201

## Fit3 : interaction term

fit3 <- glm(num.seen~season + elev + perc.open.water + perc.developed+  obs.days + I(elev* perc.forest)+ I(elev* perc.developed)  , family = 'poisson', data = ElkData)
par(mfrow = c(2,2))
plot(fit3)
AIC(fit3) #24940.94

# simulated y
muhat <- predict(fit3, type = 'response')
ysim <- rpois(length(muhat), lambda = muhat)
fit.sim <- glm(num.seen~ season + elev + perc.open.water + perc.developed + obs.days +  I(elev* perc.forest)+ I(elev* perc.developed), family = 'poisson', data = ElkData)

# compare plot 
par(mfrow = c(2,4))
plot(fit3)
plot(fit.sim)

mean((num.seen - muhat)^2) #1.050274
crPlots(fit3) 
outlierTest(fit3)
cd=cooks.distance(fit3)


##Fit 4 : LASSO

# load library glmnet
library(glmnet)

# split X and Y 
X <- ElkData[,-1]%>%data.matrix()
Y <- num.seen

# fitting
lambda.lasso=fit4$lambda.1se


cvmspe.lasso=min(fit4$cvm)
fit4 =cv.glmnet(x=X,y=as.numeric(Y),alpha=0,nfolds=10,nlambda=200, family = 'poisson')

# get lambda and best rr fit
lambda.rr=fit4$lambda.min
lambda.rr

# best estimate for lasso
betas.lasso=coef(fit4,s="lambda.1se")
betas.lasso


# simulated y
muhat <- predict(fit4,newx=X,s="lambda.min",type="response")

# MSPE for final model :1.059444
mean((num.seen-muhat)^2) 
 

###################QUESTION 2###################




## 1. 계절별로 데이터 인덱스 추출
index.P <- which(season == 'P')
index.SF <- which(season == 'SF')
index.W <- which(season == 'W')


## 2. predict

muhat <- predict(fit3, type = 'response' )
ysim <- rpois(length(muhat), lambda = muhat)

## 3. evaluation


mu.P <- muhat[index.P]
mu.SF <- muhat[index.SF]
mu.W <- muhat[index.W]

mean((num.seen[index.P]-mu.P)^2)
mean((num.seen[index.P]-mu.P)^2)
mean((num.seen[index.W]-mu.W)^2)

data.frame(P = mean((num.seen[index.P]-mu.P)^2), SF =mean((num.seen[index.SF]-mu.SF)^2), W =  mean((num.seen[index.W]-mu.W)^2), row.names = 'MSPE')
# P가 정확도 제일 떨어짐

y.P <- rpois(length(mu.P),lambda = mu.P)
y.SF <- rpois(length(mu.SF),lambda = mu.SF)
y.W <- rpois(length(mu.W),lambda = mu.W)

data.frame(P = mean(y.P),
           SF = mean(y.SF),
           W = mean(y.W), row.names = 'y')


#계절별 데이터 비교
summary(ElkData[index.P,])
summary(ElkData[index.SF,])
summary(ElkData[index.W,])



##################QUESTION3#################


site1 <- data.frame(season = 'W',elev = -0.954, perc.forest = 0, perc.open.water = 0,
                    perc.developed = 0,obs.days = 2)
site2 <- data.frame(season = 'W', elev = 0.209, perc.forest = 0.0222,
                    perc.open.water = 0.01, perc.developed = 0,obs.days = 2)

pred1 <- predict(fit3, newdata = site1, type = 'response',se = TRUE)
pred2 <- predict(fit3, newdata = site2, type = 'response',se = TRUE)

mu.hat1 <- pred1$fit
mu.hat2 <- pred2$fit
mu.hat <- c(mu.hat1, mu.hat2)

se <- c(pred1$se.fit, pred2$se.fit)

upper <- mu.hat + 1.96 * se
lower <- mu.hat - 1.96 * se
exp.upper <- exp(mu.hat + 1.96 * se)
exp.lower <- exp(mu.hat - 1.96 * se)


##for poisson regression, response function is $\mu = e^{eta}$

result <- data.frame(muhat = mu.hat, LOWER = lower, 
                     UPPER = upper,
                     exp.Lower = exp.lower,
                     exp.Upper = exp.upper,
                     row.names = c('site1','site2'))
  
result






