unit TestInfosysDokumentacija;
interface

uses
  DUnitX.TestFramework, InfosysDokumentacija, System.Classes, System.SysUtils,
  Vcl.Forms, Vcl.Controls, Delphi.Mocks, IdHttp, cxGridTableView, cxGrid, Messages, Windows,
  PomocneKlaseInfosysDokumentacija, PreglednikInfosysDokumentcije, dxTileControl, Vcl.Graphics;


  type TFormStatisitikeTuzbi = class(TForm)
  private
  public
  end;

  type TFormTuzbeOstale = class(TForm)
  private
  public
  end;



type
//  [TestFixture]
  TInfosysDokumentacijaTest = class(TComponent)
  private
  TestnaDokumentacija: TInfosysDokumentacija;
  public

    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;


    {$region 'Unit test - Komponenta dokumentacije'}
    [Test]
    procedure DaLiJeInicijalizacijaUredu;
    [Test]
    procedure Postavljen_UkloniLinkoveSaSlika;
    [Test]
    procedure Postavljen_AppId;
    [Test]
    procedure Postavljen_FiksirajDuzinuSadrzaja;
    [Test]
    procedure Postavljen_PrikaziMetaPodatke;
    [Test]
    procedure Inicijalizacija_IndyHttp();
    [Test]
    procedure StreemToString;
    [Test]
    procedure DodajClankeUObjekat;
    {$endregion}


    {$region 'Integracijski testovi'}
    [Test]
    procedure OtvaranjeClanakaFormeKrozGridKontrolu_TFormSTuzbeOstale;

    [Test]
    [TestCase('Dohvat stranice sa id=1','1')]
    [TestCase('Dohvat stranice sa id=-1000','-1000')]
    procedure DohvatiStrinicuDokumentacijePoId(aId:integer);

    [Test]
    [TestCase('Dohvat stranice po parametrima slug=osnovne-funkcionalnosti-TxG','osnovne-funkcionalnosti-TxG')]
    [TestCase('Dohvat stranice po parametrima slug=randomString','23525fgwscs9232r+2r2')]
    procedure DohvatiStrinicuDokumentacijeBySlug(aPageSlug:string);

    [Test]
    [TestCase('Slajne analitičkih podataka ne baca gresku','Otvaranje članka forme,Tužbe,osnovne-funkcionalnosti-TxG, Statistike tužbi')]
    [TestCase('Slajne analitičkih podataka ne baca gresku','Otvaranje članka forme,Tužbe,osnovne-funkcionalnosti, Osnovne funkcionalnosti')]
    procedure PosaljiAnalitickePodatke(aAkcija,aKnjiga,aStranica,aNazivClanka:string);

   [Test]
    procedure PrikaziSveClankeAplikacijeKrozGridKontrolu;
   [Test]
   procedure PrikaziSveClankeAplikacijeKrozTileKontrolu;

   [Test]
   procedure DohvatSvihClanakaFormeKrozGridKontrolu_TFormTuzbeOstale;
   [Test]
   procedure DohvatSvihClanakaFormeKrozGridKontrolu_TFormStatisitikeTuzbi;
   [Test]
   procedure DohvatSvihClanakaFormeKrozTileKontrolu_TFromTuzbeOstale;
   [Test]
   procedure DohvatSvihClanakaFormeKrozTileKontrolu_TFormStatisitikeTuzbi;

  [Test]
  [TestCase('Dohvat Stranice će bacati grešku (InfosysUrl i random string)','https://www.infosys.ba,NazivClanka')]
  [TestCase('Dohvat Stranice će bacati grešku (DokumentacijaUrl i random string)','https://dokumentacija.infosys.ba,NazivClanka')]
  procedure DohvatStranice_BacaGresku(aUrl,aNazivClanka:string);

  [Test]
  [TestCase('Dohvat Stranice neće bacati grešku (DokumentacijaUrl i Entiteti BIH kao članak)',
                    'https://dokumentacija.infosys.ba/books/tuzbe/page/osnovne-funkcionalnosti-TxG,Osnovne funkcionalnosti')]
  [TestCase('Dohvat Stranice neće bacati grešku','https://dokumentacija.infosys.ba/books/tuzbe/page/osnovne-funkcionalnosti-TxG,Presude')]
  procedure DohvatStranice_NeBacaGresku(aUrl,aNazivClanka:string);
  {$endregion}


  end;


implementation

procedure TInfosysDokumentacijaTest.Setup;
begin
 TestnaDokumentacija:=TInfosysDokumentacija.Create(self);
 TestnaDokumentacija.AppId:='66';
end;

procedure TInfosysDokumentacijaTest.StreemToString;
begin
     var tempStream:=TStream.Create;
     tempStream:=nil;
     var rez := TestnaDokumentacija.StreamToString(tempStream);
     if rez='' then
     Assert.Pass('Stream je nil!');
