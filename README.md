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




### Generisanje modela



### Testiranje modela i tumačenje rezultata



## License

A short snippet describing the license (MIT, Apache, etc.)
