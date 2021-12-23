# FormalneMetode-Tesiranje komponente/biblioteke

Projekt u skolpu predmeta Formalne metode, FIT 2021/22



# Kratki opis projekta za koji su rađeni testovi

**InfosysDokumentacija** predstavlja modul/koponentu/bibilioteku koju će koristiti razvojni programeri unutar Rad Studio IDE-a radi lakše integracije dokumentacije u aplikacijama. Kako bi se osigurao neometan rad komponente napravljeno je jedinično i integracijsko testiranje nad komponentom.

#### Shema rada komponente.

 ![image](https://user-images.githubusercontent.com/3055368/147236025-99fc26b5-b079-4cf8-9542-3e35dee4f594.png)

## Korišteni framework za testiranje

Za kreiranje testova su korišteni "standardni" testovi unutar Rad Studio IDE-a:

- [DUnitx](https://github.com/VSoftTechnologies/DUnitX)
- [DelphiMocks](https://github.com/VSoftTechnologies/Delphi-Mocks)
- [Discover](https://sourceforge.net/projects/discoverd/files/)


# Opis urađenih testova

Unutar ovog projekta je urađeno jedinično testiranje (Unit Test) i integracijsko testiranje (Integration Test).

## Jedinični testovi - Unit test

### DaLiJeInicijalizacijaUredu()

Pošto se radi o vizualnoj komponenti od velikog je značaja da se inicijalizacija komponente (prevlačenje komponente iz toolbar-a na formu unutar IDE-a) izvršava onako kako je zamišljeno Class Constructor-om. Upravo taj kod je testiran dole navedenim testom.

Napomena:
Class Constructor predstavlja poseban vid konstruktora i različit je od "običnog" Constructor-a kojim se inicijalizira instanca nekog objekta.
Class Constructor se poziva samo jednom kroz cijeli životni vijek objekta.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.DaLiJeInicijalizacijaUredu;
begin
  Assert.IsFalse(TestnaDokumentacija.FPrikaziMetaPodatke);
  Assert.IsTrue(TestnaDokumentacija.FUkloniLinkoveSaSlika);
  Assert.IsFalse(TestnaDokumentacija.FFiksirajSifirnuSadrzaja);
  Assert.IsNotNull(TestnaDokumentacija.FHttp);
  Assert.IsNotNull(TestnaDokumentacija.FSSLIOHandlerSocketOpenSSL);
  Assert.IsNotNull(TestnaDokumentacija.FDohvaceneStranice);
  Assert.IsNotNull(TestnaDokumentacija.FDohvaceneStraniceNovosti);
  Assert.IsNotNull(TestnaDokumentacija.FDohvaceneStraniceUputa);
  Assert.IsNotEmpty(TestnaDokumentacija.FLokalnaIP);
  Assert.IsNotEmpty(TestnaDokumentacija.FExternaIP);
  Assert.IsNotEmpty(TestnaDokumentacija.FWindowsUser);
end;
```

### Postavljen_UkloniLinkoveSaSlika()

Daljne testiranje se vrši nad property-ima instance objekta. Jedan od tih property-ja je isUkloniLinkoveSaSlika.
Testiranje ispravnog inicijalnog postavljanja se radi testom koji sljedi:

```pascal
[Test]
procedure TInfosysDokumentacijaTest.Postavljen_UkloniLinkoveSaSlika;
begin
     var rezultat := TestnaDokumentacija.isUkloniLinkoveSaSlika;
     Assert.AreEqual(rezultat,True);
end;
```

### Postavljen_AppId()

Kao i u prethodnom testu, radi se testiranje ispravnog postavljanja inicijalne vrijednosti property-ja AppId

```pascal
[Test]
procedure TInfosysDokumentacijaTest.Postavljen_AppId;
begin
     var daLiJePostavljenAppId:=TestnaDokumentacija.isAppIdSet;
     Assert.AreEqual(daLiJePostavljenAppId,true);
end;
```

### Postavljen_FiksirajDuzinuSadrzaja()

Kao i u prethodnom testu, radi se testiranje ispravnog postavljanja inicijalne vrijednosti property-ja FiksirajDuzinuSadrzaja

```pascal
[Test]
procedure TInfosysDokumentacijaTest.Postavljen_FiksirajDuzinuSadrzaja;
begin
     var daLiJePostavljenFiksirajDuzinuSadrzaja:=TestnaDokumentacija.isFiksirajSirinuSadrzaja;
     Assert.AreEqual(daLiJePostavljenFiksirajDuzinuSadrzaja,false);
end;
```

### Postavljen_PrikaziMetaPodatke()

Kao i u prethodnom testu, radi se testiranje ispravnog postavljanja inicijalne vrijednosti property-ja PrikaziMetaPodatke

```pascal
[Test]
procedure TInfosysDokumentacijaTest.Postavljen_PrikaziMetaPodatke;
begin
     var rezultat:=TestnaDokumentacija.isPrikaziMetaPodatke;
     Assert.AreEqual(rezultat,false);
end;
```

### Inicijalizacija_IndyHttp()

IndyHttp je pomoćna, eksterna, komponenta koja se koristi za komunikaciju između dva backend-a, InfosysBackend i BookstackBackend. Kako bi testirali ispravnost inicijalizacije koristimo sljedeći kod:

```pascal
[Test]
procedure TInfosysDokumentacijaTest.Inicijalizacija_IndyHttp();
begin
   TestnaDokumentacija.InitIndyHTTP(TipTIndyHttp.Infosys);
   var InfosysMock:=TestnaDokumentacija.FHttp;
   TestnaDokumentacija.InitIndyHTTP(TipTIndyHttp.Bookstack);
   var BookstackMock:=TestnaDokumentacija.FHttp;
   Assert.AreNotEqual(InfosysMock,BookstackMock);
   FreeAndNil(InfosysMock);
   FreeAndNil(BookstackMock);
end;
```

Ovdje radimo usporedbu dva objekta koja smo dobili kao rezultat korištenja inicijalizacijske funkcije InitIndyHttp kojoj prosljeđujemo parametar TipTindyHttp.Infosys ili TipTindyHttp.Bookstack. Na kraju radimo poređenje dva objekta da provjerimo da nisu isti. 

### StreemToString()

Ovaj test se radi kako bi osigurao da se ne može desiti greška u slučaju da je prosljeđeni objekat stream-a null. U takvim slučajevima trebamo kao rezultat dobiti prazan string.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.StreemToString;
begin
     var tempStream:=TStream.Create;
     tempStream:=nil;
     var rez := TestnaDokumentacija.StreamToString(tempStream);
     if rez='' then
     Assert.Pass('Stream je nil!');
end;
```

### DodajClankeUObjekat()

Ovaj test se radi kako bi se ustanovilo da li property FDohvaceneStranice ispravno funkcioniše. Naime, ovaj property je tipa TDohvaceniClanci, te nam je potreban za rad komponente. Unutar ovog testa se radi simulacija dodavanja članaka u propery FDohvaceneStranice te se radi usporedba da li je broj dodanih stranica stvarno jednak onom broju koji smo prethodno dodali. Nakon toga se radi provjera da li je, nakon brisanja stranica iz property-ja, stvarno došlo do izmjene broja elemenata u property-ju.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.DodajClankeUObjekat;
begin
     TestnaDokumentacija.FDohvaceneStranice.Add(TDohvaceniClanci.Create('1','Testni članak','testni-clanak','testna-knjiga'));
     TestnaDokumentacija.FDohvaceneStranice.Add(TDohvaceniClanci.Create('2','Testni članak','testni-clanak','testna-knjiga'));
     TestnaDokumentacija.FDohvaceneStranice.Add(TDohvaceniClanci.Create('3','Testni članak','testni-clanak','testna-knjiga'));
     TestnaDokumentacija.FDohvaceneStranice.Add(TDohvaceniClanci.Create('4','Testni članak','testni-clanak','testna-knjiga'));
     TestnaDokumentacija.FDohvaceneStranice.Add(TDohvaceniClanci.Create('5','Testni članak','testni-clanak','testna-knjiga'));
     Assert.AreEqual(TestnaDokumentacija.FDohvaceneStranice.Count,5);
     TestnaDokumentacija.FDohvaceneStranice.Clear;
     Assert.AreEqual(TestnaDokumentacija.FDohvaceneStranice.Count,0);
end;
```

## Integracijski testovi (Integration Test)

Pošto se radi o komponenti koja je namijenjena za korištenje unutar drugih modula/komponenti, u sklopu ovog projekta je veća težina stavljena na integracijsko testiranje nego što je na jedinično. Prema tome, urađeni su sljedeći testovi.

### OtvaranjeClanakaFormeKrozGridKontrolu_TFormSTuzbeOstale()

Test provjerava da li se ispravno pokreće otvaranje nekog članka kroz grid kontrolu neke forme koja će koristiti ovu komponentu.

- U tu svrhu je kreirana Mock klasa forme TFormTuzbeOstale.
- Nakon toga, pronalazimo komponentu *preglednika* koju provjeravamo Assert-om da li je null.
- Ukoliko nije null, znači da je poziv prema eksternim resursima prošlo uspješno.
- Zatim, radimo pronalaženje komponente gridView-a koju također, Assert-om, provjeravamo da nije null.
- Ako ova komponenta nije null, znači da je preglednik uspješno prošao inicijalizaciju i da je gridView-u uspješno predan sadržaj.
- Nakon toga, sa Assert.WillNotRaise simuliramo lijevi klik na gridView kontrolu te provjeravamo da li je bačena greška.
- Ukoliko greška nije bačena, znači da je uspješno testirano otvaranje sadržaja preuzete dokumentacije.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.OtvaranjeClanakaFormeKrozGridKontrolu_TFormSTuzbeOstale;
begin
   var  mock:=  TFormTuzbeOstale.CreateNew(self,1);
   TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Sve);
   var preglednik := (TestnaDokumentacija.FindComponent('FormPreglednikUputaNovostiGrid')) as TForm;
   Assert.IsNotNull(preglednik);
   var gridView := preglednik.FindComponent('GridTableView') as TcxGridTableView;
   Assert.IsNotNull(gridView);
   var grid :=preglednik.FindComponent('Grid') as tcxGrid;
   Assert.IsNotNull(grid);
   Assert.WillNotRaise(procedure begin SendMessage(grid.FocusedView.Site.Handle, WM_LBUTTONDBLCLK, 0, 0) end);
end;
```

### DohvatiStranicuDokumentacijePoId(aId:integer)

Ovim testom provjeravamo proceduru dohvata sadržaja dokumentacije prema id-u dokumenta.
U tu svrhu smo generirali dva TestCase-a kojim provjeravamo da li će dohvat dokumentacija baciti bilo koju grešku. To radimo pomoću Assert.WillNotRaiseAny kojoj proslijeđujemo proceduru sa parametrima iz TestCase-a.
U okviru ovog testa su korišteni TestCase-ovi gdje je id postavljen na 1 u prvom TestCase-u, dok je u drugom postavljen na -1000

```pascal
[Test]
[TestCase('Dohvat stranice sa id=1','1')]
[TestCase('Dohvat stranice sa id=-1000','-1000')]
procedure TInfosysDokumentacijaTest.DohvatiStrinicuDokumentacijePoId(aId: integer);
begin
    Assert.WillNotRaiseAny(
        procedure begin TestnaDokumentacija.DohvatiStranicuDokumentacije(aId) end,
        'Procedura baca grešku'
    )
end;
```

### DohvatiStrinicuDokumentacijeBySlug(aPageSlug:string)

Slično prethodnom testu, unutar ovog testa se radi provjera da li dohvat sadržaja dokumentacija po document-slug ne baca grešku. U tu svrhu su korištena dva TestCase-a gdje je u prvom slug postavljen na stvarnu vrijednost slug=osnovne-funkcionalnosti-TxG a u drugom TestCase-u je postavljen na random vrijednost 23525fgwscs9232r+2r2.

```pascal
[Test]
[TestCase('Dohvat stranice po parametrima slug=osnovne-funkcionalnosti-TxG','osnovne-funkcionalnosti-TxG')]
[TestCase('Dohvat stranice po parametrima slug=randomString','23525fgwscs9232r+2r2')]
procedure TInfosysDokumentacijaTest.DohvatiStrinicuDokumentacijeBySlug(
aPageSlug: string);
begin
Assert.WillNotRaiseAny(
procedure begin TestnaDokumentacija.DohvatiStranicuDokumentacije(aPageSlug) end,
'Procedura baca grešku'
)
end;
```

### PosaljiAnalitickePodatke(aAkcija,aKnjiga,aStranica,aNazivClanka:string)

Unutar ovog testa je rađena provjera da li se Analitički podaci ispravno šalju, odnosno simuliramo slanje analitičkih podataka prema backend servisu.
U tu svrhu su korišteni dva TestCase-a, 

- jedan gdje su vrijednosti parametara (aAkcija, aKnjiga,aStranica, aNazivClanka) postavljeni na 'Slajne analitičkih podataka ne baca gresku','Otvaranje članka forme,Tužbe,osnovne-funkcionalnosti-TxG, Statistike tužbi'
- drugi gdje su vrijednosti parametara (aAkcija, aKnjiga,aStranica, aNazivClanka) postavljeni na prazne string-ove.

Test provjerava da neće doći do bacanja greške u bilo kojem od gore navedenih testova.

```pascal
[Test]
[TestCase('Slajne analitičkih podataka ne baca gresku','Otvaranje članka forme,Tužbe,osnovne-funkcionalnosti-TxG, Statistike tužbi')]
[TestCase('Slajne analitičkih podataka ne baca gresku','Otvaranje članka forme,Tužbe,osnovne-funkcionalnosti, Osnovne funkcionalnosti')]
procedure TInfosysDokumentacijaTest.PosaljiAnalitickePodatke(aAkcija, aKnjiga,aStranica, aNazivClanka: string);
begin
  Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PosaljiAnalitickePodatke(aAkcija, aKnjiga, aStranica, aNazivClanka) end,
        'Slanje analitičkih podataka baca grešku'
     )
end;
```

### PrikaziSveClankeAplikacijeKrozGridKontrolu()

Ovim testom zapravo se testiraju 4 različite mogućnosti procedure PrikaziClankeAplikacijeKrozGrid time što za svaku od mogućih parametara (Sve, Novosti, Uputa, Dokumentacija) prosljeđuju funkciji kojom Assert-om provjeravamo da neće doći do bacanja greške, čime smo zapravo  tesirali čitav niz funkcionalnosti same komponente InfosysDokumentacije.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.PrikaziSveClankeAplikacijeKrozGridKontrolu;
begin
    Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozGrid(TipClanka.Sve) end,
        'Prikazi Sve Clanke Aplikacije kroz grid kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozGrid(TipClanka.Novost) end,
        'Prikazi Clanke Novosti Aplikacije kroz grid kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozGrid(TipClanka.Uputa) end,
        'Prikazi Clanke Uputa Aplikacije kroz grid kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozGrid(TipClanka.Dokumentacija) end,
        'Prikazi Clanke Dokumentacije Aplikacije kroz grid kontrolu baca grešku'
     );
end;
```

### PrikaziSveClankeAplikacijeKrozTileKontrolu()

Jako slično prethodnom testu. Jedina razlika je što se radi o tile kontroli umjesto grid kontrole. 

```pascal
[Test]
procedure TInfosysDokumentacijaTest.PrikaziSveClankeAplikacijeKrozTileKontrolu;
begin
    Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozTile(TipClanka.Sve) end,
        'Prikazi Sve Clanke Aplikacije kroz tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozTile(TipClanka.Novost) end,
        'Prikazi Clanke Novosti Aplikacije kroz tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozTile(TipClanka.Uputa) end,
        'Prikazi Clanke Uputa Aplikacije kroz tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozTile(TipClanka.Dokumentacija) end,
        'Prikazi Clanke Dokumentacija Aplikacije kroz tile kontrolu baca grešku'
     );
end;
```

### DohvatSvihClanakaFormeKrozGridKontrolu_TFormTuzbeOstale()

Unutar ovog testa se provjerava dohvat sadržaja za formu TFormTuzbeOstale, koju smo morali kreirati kao Mock. Također se provjeravaju sve 4 mogućnosti procedure jednim testom.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.DohvatSvihClanakaFormeKrozGridKontrolu_TFormTuzbeOstale;
begin
var  mock:=  TFormTuzbeOstale.CreateNew(self,1);
    Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Sve) end,
        'Prikazi Sve Clanke TFormTuzbeOstale kroz grid baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Novost) end,
        'Prikazi Clanke Novosti TFormTuzbeOstale kroz grid baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Uputa) end,
        'Prikazi Clanke Uputa TFormTuzbeOstale kroz grid baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Dokumentacija) end,
        'Prikazi Clanke Dokumentacije TFormTuzbeOstale kroz grid baca grešku'
     );
     FreeAndNil(mock);
end;
```

### DohvatSvihClanakaFormeKrozGridKontrolu_TFormStatisitikeTuzbi()

Slično predhodnom testu, ovdje provjeravamo dohvat za formu TFormStatisitikeTuzbi, koju smo također kreirali kao Mock klasu. Provjeravaju sve 4 mogućnosti procedure jednim testom.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.DohvatSvihClanakaFormeKrozGridKontrolu_TFormStatisitikeTuzbi;
begin
     var  mock:=  TFormTesna.CreateNew(self,1);
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Sve) end,
        'Prikazi Sve Clanke TFormStatisitikeTuzbi kroz grid baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Novost) end,
        'Prikazi Clanke Novosti TFormStatisitikeTuzbi kroz grid baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Uputa) end,
        'Prikazi Clanke Uputa TFormStatisitikeTuzbi kroz grid baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozGrid(mock,Dokumentacija) end,
        'Prikazi Clanke Dokumentacije TFormStatisitikeTuzbi kroz grid baca grešku'
     );
     FreeAndNil(mock);
