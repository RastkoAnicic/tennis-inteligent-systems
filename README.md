## O projektu

Istraživanje predstavlja primenu prediktivnih metoda na sportske rezultate, konkretno u tenisu. Podaci korišćeni u istraživanju su javno dostupni datasetovi u vidu .csv fajlova preuzeti sa sajta [Tennis Abstract](http://www.tennisabstract.com/ "Tennis Abstract").
Cilj istraživanja je pravljenje što realnijeg modela koji na osnovu statističkih podataka tenisera (procenat servisa, procenat brejk lopti...) predviđa da li će teniser pobediti ili ne. 

## Tok izrade projekta

Prilikom izrade projekta, pokriveni su sledeći koraci:

- Prikupljanje podataka
- Obrada podataka na odgovarajući način
- Određivanje nezavisnih varijabli
- Generisanje logističkog modela
- Testiranje modela i tumačenje rezultata
- Generisanje CART modela
- Testiranje modela i tumačenje rezultata
- Zaključak i analiza rezultata

### Prikupljanje podataka

Podaci su prikupljeni sa sajta [Tennis Abstract](http://www.tennisabstract.com/ "Tennis Abstract") čiji je autor [Jeff Sackmann](http://www.jeffsackmann.com/), sportski analitičar i statističar. U pitanјu su .csv fajlovi koji sadrže statistiku mečeva sa svih _Masters_ i _Gren slem_ turnira od 1968. godine. Budući da se dinamika igre tenisa promenila kroz godine i da svaki originalni _dataset_ sadrži oko 3000 observacija, ovo istraživanje uključuje statistiku igrača iz mečeva odigranih 2014. i 2015. godine. Prvobitna ideja je bila da to bude trening set, a da test set bude 2016. godina. Međutim, premalo podataka postoji za ovu godinu, budući da je rad realizovan krajem januara i samo tri turnira su odigrana do tada.

### Obrada podataka na odgovarajući način

Originalni podaci nisu bili pogodni za analizu korišćenu u ovom istraživanju, pa su obrađeni na odgovarajući način. Prvobitna observacija je predstavljala jedan ceo teniski meč i sadržala je statistiku i pobednika i gubitnika meča. Stoga, od jednog reda u _datasetu_ su napravljena dva. Jedan sa statistikom pobednika, a drugi sa statistikom gubitnika. Takođe, ubačena je nova varijabla $pobednik, koja je uzimala vrednosti 0 ili 1. Kasnije je kreiran model na osnovu ove promenljive kao zavisne.
  Poznavanjem teniske igre, intuitivno je zaključeno da podaci neće biti konzistentni ako se sve tri podloge (trava, tvrda podloga i šljaka) uvrste u model. Ovo istraživanje je ograničeno isključivno na tvrdu podlogu, kao najbržu od sve tri. Najveći je procenat osvojenih poena na svoj servis na ovoj podlozi i najveći broj asova koji kasnije predstavljaju bitne varijable u modelu. Takođe, najviše turnira se igra na tvrdoj podlozi, i samim tim se dobija najveći _datset_. Svi relevantni podaci su bili numerički, sumirani na nivou celog meča. Najveći problem je bio napraviti od takvih podataka, one koji su pogodni za logističku regresiju. Takođe, _Gren slem_ turniri se igraju na 3 dobijena seta, dok se _Masters_ turniri igraju na 2 dobijena seta. Na taj način dobijamo nekonzistente podatke. Oni su dalje obrađeni na statistiku po setu, i to u procentima. Dalje, mečevi koji sadrže gemove sa rezultatom 6-0 ili 0-6 su izbačeni iz modela jer ne predstavljaju realnu sliku teniske igre. To su mečevi koji se igraju u ranoj fazi turnira, prvom ili drugom kolu i ishod je transparentan već na osnovu imena tenisera. Tada je statistika pobednika izuzetno dobra, a statistika gubitnika izuzetno loša. Dalje, atribut koji se odnosi na broj sačuvanih brejk lopti je morao da bude modifikovan na sledeći način; Kada teniser ne sačuva ni jednu brejk loptu od, recimo, mogućih 3, tada će imati 0/3 sačuvanih brejk lopti, to jest $sacuvanih\_brejk\_lopti\_ = 0.00 i izgubio je 3 gema, što je loše. Takođe, kada teniser ne dospe u brejk situaciju, broj sačuvanih brejk lopti je opet $sacuvanih\_brejk\_lopti\_ = 0.00, ali u ovom slučaju nije izgubio ni jedan servis gem, što je dobro. Takođe, kada sačuva sve 3 potencijalne brejk lopte, broj je 3/3, dakle $sacuvanih\_brejk\_lopti\_ = 1.00 i nije izgubio ni jedan servis gem, što je takođe dobro. Zbog toga je bitno modifikovati ovaj parametar. Konačno, za ovako normalnizovan _dataset_ možemo da generišemo logistički model.  

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
### Generisanje logističkog modela

Na osnovu prethodnih koraka, generisemo model: 


<pre><code> LogistickiModel = glm(pobedio ~ osvojenih_prvih_servisa
	+ osvojenih_drugih_servisa + sacuvanih_br_lopti_modified + 
		broj_asova + duple_servis_greske , data = dataFinal, family=binomial)
</code></pre>


_Summary_ modela je prikazan na sledecoj slici:

![alt text](https://github.com/RastkoAnicic/tennis-inteligent-systems/blob/master/Pictures/novi_summary.PNG "Logisticki model")

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
0 | 545 | 131
1 | 225 | 451

Sa parametrima modela:

Parametar | Vrednost 
--- | --- 
Sensitivity | 0.6671598
Specificity | 0.806213 
Total accuracy | 0.7366864
Total error | 0.2633136
AUC | 0.8125711

Receiver Operator Characteristic kriva
![alt text](https://github.com/RastkoAnicic/tennis-inteligent-systems/blob/master/Pictures/TP%20FP.png "ROC kriva")

------
### Generisanje CART modela

Stablo smo generisali na sledeći način: 


<pre><code> stablo = rpart(pobedio ~ osvojenih_prvih_servisa + 
	broj_asova + duple_servis_greske + sacuvanih_brejk_lopti_modified, 
		data = train, method = "class", minbucket = 100)
</code></pre>

Za razliku od logističkog modela, u CART modelu se javljaju dva nova argumenta. Prvi je _method_ kojim definišemo tip stabla koji nam je potreban. U ovom slučaju pravimo **classification tree**. Drugi argument je _minbucket_ koji ograničava naše stablo. On predstavlja minimalan broj observacija u svakom podsetu. 

------
### Testiranje modela i predstavljanje rezultata

Izgled stabla:

![alt text](https://github.com/RastkoAnicic/tennis-inteligent-systems/blob/master/Pictures/Drvo.PNG "Classification Tree")

Generisano stablo nam govori da kada je procenat modifikovanog parametra sačuvanih_brejk_lopti veći od 79%, igrač je klasifikovan kao pobednik. Kada je procenat manji od 79%, dolazi do grananja stabla. Tada posmatramo parametar procenat osvojenih prvih servisa. Ako je on manji od 0.4, igrač je klasifikovan kao gubitnik. Ako je veći, dolazi do ponovnog grananja gde se opet posmatra parametar osvojenih prvih servisa. Konačno, ako je procenat ispod 46%, teniser je klasifikovan kao gubitnik, u suprotnom se posmatra kao pobednik.
Tačnost modela možemo da utvrdimo koristeći matricu konfuzije.

Matrica konfuzije:

    | FALSE | TRUE
--- | --- | ---
0 | 479 | 197
1 | 166 | 510

Sa parametrima modela:

Parametar | Vrednost 
--- | --- 
Total accuracy | 0.7315089
Total error | 0.2684911
AUC | 0.7831527

Receiver Operator Characteristic kriva
![alt text](https://github.com/RastkoAnicic/tennis-inteligent-systems/blob/master/Pictures/TP FP trees.PNG "ROC kriva")


Radi poređenja, urađena je i Random Forest analiza koja umesto jednog stabla, generiše više stabala uzimajući svaki put drugačiju kombinaciju observacija. Takođe, Random Forest analiza je pouzdanija prilikom pojave _overfitting_ problema.

<pre><code>
randomForest(pobedio ~ osvojenih_prvih_servisa +
 sacuvanih_brejk_lopti_modified + broj_asova + duple_servis_greske, data = train, 
	nodesize = 100, ntree = 200)
</code></pre>

U ovom modelu _nodesize_ parametar predstavlja isto što i _minbucket_ u CART analizi. Manja nodesize vrednost pravi veća stabla. Sledeći parametar _ntree_ postavlja broj stabala koji se generiše. RandomForest funkcija nema argument _method_ za razliku od rpart funkcije. Zbog toga, kada primenjujemo ovu funkciju za probleme klasifikacije, zavisna promenljiva mora da bude tipa Factor.

Na osnovu Random Forest metode dobijamo sledeće parametre:

    | FALSE | TRUE
--- | --- | ---
0 | 506 | 170
1 | 187 | 489

Parametar | Vrednost 
--- | --- 
Total accuracy | 0.7359467
Total error | 0.2640533

------
## Zaključak i analiza rezultata

Korišćen _dataset_ je sadržao 5406 observacija, od kojih je 1892 predstavljalo test set, a 3514 je predstavljalo trening set.
Racio deljenja seta je iznosio 0.75 za trening set. Najzahtevniji deo rada je bila sama priprema podataka i odabir relevantnih nezavisnih promenljivih.

Na osnovu matrice korelacije, utvrđene su nezavisne promenljive. Slika na kojoj se vidi _summary_ logističkog modela nam govori da su sve promeljive u našem modelu relevantne (svaka ima bar dve zvezdice).

**Treshold** vrednost je postavljena na 0.56. Izabrana je uz pomoć vrednosti ROC krive. Na toj vrednosti se najviše smanjuje greška prilikom klasifikacije u ovom modelu. Da smo uzeli visoku _treshold_ vrednost (>0.9) klasifikovali bismo kao pobednike samo one igrače čija je verovatnoća pobede iznad 90% na osnovu modela. Da smo uzeli malu vrednost, klasifikovali bismo veliki broj pobednika. 

Parametri **sensitivity** i **specificity** nam pomažu da utvrdimo koliko smo dobro klasifikovali igrače. Sensitivity meri procenat koliko smo zapravo gubitnika klasifikovali kao gubitnike, dok specificity meri procenat pobednika klasifikovanih kao pobednike. 

**ROC kriva** nam pomaže pri odabiru _treshold_ vrednosti uz pomoć _sensitivity_ i _specificity_ parametara. Što je veća _treshold_  vrednost (bliža (0,0)), veća je i _specificity_, a niža _sensitivity_. Manja _treshold_ je bliža (1,1), veća _sensitivity_ a manja _specificity_. Sada treba odabrati šta nam više odgovara za model. 

Rezultati su pokazali da logistička regresija precizno određuje ishod pobednika u 73.7% slučajeva. Prikupljeni podaci su sadržali mečeve sa 2703 pobednika i isto toliko gubitnika. Dakle, kada bismo tvrdili da su svi teniseri pobedili u meču, bili bismo u pravu u tačno 50% slučajeva. U poređenju sa ovakvim pristupom, dobijeni model je bolji za 23 odsto. On je ujedno i za nijansu bolji od CART i Random Forest modela, mada sva tri pružaju podjednako dobre rezultate.
