###############################
# Kod je jako ruzan, ali radi #
###############################

library(xlsx)
library(plyr)

nulti = read.csv("Datasets/atp_matches_2014.csv")
nulti1 = read.csv("Datasets/atp_matches_2015.csv")
prvi = rbind(nulti, nulti1)

pobVar = c("surface","score","w_ace",
	"w_df","w_svpt","w_1stIn","w_1stWon",
		"w_2ndWon","w_SvGms","w_bpSaved",
			"w_bpFaced","round","best_of")

pobednik <- prvi[pobVar]
pobedio <- rep.int(1, nrow(pobednik))
pobednik$pobedio <- pobedio

gubVar = c("surface","score","l_ace",
	"l_df","l_svpt","l_1stIn","l_1stWon",
		"l_2ndWon","l_SvGms","l_bpSaved",
			"l_bpFaced","round","best_of")

gubitnik <- prvi[gubVar]
pobedio <- rep.int(0, nrow(pobednik))
gubitnik$pobedio <- pobedio

gubitnik <- rename(gubitnik, c("surface"="podloga","score"="rezultat","l_ace"="broj_asova",
	"l_df"="duple_servis_greske","l_svpt"="broj_servis_poena","l_1stIn"="ubacenih_prvih_servisa",
		"l_1stWon"="osvojenih_prvih_servisa","l_2ndWon"="osvojenih_drugih_servisa","l_SvGms"="broj_servis_gemova",
			"l_bpSaved"="sacuvanih_brejk_lopti","l_bpFaced"="suocenih_brejk_lopti","round"="nivo_takmicenja"))

pobednik <- rename(pobednik, c("surface"="podloga","score"="rezultat","w_ace"="broj_asova",
	"w_df"="duple_servis_greske","w_svpt"="broj_servis_poena","w_1stIn"="ubacenih_prvih_servisa",
		"w_1stWon"="osvojenih_prvih_servisa","w_2ndWon"="osvojenih_drugih_servisa","w_SvGms"="broj_servis_gemova",
			"w_bpSaved"="sacuvanih_brejk_lopti","w_bpFaced"="suocenih_brejk_lopti","round"="nivo_takmicenja"))

merged <- rbind(pobednik,gubitnik)


merged <- na.omit(merged)

br_setova <- 1:nrow(merged)
niz_rezultata <- as.character(merged$rezultat)

for(i in 1:nrow(merged))
{
 br_setova[i] = length(gregexpr(" ", niz_rezultata[i])[[1]]) + 1

}

merged$br_setova <- br_setova

dataFinal = subset(merged, podloga == "Hard")
dataFinal = dataFinal[complete.cases(dataFinal),]

dataFinal = dataFinal[!grepl("0-6", dataFinal$rezultat),]
dataFinal = dataFinal[!grepl("6-0", dataFinal$rezultat),]
dataFinal = dataFinal[!grepl("RET", dataFinal$rezultat),]
dataFinal = dataFinal[!grepl("W/O", dataFinal$rezultat),]


for(i in 3:11)
{
 dataFinal[i] = dataFinal[i]/dataFinal$br_setova
}

dataFinal$duple_servis_greske = dataFinal$duple_servis_greske/dataFinal$broj_servis_poena
dataFinal$broj_asova = dataFinal$broj_asova/dataFinal$broj_servis_poena
dataFinal$ubacenih_prvih_servisa = dataFinal$ubacenih_prvih_servisa/dataFinal$broj_servis_poena
dataFinal$osvojenih_prvih_servisa = dataFinal$osvojenih_prvih_servisa/dataFinal$broj_servis_poena
dataFinal$osvojenih_drugih_servisa = dataFinal$osvojenih_drugih_servisa/dataFinal$broj_servis_poena
dataFinal$sacuvanih_brejk_lopti = dataFinal$sacuvanih_brejk_lopti/dataFinal$suocenih_brejk_lopti

dataFinal$br_setova <- NULL

dataFinal$sacuvanih_brejk_lopti[is.na(dataFinal$sacuvanih_brejk_lopti)] <- 0

dataFinal$sacuvanih_brejk_lopti_modified <- dataFinal$sacuvanih_brejk_lopti
dataFinal$sacuvanih_brejk_lopti_modified[dataFinal$sacuvanih_brejk_lopti_modified==0] <- 1
dataFinal[is.na(dataFinal)] <- 0
str(dataFinal)