end;
```

### DohvatSvihClanakaFormeKrozTileKontrolu_TFromTuzbeOstale()

Unutar ovog testa se provjerava funkcionalnost prikaza sadržaja forme TFormTuzbeOstale kao Mock klase kroz tile kontrolu. Također, provjeravaju se 4 moguća poziva proceduri kroz jedan test.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.DohvatSvihClanakaFormeKrozTileKontrolu_TFromTuzbeOstale;
begin
 var mock:=  TFormTuzbeOstale.CreateNew(self,1);
    Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozTile(mock,Sve) end,
        'Prikazi Sve Clanke Forme kroz Tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozTile(mock,Novost) end,
        'Prikazi Clanke Novosti Forme kroz Tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozTile(mock,Uputa) end,
        'Prikazi Clanke Uputa Forme kroz Tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozTile(mock,Dokumentacija) end,
        'Prikazi Clanke Dokumentacije Forme kroz Tile kontrolu baca grešku'
     );
     FreeAndNil(mock);
end;
```

### DohvatSvihClanakaFormeKrozTileKontrolu_TFormStatisitikeTuzbi()

Unutar ovog testa se provjerava funkcionalnost prikaza sadržaja forme TFormStatisitikeTuzbi kao Mock klase kroz tile kontrolu. Također, provjeravaju se 4 moguća poziva proceduri kroz jedan test.