end;

procedure TInfosysDokumentacijaTest.TearDown;
begin
 TestnaDokumentacija.Free;
end;



procedure TInfosysDokumentacijaTest.Postavljen_AppId;
begin
     var daLiJePostavljenAppId:=TestnaDokumentacija.isAppIdSet;
     Assert.AreEqual(daLiJePostavljenAppId,true);
end;

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

procedure TInfosysDokumentacijaTest.DohvatStranice_NeBacaGresku(aUrl,
    aNazivClanka:string);
begin
     Assert.IsNotEmpty(aUrl,'aUrl ne može biti prazan string');
     Assert.IsNotEmpty(aNazivClanka,'NazivClanka ne može biti prazan string');

     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.DohvatiClanakIzPreglednika(aUrl,aNazivClanka) end,
        ''
     )
end;

procedure TInfosysDokumentacijaTest.Postavljen_FiksirajDuzinuSadrzaja;
begin
     var daLiJePostavljenFiksirajDuzinuSadrzaja:=TestnaDokumentacija.isFiksirajSirinuSadrzaja;
     Assert.AreEqual(daLiJePostavljenFiksirajDuzinuSadrzaja,false);
end;

procedure TInfosysDokumentacijaTest.Postavljen_PrikaziMetaPodatke;
begin
     var rezultat:=TestnaDokumentacija.isPrikaziMetaPodatke;
     Assert.AreEqual(rezultat,false);
end;

procedure TInfosysDokumentacijaTest.Postavljen_UkloniLinkoveSaSlika;
begin
     var rezultat := TestnaDokumentacija.isUkloniLinkoveSaSlika;
     Assert.AreEqual(rezultat,True);
end;

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

procedure TInfosysDokumentacijaTest.DohvatiStrinicuDokumentacijeBySlug(
  aPageSlug: string);
begin
    Assert.WillNotRaiseAny(
        procedure begin TestnaDokumentacija.DohvatiStranicuDokumentacije(aPageSlug) end,
        'Procedura baca grešku'
    )
end;


procedure TInfosysDokumentacijaTest.DohvatiStrinicuDokumentacijePoId(aId: integer);
begin
    Assert.WillNotRaiseAny(
        procedure begin TestnaDokumentacija.DohvatiStranicuDokumentacije(aId) end,
        'Procedura baca grešku'
    )
end;

procedure TInfosysDokumentacijaTest.DohvatStranice_BacaGresku(aUrl,
    aNazivClanka:string);
begin
     Assert.IsNotEmpty(aUrl,'aUrl ne može biti prazan string');
     Assert.IsNotEmpty(aNazivClanka,'NazivClanka ne može biti prazan string');
     Assert.WillRaiseAny
     (
        procedure begin TestnaDokumentacija.DohvatiClanakIzPreglednika(aUrl,aNazivClanka) end,
        'DohvatStranice baca grešku'
     )
end;



procedure TInfosysDokumentacijaTest.PosaljiAnalitickePodatke(aAkcija, aKnjiga,
  aStranica, aNazivClanka: string);
begin
  Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PosaljiAnalitickePodatke(aAkcija, aKnjiga, aStranica, aNazivClanka) end,
        'Slanje analitičkih podataka baca grešku'
     )
end;

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


procedure TInfosysDokumentacijaTest.PrikaziSveClankeAplikacijeKrozGridKontrolu;
begin
    Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozGrid(Sve) end,
        'Prikazi Sve Clanke Aplikacije kroz grid kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozGrid(Novost) end,
        'Prikazi Clanke Novosti Aplikacije kroz grid kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozGrid(Uputa) end,
        'Prikazi Clanke Uputa Aplikacije kroz grid kontrolu baca grešku'
     );
     Assert.WillNotRaiseAny
     (
        procedure begin TestnaDokumentacija.PrikaziClankeAplikacijeKrozGrid(Dokumentacija) end,
        'Prikazi Clanke Dokumentacije Aplikacije kroz grid kontrolu baca grešku'
     );
end;

procedure
    TInfosysDokumentacijaTest.DohvatSvihClanakaFormeKrozGridKontrolu_TFormStatisitikeTuzbi;
begin
     var  mock:=  TFormStatisitikeTuzbi.CreateNew(self,1);
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

procedure
    TInfosysDokumentacijaTest.DohvatSvihClanakaFormeKrozGridKontrolu_TFormTuzbeOstale;
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

procedure
    TInfosysDokumentacijaTest.DohvatSvihClanakaFormeKrozTileKontrolu_TFormStatisitikeTuzbi;
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

procedure
    TInfosysDokumentacijaTest.DohvatSvihClanakaFormeKrozTileKontrolu_TFromTuzbeOstale;
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


initialization
  TDUnitX.RegisterTestFixture(TInfosysDokumentacijaTest);
end.
