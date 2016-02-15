# Prvo pokrenuti R_Scripts/modifying_datasets.R #

# import libraries
library(caTools)
library(randomForest)
library(ROCR)
library(rpart)
library(rpart.plot)

# Pomocu RNG generisemo seed
set.seed(10000)

# splitujemo dataset na 75:25
split = sample.split(dataFinal$pobedio, SplitRatio = 0.75)
train = subset(dataFinal, split == TRUE)
test = subset(dataFinal, split == FALSE)

# pravimo tree
stablo = rpart(pobedio ~ osvojenih_prvih_servisa + osvojenih_drugih_servisa +
	broj_asova + duple_servis_greske + sacuvanih_brejk_lopti_modified, 
		data = train, method = "class", minbucket = 100)

prp(stablo)

predvidjanjeCART = predict(stablo, newdata = test, type = "class")
MatKonf = table(test$pobedio, predvidjanjeCART)
print(MatKonf)

#Preciznost modela
Accuracy = (MatKonf[1] + MatKonf[4])/(MatKonf[1]+MatKonf[2]+MatKonf[3]+MatKonf[4])
print(Accuracy)

sensitivity = MatKonf[4]/(MatKonf[4]+MatKonf[2])
print(sensitivity) 

specificity = MatKonf[1]/(MatKonf[1]+MatKonf[3])
print(specificity) 

predvidjanjeROC = predict(stablo, newdata = test)

pred = prediction(predvidjanjeROC[,2], test$pobedio)
perf = performance(pred,"tpr","fpr")
plot(perf, colorize = TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(0.2,1.7))

as.numeric(performance(pred, "auc")@y.values)

train$pobedio = as.factor(train$pobedio)
test$pobedio = as.factor(test$pobedio)

sumaBlista = randomForest(pobedio ~ osvojenih_prvih_servisa +
 sacuvanih_brejk_lopti_modified + broj_asova + duple_servis_greske, data = train, 
	nodesize = 100, ntree = 1000)

predvidnjanjeSuma = predict(sumaBlista, newdata = test)
MatKonf = table(test$pobedio, predvidnjanjeSuma)
print(MatKonf)
Accuracy = (MatKonf[1] + MatKonf[4])/(MatKonf[1]+MatKonf[2]+MatKonf[3]+MatKonf[4])
print(Accuracy)
sensitivity = MatKonf[4]/(MatKonf[4]+MatKonf[2])
print(sensitivity) 

specificity = MatKonf[1]/(MatKonf[1]+MatKonf[3])
print(specificity) 