```pascal
[Test]
procedure TInfosysDokumentacijaTest.DohvatSvihClanakaFormeKrozTileKontrolu_TFormStatisitikeTuzbi;
begin
 var mock:=  TFormStatisitikeTuzbi.CreateNew(self,1);
    Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozTile(mock,Sve) end,
        'Prikazi Sve Clanke FormStatisitikeTuzbi kroz Tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozTile(mock,Novost) end,
        'Prikazi Clanke Novosti FormStatisitikeTuzbi kroz Tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozTile(mock,Uputa) end,
        'Prikazi Clanke Uputa FormStatisitikeTuzbi kroz Tile kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeFormeKrozTile(mock,Dokumentacija) end,
        'Prikazi Clanke Dokumentacije FormStatisitikeTuzbi kroz Tile kontrolu baca grešku'
     );
     FreeAndNil(mock);
end;
```

### DohvatStranice_BacaGresku(aUrl,aNazivClanka:string)

Testom se provjerava da li će se desiti iznimka kod preuzimanja sadržaja ukoliko se kao parametri proslijede vrijednosti koje ne bi trebale biti proslijeđene proceduri. 

Tako za:

- prvi TestCase imamo parametre `www.infosys.ba` i `NazivClanka`
- drugi TestCase imamo parametre `dokumentacija.infosys.ba` i `NazivClanka`

