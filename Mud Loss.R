library (data.table)
library (car)
library(caTools)
library (corrplot)
library(dplyr)

setwd("your working directory")
dt <- fread("your dataset")
attach (dt)

dim(dt)
summary (dt)
# There are 4 missing values: 1 in FAN600, 1 in FAN300, 1 in MIN10GEL, and 1 in MUDLOSSU.

sum(is.na(dt))
which(is.na(dt$FAN600))
which(is.na(dt$FAN300))
which(is.na(dt$MIN10GEL))
which(is.na(dt$MUDLOSSU))
# Missing values are present in row 3 for FAN600, FAN300, and MIN10GEL, and in row 6 for MUDLOSSU.

dt[c(3,6)]
as.numeric(which.max(table(MUDLOSSU)))
sum(MUDLOSSU==0, na.rm=T)

par (mfrow = c(3,3))
plot (MUDLOSSU~Northing)
plot (MUDLOSSU~Easting)
plot (MUDLOSSU~`Depth (ft)`)
plot (MUDLOSSU~factor(Formation)) 
# Formation is a categorical variable 
plot (MUDLOSSU~`Pore pressure`)
plot (MUDLOSSU~`Fracture pressure`)
plot (MUDLOSSU~`Mud pressure (psi)`)
plot (MUDLOSSU~`Hole size (in)`)
plot (MUDLOSSU~METERAGE)

plot (MUDLOSSU~DRLTIME)
plot (MUDLOSSU~WOB)
plot (MUDLOSSU~`Pump flow rate`)
plot (MUDLOSSU~`Pump pressure`)
plot (MUDLOSSU~MFVIS)
plot (MUDLOSSU~RETSOLID) 
plot (MUDLOSSU~FAN600)
plot (MUDLOSSU~FAN300)
plot (MUDLOSSU~MIN10GEL)
plot (MUDLOSSU~RPM)

par (mfrow = c(1,1))
corrplot(cor(dt,use = "pairwise.complete.obs"), type = "upper")
round(cor(dt, use = "pairwise.complete.obs"),2)
# northing & easting are highly correlated 
# pore pressure are highly correlated with facture pressure and mud pressure 
# hole size are highly correlated with pump flow rate

cor(Northing,Easting)
# strong negative correlation
n_distinct(Northing, Easting) == n_distinct(Northing) 
# the number of distinct combinations is same as the unique number of 'Northing'
# For each specific 'Northing' value, there is always a corresponding 'Easting' value that is constant

cor(MUDLOSSU, Northing, use = "pairwise.complete.obs")

round(cor(MUDLOSSU, dt, use = "pairwise.complete.obs"),2)

# change the variable to categorical variables
dt$Formation <- factor(dt$Formation)
summary (dt$Formation)

dt$"Hole size (in)"<- factor (dt$"Hole size (in)")
summary (dt$"Hole size (in)")
plot(MUDLOSSU~factor(`Hole size (in)`))
# boxplot shows many outlier and noticeable difference in spread, would be a good categorical variable 

dt$Northing <- factor(dt$Northing)
dt$Easting <- factor(dt$Easting)

#------------------------------------Linear Regression------------------------------------------------------------

lm1 <- lm (MUDLOSSU~.-Northing-Easting, dt)
summary (lm1)
vif (lm1)
# `Depth (ft)`,`Pore pressure`,`Fracture pressure`,`Mud pressure (psi)`,DRLTIME, WOB,`Pump pressure`,MIN10GEL, RPM are statistically not significant (p>0.05)
# but before removing the variable, check the multicollinearity to ensure they represent the correct data 

