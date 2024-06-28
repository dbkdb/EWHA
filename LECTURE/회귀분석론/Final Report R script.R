##Final Report R script
##248STG01 김다빈

1. plot 
- paired plot 

2. trial model
- check residual, multicollinearity and outlier
-> influential point remove
- find polynomial term


3. fit model

- Residual analysis for final model
- Comparison of residual plot between final model and simulated model.extract()

4. compare models

- AIC
- mixed 
- LASSO


###################QUESTION 1###################


load('ElkData.Rdata')
head(ElkData)
summary(ElkData)
attach(ElkData)


# correlation of  numerical covariates

-> 뚜렷한 상관관계는 나타나지 않음

coln <- c('num.seen','elev','perc.fores','perc.open.water','perc.developed','obs.days')
cor(ElkData[,c('num.seen','elev','perc.forest','perc.open.water','perc.developed','obs.days')])


plot(ElkData)

                                                                                         
# mean of the number of elk by season

ElkData %>% 
  group_by(season) %>% 
  summarise(mean_number = mean(num.seen))

#developed

plot(num.seen, perc.developed)


#Y분포 확인
->y값이 대부분 0,1인 right skewed 
   
ggplot(data = ElkData, aes(num.seen) ) + geom_bar()


ggplot(data = ElkData , aes(num.seen,elev)) + geom_point()






