U oba slučaja, test bi trebao baciti grešku.

```pascal
[Test]
[TestCase('Dohvat Stranice će bacati grešku (InfosysUrl i random string)','https://www.infosys.ba,NazivClanka')]
[TestCase('Dohvat Stranice će bacati grešku (DokumentacijaUrl i random string)','https://dokumentacija.infosys.ba,NazivClanka')]
procedure TInfosysDokumentacijaTest.DohvatStranice_BacaGresku(aUrl, aNazivClanka:string);
begin
    Assert.IsNotEmpty(aUrl,'aUrl ne može biti prazan string');
    Assert.IsNotEmpty(aNazivClanka,'NazivClanka ne može biti prazan string');
    Assert.WillRaiseAny
    (
    procedure begin TestnaDokumentacija.DohvatiClanakIzPreglednika(aUrl,aNazivClanka) end,
    'DohvatStranice baca grešku'
    )
end;
```

### DohvatStranice_NeBacaGresku(aUrl,aNazivClanka:string)

Slično prethodnom testu, ali sa drugačijim očekivanim rezultatom, ovdje se provjerava da li će dohvat stranice dokumentacije biti uspješan, odnosno, da za navedena dva TestCase-a neće biti bačenih grešaka.
Prema tome, u ovom testu imamo dva test slučaja u kojem u oba, proslijeđujemo stvarne vrijednosti:

- prvi TestCase, paramteri su:  `'https://dokumentacija.infosys.ba/books/tuzbe/page/osnovne-funkcionalnosti-TxG'` i `Osnovne funkcionalnosti`
- drugi TestCase, parametri su: `https://dokumentacija.infosys.ba/books/tuzbe/page/osnovne-funkcionalnosti-TxG` i `Presude`

U oba slučaja očekujemo da neće doći do bacanje bilo kakve greške.

**Napomena: Prilikom ovog testa se može desiti da test prijavi da je došlo do greške jer se BackEnd servisi hostiraju u testnom okruženju sa skromnijim performansama te može doći do toga da se desi greška NotConnected ili NoSocket.**

```pascal
[Test]
[TestCase('Dohvat Stranice neće bacati grešku (DokumentacijaUrl i Entiteti BIH kao članak)',
'https://dokumentacija.infosys.ba/books/tuzbe/page/osnovne-funkcionalnosti-TxG,Osnovne funkcionalnosti')]
[TestCase('Dohvat Stranice neće bacati grešku','https://dokumentacija.infosys.ba/books/tuzbe/page/osnovne-funkcionalnosti-TxG,Presude')]
procedure TInfosysDokumentacijaTest.DohvatStranice_NeBacaGresku(aUrl, aNazivClanka:string);
begin
     Assert.IsNotEmpty(aUrl,'aUrl ne može biti prazan string');
     Assert.IsNotEmpty(aNazivClanka,'NazivClanka ne može biti prazan string');
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.DohvatiClanakIzPreglednika(aUrl,aNazivClanka) end,
        ''
     )
end;
```
