data2014 = read.csv("Datasets/2014_final.csv")
data2015 = read.csv("Datasets/2015_final.csv")
dataTotal= rbind(data2014,data2015)


dataFinal = subset(dataTotal, podloga == "Hard")


dataFinal = dataFinal[!grepl("0-6", dataFinal$rezultat),]
dataFinal = dataFinal[!grepl("6-0", dataFinal$rezultat),]

pom = dataFinal$sacuvanih_brejk_lopti
dataFinal["sacuvanih_brejk_lopti_modified"] <- pom


#Modifikovan parametar sacuvanih_brejk_lopti 
#da bi to onda imalo smisla..


dataFinal$sacuvanih_brejk_lopti_modified[dataFinal$sacuvanih_brejk_lopti_modified==0] <- 1


library(caTools)

#Pomocu RNG generisemo seed
set.seed(10000)

#splitujemo dataset na 65:35
split = sample.split(dataFinal$pobedio, SplitRatio = 0.65)

train = subset(dataFinal, split == TRUE)

test = subset(dataFinal, split == FALSE)

#sve numericke nezavisne promenljive
nezavisne = c("broj_asova","duple_servis_greske","broj_servis_poena",
	"ubacenih_prvih_servisa","osvojenih_prvih_servisa","osvojenih_drugih_servisa",
		"broj_servis_gemova","sacuvanih_brejk_lopti","suocenih_brejk_lopti",
			"pobedio","sacuvanih_brejk_lopti_modified")
test.set=dataFinal[nezavisne]
cor(test.set)

#nezavisne numericke promenljive koje smo uvrstili u model
nezavisne1 = c("broj_asova","duple_servis_greske","osvojenih_prvih_servisa",
			"osvojenih_drugih_servisa","pobedio","sacuvanih_brejk_lopti_modified")
test.set1=dataFinal[nezavisne1]
cor(test.set1)

#pravimo model
LogistickiModel = glm(pobedio ~ osvojenih_prvih_servisa
	+ osvojenih_drugih_servisa + sacuvanih_br_lopti_modified + 
		broj_asova + duple_servis_greske , data = dataFinal, family=binomial)
summary(LogistickiModel)

#testiramo model na novim podacima
Predvidjanje = predict(LogistickiModel, type = "response", newdata = test)
tabela = table(test$pobedio, Predvidjanje > 0.56)
tabela

#izracunavamo parametre modela
sensitivity = tabela[2,"TRUE"]/(tabela[2,"FALSE"]+tabela[2,"TRUE"])
sensitivity

specificity = tabela[1,"FALSE"]/(tabela[1,"FALSE"]+tabela[1,"TRUE"])
specificity

br.el = tabela[1,"FALSE"]+tabela[2,"FALSE"]+tabela[1,"TRUE"]+tabela[2,"TRUE"]
ukupna_greska = (tabela[2,"FALSE"] + tabela[1,"TRUE"] )/br.el
ukupna_greska


library(ROCR)
ROCRpred = prediction(Predvidjanje ,test$pobedio)

ROCRperf = performance(ROCRpred, "tpr","fpr")

plot(ROCRperf, colorize = TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(0.2,1.7))

as.numeric(performance(ROCRpred, "auc")@y.values)