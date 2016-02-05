## O projektu

Istraživanje predstavlja primenu logističke regresije na sportske rezultate, konkretno u tenisu. Podaci korišćeni u istraživanju su javno dostupni datasetovi u vidu .csv fajlova preuzeti sa sajta [Tennis Abstract](http://www.tennisabstract.com/ "Tennis Abstract").
Cilj istraživanja je pravljenje što realnijeg modela koji na osnovu statističkih podataka predviđa ishod pobednika teniskog meča. 

## Tok izrade projekta

Prilikom izrade projekta, pokriveni su sledeći koraci:

- Prikupljanje podataka
- Obrada podataka na odgovarajući način
- Određivanje nezavisnih varijabli
- Generisanje modela
- Testiranje modela i tumačenje rezultata
- Zaključak i analiza rezultata

### Prikupljanje podataka

Podaci su dostupni svima i prikupljeni su sa sajta [Tennis Abstract](http://www.tennisabstract.com/ "Tennis Abstract") čiji je autor [Jeff Sackmann](http://www.jeffsackmann.com/), sportski analitičar i statističar. U pitanu su .csv fajlovi koji sadrže statistiku mečeva sa svih _Masters_ i _Gren slem_ turnira od 1968. godine. Budući da se dinamika igre tenisa promenila kroz godine i da svaki originalni _dataset_ sadrži oko 3000 observacija, ovo istraživanje uključuje statistiku igrača iz mečeva odigranih 2014. i 2015. godine. Prvobitna ideja je bila da to bude trening set, a da test set bude 2016. godina. Međutim, premalo podataka postoji za ovu godinu, budući da je rad realizovan krajem januara i samo tri turnira su odigrana do tada.

### Obrada podataka na odgovarajući način

Originalni podaci nisu bili pogodni za analizu korišćenu u ovom istraživanju, pa su obrađeni na odgovarajući način. Prvobitna observacija je predstavljala jedan ceo teniski meč i sadržala je statistiku i pobednika i gubitnika meča. Stoga, od jednog reda u _datasetu_ su napravljena dva. Jedan sa statistikom pobednika, a drugi sa statistikom gubitnika. Takođe, ubačena je nova varijabla $pobednik, koja je uzimala vrednosti 0 ili 1. Kasnije je kreiran model na osnovu ove promenljive kao zavisne.
  Poznavanjem teniske igre, intuitivno je zaključeno da podaci neće biti konzistentni ako se sve tri podloge (trava, tvrda podloga i šljaka) uvrste u model. Ovo istraživanje je ograničeno isključivno na tvrdu podlogu, kao najbržu od sve tri. Najveći je procenat osvojenih poena na svoj servis na ovoj podlozi i najveći broj asova koji kasnije predstavljaju bitne varijable u modelu. Takođe, najviše turnira se igra na tvrdoj podlozi, i samim tim se dobija najveći _datset_. Svi relevantni podaci su bili numerički, sumirani na nivou celog meča. Najveći problem je bio napraviti od takvih podataka, one koji su pogodni za logističku regresiju. Takođe, _Gren slem_ turniri se igraju na 3 dobijena seta, dok se _Masters_ turniri igraju na 2 dobijena seta. Na taj način dobijamo nekonzistente podatke. Oni su dalje obrađeni na statistiku po setu, i to u procentima. Konačno, za ovako normalnizovan _dataset_ možemo da generišemo logistički model.  

### Određivanje nezavisnih varijabli

Nezavisne varijable su delimično određene intuitivno, a delimično korišćenjem matrice korelacije. Na taj način je izbegnut problem multikolinearnosti, prilikom kog nezavisne promenljive imaju visok stepen korelacije. 

Korelaciona matrica: 
![alt text](https://github.com/RastkoAnicic/tennis-inteligent-systems/blob/master/Pictures/korelaciona_samo_iz_modela.JPG "Korelaciona matrica")

Na osnovu ovih metoda, izabrane su sledeće promeljive:
- $broj\_asova
- $duple\_servis\_greske 
- $osvojenih\_prvih\_servisa 
- $osvojenih\_drugih\_servisa
- $sacuvanih_brejk_lopti_modified

------
### Generisanje modela

Na osnovu prethodnih koraka, generisemo model: 


<pre><code> LogistickiModel = glm(pobedio ~ osvojenih_prvih_servisa
	+ osvojenih_drugih_servisa + sacuvanih_br_lopti_modified + 
		broj_asova + duple_servis_greske , data = dataFinal, family=binomial)
</code></pre>


_Summary_ modela je prikazan na sledecoj slici:

![alt text](https://github.com/RastkoAnicic/tennis-inteligent-systems/blob/master/Pictures/logisticki_model_summary.jpg "Logisticki model")

------
### Testiranje modela i predstavljanje rezultata

Na osnovu modela predviđamo podatke:

<pre><code>
Predvidjanje = predict(LogistickiModel, type = "response", newdata = test)
	tabela = table(test$pobedio, Predvidjanje > 0.56)
</code></pre>

Dobijamo sledeću matricu konfuzije:

    | FALSE | TRUE
--- | --- | ---
0 | 768 | 178
1 | 351 | 595

Sa parametrima modela:

Parametar | Vrednost 
--- | --- 
Sensitivity | 0.6289641
Specificity | 0.8118393 
Total accuracy | 0.7204017
Total error | 0.2795983
AUC | 0.7932242

Receiver Operator Characteristic kriva
![alt text](https://github.com/RastkoAnicic/tennis-inteligent-systems/blob/master/Pictures/TP%20FP.png "ROC kriva")

## Zaključak i analiza rezultata

Korišćen _dataset_ je sadržao 5406 observacija, od kojih je 1892 predstavljalo test set, a 3514 je predstavljalo trening set.
Racio deljenja seta je iznosio 0.65 zbog većeg brojeg podataka koje smo imali na raspolaganju. Najzahtevniji deo rada je bila sama priprema podataka i odabir relevantnih nezavisnih promenljivih.

Rezultati su pokazali da model precizno određuje ishod pobednika u 72% slučajeva. Prikupljeni podaci su sadržali mečeve sa 2703 |pobednika i isto toliko gubitnika. Dakle, kada bismo tvrdili da su svi teniseri pobedili u meču, bili bismo u pravu u tačno 50% |slučajeva. U poređenju sa ovakvim pristupom, dobijeni model je bolji za 22 odsto.

**Treshold** vrednost je postavljena na 0.56. Na toj vrednosti se najviše smanjuje greška prilikom klasifikacije u ovom modelu. Da smo uzeli visoku _treshold_ vrednost (>0.9) klasifikovali bismo kao pobednike samo one igrače čija je verovatnoća pobede iznad 90% na osnovu modela. Da smo uzeli malu vrednost, klasifikovali bismo veliki broj pobednika. 

Parametri **sensitivity** i **specificity** nam pomažu da utvrdimo koliko smo dobro klasifikovali igrače. Sensitivity meri procenat koliko smo zapravo gubitnika klasifikovali kao gubitnike, dok specificity meri procenat pobednika klasifikovanih kao pobednike. 

**ROC kriva** nam pomaže pri odabiru _treshold_ vrednosti uz pomoć _sensitivity_ i _specificity_ parametara. Što je veća _treshold_  vrednost (bliža (0,0)), veća je i _specificity_, a niža _sensitivity_. Manja _treshold_ je bliža (1,1), veća _sensitivity_ a manja _specificity_. Sada treba odabrati šta nam više odgovara za model. 