#remove variable with highest gvif when its gvif > 2 
# remove `Fracture pressure`
lm2 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`, dt)
summary (lm2)
vif (lm2)

# remove 'FAN300'
lm3 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300, dt)
summary (lm3)
vif (lm3)

#remove `Pore pressure` 
lm4 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300 - `Pore pressure`, dt)
summary (lm4)
vif (lm4)

#remove `Mud pressure (psi)`
lm5 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300 - `Pore pressure` - `Mud pressure (psi)`, dt)
summary (lm5)
vif (lm5)

#remove `Pump flow rate`
lm6 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300 - `Pore pressure` - `Mud pressure (psi)` - `Pump flow rate`, dt)
summary (lm6)
vif (lm6)

#remove FAN600
lm7 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300 - `Pore pressure` - `Mud pressure (psi)` - `Pump flow rate` - FAN600, dt)
summary (lm7)
vif (lm7)

#remove RETSOLID
lm8 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300 - `Pore pressure` - `Mud pressure (psi)` - `Pump flow rate` - FAN600 - RETSOLID, dt)
summary (lm8)
vif (lm8)

#remove `Depth (ft)`  
lm9 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300 - `Pore pressure` - `Mud pressure (psi)` - `Pump flow rate` - FAN600 - RETSOLID - `Depth (ft)`, dt)
summary (lm9)
vif (lm9)
## all variable gvif<2

#remove insignificant variable which p>0.5
# remove DRLTIME, `Pump pressure`, `Hole size (in)`
lm10 <- lm (MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300 - `Pore pressure` - `Mud pressure (psi)` - `Pump flow rate` - FAN600 - RETSOLID - `Depth (ft)` -DRLTIME - `Pump pressure` - `Hole size (in)`, dt)
summary (lm10)
vif (lm10)

par(mfrow = c(2,2))  # Plot 4 charts in one plot - 2 by 2.
plot(lm10)  # Plot model 2 diagnostics
# all plot are acceptable 
par(mfrow = c(1,1))  # Reset plot options to 1 chart in one plot.

# Train-Test Split
set.seed(2000)

train <- sample.split(Y = dt$MUDLOSSU, SplitRatio = 0.7)
trainset <- subset(dt, train == T)
testset <- subset(dt, train == F)

trainset1 <- trainset[complete.cases(trainset), ]
testset1 <- testset[complete.cases(testset), ]

summary(trainset1$MUDLOSSU)
summary(testset1$MUDLOSSU)

m1 <- lm(MUDLOSSU~.-Northing-Easting-`Fracture pressure`- FAN300 - `Pore pressure` - `Mud pressure (psi)` - `Pump flow rate` - FAN600 - RETSOLID - `Depth (ft)` -DRLTIME - `Pump pressure` - `Hole size (in)`, trainset1)
summary(m1)
residuals(m1)

RMSE.m1.train <- sqrt(mean(residuals(m1)^2))

# Apply model from trainset to predict on testset.
predict.m1.test <- predict(m1, newdata = testset1)  ##newdata 
testset.error <- testset1$MUDLOSSU - predict.m1.test #actual - predicted 
RMSE.m1.test <- sqrt(mean(testset.error^2))

RMSE.m1.train 
RMSE.m1.test 

#--------------------------------------------CART-------------------------------------------------------
library(rpart)
library(rpart.plot)

set.seed(2000)

# since Easting & Northing are represent the same information, remove Easting 
cart1 <- rpart(MUDLOSSU ~. -Easting , data = trainset, method = 'anova', control = rpart.control(minsplit =20 , cp = 0))
printcp(cart1)
plotcp(cart1)
#optimal tree #7

cp1<-sqrt (2.2469e-02*2.4017e-02)

cart2 <- prune (cart1, cp = cp1)
printcp(cart2, digits =3)

# root node error = 26834
# MSE of trainset = 0.457*26834 = 12263
# RMSE = sqrt(12263) = 110.74
RMSE.cart2.train = sqrt (0.457*26834)

print (cart2)
rpart.plot(cart2, nn = T, main = "Optimal Tree")

cart2$variable.importance

# apply optimal tree to predict
cart.predict <- predict(cart2, newdata = testset)
cart.testset.error <- testset$MUDLOSSU - cart.predict # actual - predicted 
# Exclude rows with missing values from the error vector
cart.testset.error <- cart.testset.error[!is.na(testset$MUDLOSSU)]
# Calculate RMSE for non-missing values
RMSE.cart2.test <- sqrt(mean(cart.testset.error^2))

RMSE.cart2.train
RMSE.cart2.test


