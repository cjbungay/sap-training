REPORT SAPBC420_PRPD_RFBIDE00_CT MESSAGE-ID FB.
************************************************************************
*        Der Generierungsreport RFBIDEG0
*            benutzt den Rahmen RFBIDE01
*            und schreibt das darin enthaltene Coding
*            plus das neu generierte Coding in RFBIDE00.
************************************************************************

************************************************************************
*        Batch-Input-Programm für Debitorstammdaten.
*        Batch-Input-Programm für Kreditlimitdaten.
************************************************************************

*-----------------------------------------------------------------------
*        Zentrale Adress Verwaltung
*-----------------------------------------------------------------------
INCLUDE RFBIZAVD.

*-----------------------------------------------------------------------
*        Dynproreihenfolge und Zuordnung
*-----------------------------------------------------------------------
INCLUDE MF02DDYN.

*-----------------------------------------------------------------------
*        Tabellen
*-----------------------------------------------------------------------
TABLES:  BGR00,                        " Mappenvorsatz
         BKN00,                        " Debi. Batch-Input-Kopfsatz
         BKNA1, KNA1,                  " DEBI. Allgemein Teil 1
         BKNAT,                        " DEBI. Steuerkategorien    J_1A
         BKNBK,                        " DEBI. Bankverbindungen
         BKNBW,                        " DEBI. Quellensteuer
         BKNB1, KNB1,                  " DEBI. Buchungskreisdaten
         BKNB5,                        " DEBI. Mahndaten
         BKNKA,                        " Kreditlimit Kontr.ber.übergr.
         BKNKK,                        " Kreditlimit Kontrollbereich
         BKNVV, KNVV,                  " DEBI. Vertriebsdaten
         BKNEX,                        " DEBI. Außenhandel
         BKNVA,                        " DEBI. Abladestellen
         BKNVD,                        " DEBI. Nachrichten
         BKNVI,                        " DEBI. Steuern Vertrieb
         BKNVK,                        " DEBI. Ansprechpartner
         BKNVL,                        " DEBI. Lizenzen Vertrieb
         BKNVP,                        " DEBI. Partnerrollen
         BKNZA,                        " DEBI. Abw. Regulierer
         BNKA,                         " Bankanschrift
*mi/46a begin
         BWRF12,                       " Empfangsstellen
         BWRF4,                        " Abteilungen
*mi/46a end
         BIADDR2.                      " Privataddresse Konsument


TABLES:  T005,                         " Länderschlüssel
         T007C,                        " Steuerkategorien       J_1A
         T020,                         " Transaktionssteuerung
         T100,                         " Nachrichten
         TVWA,                         " Warenannahmezeiten
         T001,                         " Buchungskreisdaten
         T059P,                        " Quellensteuertypen
         T077D,                        " Kontengruppen
         DXFILE.
*eject
*---------------------------------------------------------------------*
*        Interne Tabellen
*---------------------------------------------------------------------*
*------- Dynproreihenfolge ---------------------------------------------
DATA:    BEGIN OF DYNTAB OCCURS 10,
           DYNNR(4)     TYPE C,        " Dynpronummer
           DTYPE(1)     TYPE C,        " A=Allg F=RF V=RV L=Limit
           XLIST(1)     TYPE C,        " X=Listdynpro
         END OF DYNTAB.

*------- Feldtabelle ---------------------------------------------------
DATA:    BEGIN OF FT OCCURS 0.
        INCLUDE STRUCTURE BDCDATA.
DATA:    END OF FT.

*------- Feld-Informationen aus NAMETAB --------------------------------
DATA:    BEGIN OF NAMETAB OCCURS 60.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB.

*------- Feld-Informationen aus NAMETAB für BKN00 ----------------------
DATA:    BEGIN OF NAMETAB_BKN00 OCCURS 10.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKN00.

*begin of j_1a
*------- Feld-Informationen aus NAMETAB für BKNAT ----------------------
DATA:    BEGIN OF NAMETAB_BKNAT OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNAT.
*end of j_1a

*------- Feld-Informationen aus NAMETAB für BKNBK ----------------------
DATA:    BEGIN OF NAMETAB_BKNBK OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNBK.

*------- Feld-Informationen aus NAMETAB für BKNBW ----------------------
DATA:    BEGIN OF NAMETAB_BKNBW OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNBW.

*------- Feld-Informationen aus NAMETAB für BKNVA ---------------------
DATA:    BEGIN OF NAMETAB_BKNVA OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNVA.

*------- Feld-Informationen aus NAMETAB für BKNEX ---------------------
DATA:    BEGIN OF NAMETAB_BKNEX OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNEX.

*------- Feld-Informationen aus NAMETAB für BKNVD ---------------------
DATA:    BEGIN OF NAMETAB_BKNVD OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNVD.

*------- Feld-Informationen aus NAMETAB für BKNVI ---------------------
DATA:    BEGIN OF NAMETAB_BKNVI OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNVI.

*------- Feld-Informationen aus NAMETAB für BKNVK ---------------------
DATA:    BEGIN OF NAMETAB_BKNVK OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNVK.

*------- Feld-Informationen aus NAMETAB für BKNVL ---------------------
DATA:    BEGIN OF NAMETAB_BKNVL OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNVL.

*------- Feld-Informationen aus NAMETAB für BKNVP ---------------------
DATA:    BEGIN OF NAMETAB_BKNVP OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNVP.

*------- Feld-Informationen aus NAMETAB für BKNZA ----------------------
DATA:    BEGIN OF NAMETAB_BKNZA OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BKNZA.

*mi/46a begin
*------- Feld-Informationen aus NAMETAB für BWRF12 ---------------------
DATA:    BEGIN OF NAMETAB_BWRF12 OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BWRF12.

*------- Feld-Informationen aus NAMETAB für BWRF4 ----------------------
DATA:    BEGIN OF NAMETAB_BWRF4 OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BWRF4.
*mi/46a end

*ms/46a begin
*------- Feld-Informationen aus NAMETAB für BIADDR2 --------------------
DATA:    BEGIN OF NAMETAB_BIADDR2 OCCURS 20.
        INCLUDE STRUCTURE DNTAB.
DATA:    END OF NAMETAB_BIADDR2.
*ms/46a end

*begin of j_1a
*------- Steuekategorien -----------------------------------------------
DATA:    BEGIN OF XBKNAT OCCURS 9.
        INCLUDE STRUCTURE BKNAT.
DATA:    END OF XBKNAT.
*end of j_1a

*------- Bankverbindungen ----------------------------------------------
DATA:    BEGIN OF XBKNBK OCCURS 9.
        INCLUDE STRUCTURE BKNBK.
DATA:    END OF XBKNBK.

*------- Quellensteuer -------------------------------------------------
DATA:    BEGIN OF XBKNBW OCCURS 9.
        INCLUDE STRUCTURE BKNBW.
DATA:    END OF XBKNBW.

*------- Außenhandel --------------------------------------------------
DATA:    BEGIN OF XBKNEX OCCURS 9.
        INCLUDE STRUCTURE BKNEX.
DATA:    END OF XBKNEX.

*------- Abladestellen ------------------------------------------------
DATA:    BEGIN OF XBKNVA OCCURS 9.
        INCLUDE STRUCTURE BKNVA.
DATA:    END OF XBKNVA.

*------- Nachrichten --------------------------------------------------
DATA:    BEGIN OF XBKNVD OCCURS 9.
        INCLUDE STRUCTURE BKNVD.
DATA:    END OF XBKNVD.

*------- Steuern ------------------------------------------------------
DATA:    BEGIN OF XBKNVI OCCURS 9.
        INCLUDE STRUCTURE BKNVI.
DATA:    END OF XBKNVI.

*------- Ansprechpartner ----------------------------------------------
DATA:    BEGIN OF XBKNVK OCCURS 9.
        INCLUDE STRUCTURE BKNVK.
DATA:    END OF XBKNVK.

*------- Lizenzen -----------------------------------------------------
DATA:    BEGIN OF XBKNVL OCCURS 9.
        INCLUDE STRUCTURE BKNVL.
DATA:    END OF XBKNVL.

*------- Partnerrollen ------------------------------------------------
DATA:    BEGIN OF XBKNVP OCCURS 9.
        INCLUDE STRUCTURE BKNVP.
DATA:    END OF XBKNVP.

*------- abw. Regulierer         ---------------------------------------
DATA:    BEGIN OF XBKNZA OCCURS 9.
        INCLUDE STRUCTURE BKNZA.
DATA:    END OF XBKNZA.

*------- abw. Regulierer (A-Segment) ---------------------------
DATA:    BEGIN OF XBKNZAA OCCURS 9.
        INCLUDE STRUCTURE BKNZA.
DATA:    END OF XBKNZAA.

*------- abw. Zahlungsempfaenger (B-Segment) ---------------------------
DATA:    BEGIN OF XBKNZAB OCCURS 9.
        INCLUDE STRUCTURE BKNZA.
DATA:    END OF XBKNZAB.

*------- Transaktionssteuerung -----------------------------------------
DATA:    BEGIN OF XT020 OCCURS 5.
        INCLUDE STRUCTURE T020.
DATA:    END OF XT020.

*------- Länderschlüssel ----------------------------------------------
DATA:    BEGIN OF XT005 OCCURS 5.
        INCLUDE STRUCTURE T005.
DATA:    END OF XT005.

*mi/46a begin
*------- Empfangsstellen ----------------------------------------------
DATA:    BEGIN OF XBWRF12 OCCURS 5.
        INCLUDE STRUCTURE BWRF12.
DATA:    END OF XBWRF12.

*------- Abteilungen --------------------------------------------------
DATA:    BEGIN OF XBWRF4 OCCURS 5.
        INCLUDE STRUCTURE BWRF4.
DATA:    END OF XBWRF4.
*mi/46a end

*begin of j_1a
*------- Steuekategorien ----------------------------------------------
DATA:    BEGIN OF XT007C OCCURS 5.
        INCLUDE STRUCTURE T007C.
DATA:    END OF XT007C.
*end of j_1a

*------- Quellensteuertypen --------------------------------------------
DATA:    BEGIN OF XT059P OCCURS 5.
        INCLUDE STRUCTURE T059P.
DATA:    END OF XT059P.

*eject
*---------------------------------------------------------------------*
*        Strukturen
*---------------------------------------------------------------------*
*------- Initialstrukturen --------------------------------------------
DATA:    BEGIN OF I_BKNA1.
        INCLUDE STRUCTURE BKNA1.       " DEBI. Stamm Allg. Teil 1
DATA:    END OF I_BKNA1.

*begin of j_1a
DATA:    BEGIN OF I_BKNAT.
        INCLUDE STRUCTURE BKNAT.       " DEBI. Steuerkategorien
DATA:    END OF I_BKNAT.
*end of j_1a

DATA:    BEGIN OF I_BKNBK.
        INCLUDE STRUCTURE BKNBK.       " DEBI. Bankverbindungen
DATA:    END OF I_BKNBK.

DATA:    BEGIN OF I_BKNBW.
        INCLUDE STRUCTURE BKNBW.       " DEBI. Quellensteuerdaten
DATA:    END OF I_BKNBW.

DATA:    BEGIN OF I_BKNB1.
        INCLUDE STRUCTURE BKNB1.       " DEBI. Buchungskreisdaten
DATA:    END OF I_BKNB1.

DATA:    BEGIN OF I_BKNB5.
        INCLUDE STRUCTURE BKNB5.       " DEBI. Mahndaten
DATA:    END OF I_BKNB5.

DATA:    BEGIN OF I_BKNKA.
        INCLUDE STRUCTURE BKNKA.       " Kreditlimit Kontr.ber.übergr.
DATA:    END OF I_BKNKA.

DATA:    BEGIN OF I_BKNKK.
        INCLUDE STRUCTURE BKNKK.       " Kreditlimit Kontrollbereich
DATA:    END OF I_BKNKK.

DATA:    BEGIN OF I_BKNVV.
        INCLUDE STRUCTURE BKNVV.       " DEBI. Vertriebsdaten
DATA:    END OF I_BKNVV.

DATA:    BEGIN OF I_BKNEX.
        INCLUDE STRUCTURE BKNEX.       " DEBI. Außenhandel
DATA:    END OF I_BKNEX.

DATA:    BEGIN OF I_BKNVA.
        INCLUDE STRUCTURE BKNVA.       " DEBI. Abladestellen
DATA:    END OF I_BKNVA.

DATA:    BEGIN OF I_BKNVD.
        INCLUDE STRUCTURE BKNVD.       " DEBI. Nachrichten
DATA:    END OF I_BKNVD.

DATA:    BEGIN OF I_BKNVI.
        INCLUDE STRUCTURE BKNVI.       " DEBI. Steuern
DATA:    END OF I_BKNVI.

DATA:    BEGIN OF I_BKNVK.
        INCLUDE STRUCTURE BKNVK.       " DEBI. Ansprechpartner
DATA:    END OF I_BKNVK.

DATA:    BEGIN OF I_BKNVL.
        INCLUDE STRUCTURE BKNVL.       " DEBI. Lizenzen
DATA:    END OF I_BKNVL.

DATA:    BEGIN OF I_BKNVP.
        INCLUDE STRUCTURE BKNVP.       " DEBI. Partnerrollen
DATA:    END OF I_BKNVP.

DATA:    BEGIN OF I_BKNZA.
        INCLUDE STRUCTURE BKNZA.       " Kred. abw. Zahlungsempfaenger
DATA:    END OF I_BKNZA.

*mi/46a begin
DATA:    BEGIN OF I_BWRF12.
        INCLUDE STRUCTURE BWRF12.      " Empfangstellen
DATA:    END OF I_BWRF12.

DATA:    BEGIN OF I_BWRF4.
        INCLUDE STRUCTURE BWRF4.       " Abteilungen
DATA:    END OF I_BWRF4.
*mi/46a end

*ms/46a begin
DATA:    BEGIN OF I_BIADDR2.
        INCLUDE STRUCTURE BIADDR2.       " Privatadresse Konsument
DATA:    END OF I_BIADDR2.
*ms/46a end

*------- Workarea zum Lesen der BI-Sätze -------------------------------
DATA:    BEGIN OF WA,
           CHAR1(250)   TYPE C,
           CHAR2(250)   TYPE C,
           CHAR3(250)   TYPE C,
           CHAR4(1000)   TYPE C,
         END OF WA.

*------- Hilfsfelder ---------------------------------------------------
DATA:    BEGIN OF BI,
           XASEG(1)     TYPE C,        " X=Allg. Daten bearbeiten
           XBUKR(1)     TYPE C,        " X=RF-Tabellen bearbeiten
           XVKOR(1)     TYPE C,        " X=RV-Tabellen bearbeiten
           XKKBR(1)     TYPE C,        " X=KNKK bearbeiten
         END OF BI.

*eject
*---------------------------------------------------------------------*
*        Einzelfelder
*---------------------------------------------------------------------*
DATA:    BANK_KEY       LIKE BNKA-BANKL.    " BLZ oder Bankkonto (NL)

DATA:    CHAR(30)       TYPE C,        " Char. Hilfsfeld
         CHAR1(1)       TYPE C,        " Char. Hilfsfeld
         CHAR2(1)       TYPE C,        " Char. Hilfsfeld
         COMMIT_COUNT(4) TYPE N.       " Zähler für Commit

DATA:    DYN_COUNT(2)   TYPE N.        " Anzahl Dynpros in DYNTAB

DATA:    GROUP_COUNT(6) TYPE C,        " Anzahl Mappen
         GROUP_OPEN(1)  TYPE C.        " X=Mappe schon geöffnet

DATA:    KUNNR          LIKE BKN00-KUNNR,   " Kundennummer
         KNA1_ZUDA(1)   TYPE C,        " KNA1-Zus.daten-Hilfsfeld
         KNVK_MESS(1)   TYPE C,        " KNVK-Message-Hilfsfeld
         KNVV_ZUDA(1)   TYPE C.        " KNVV-Zus.daten-Hilfsfeld

DATA:    LICEX(1)       TYPE C.        " Hilfsfeld Existenz Lizenz

DATA:    MSGVN          LIKE SY-MSGV1, " Hilfsfeld Message-Variable
         MSG(100).                     " Hilfsfeld Message-Variable

DATA:    N(2)           TYPE N,        " Hilfsfeld num.
         NODATA(1)      TYPE C,        " Keine BI-Daten für Feld
         NODATA_OLD     LIKE NODATA.   " NODATA gemerkt

DATA:    REFE1(8)       TYPE P.        " Hilfsfeld gepackt

DATA:    SATZ2_COUNT(6) TYPE C,        " Anz. Sätze(Typ2) je Trans.
         SUBRC          LIKE SY-SUBRC. " Subrc

DATA:    TEXT(200)      TYPE C,        " Messagetext
         TEXT1(40)      TYPE C,        " Messagetext
         TEXT2(40)      TYPE C,        " Messagetext
         TEXT3(40)      TYPE C,        " Messagetext
         TRANS_COUNT(6) TYPE C,        " Anz. Transakt. je Mappe
         TRANS_BREAK(6) TYPE C.        " Anz. Transakt. je Mappe

DATA:    TABIX          LIKE SY-TABIX. " Hilfsfeld Tabix

DATA:    WERT(60)       TYPE C.        " Hilfsfeld Feldinhalt

DATA:    BRSCH1(1)   TYPE C VALUE ' '. " Hilfsfeld für kna1-brsch
DATA:    BRSCH2(1)   TYPE C VALUE ' '. " Hilfsfeld für kna1-brsch

DATA:    XEOF(1)        TYPE C,        " X=End of File erreicht
         XNEWG(1)       TYPE C,        " X=Neue Mappe
         XDYTR(1)       TYPE C,        " X=Dynpro transportiert
         XMESS_BKNA1-SENDE(1) TYPE C,  " Message (BKNA1 erweitert)
         XMESS_BKNB1-SENDE(1) TYPE C,  " Message (BKNB1 erweitert)
         XMESS_BKNBK-SENDE(1) TYPE C,  " Message (BKNBK erweitert)
         XMESS_BKNKK-SENDE(1) TYPE C,  " Message (BKNKK erweitert)
         XMESS_BKNEX-SENDE(1) TYPE C,  " Message (BKNEX erweitert)
         XMESS_BKNVA-SENDE(1) TYPE C,  " Message (BKNVA erweitert)
         XMESS_BKNVK-SENDE(1) TYPE C,  " Message (BKNVK erweitert)
         XMESS_BKNVP-SENDE(1) TYPE C,  " Message (BKNVP erweitert)
         XMESS_BKNVV-SENDE(1) TYPE C,  " Message (BKNVV erweitert)
         XMESS_BKNZA-SENDE(1) TYPE C,  " Message (BKNZA erweitert)
         XMESS_FD32(1)  TYPE C.        " Message (FD32 neu)


* begin P30K113875
* einmaliger Ansprung des Dynpro zum Löschen und Sperren
DATA: SPERRE_GESETZT(1) TYPE C,
      LOESCH_GESETZT(1) TYPE C.
* end P30K113875

*-----------------------------------------------------------------------
*        Konstanten, Feld-Symbole
*-----------------------------------------------------------------------
DATA:    C_NODATA(1)    TYPE C VALUE '/',   " Default für NODATA.
         XON                   VALUE 'X'.   " Flag eingeschaltet

DATA:    FMF1GES(1)     TYPE X VALUE '20'.  " Beide Flags aus: Input.
DATA:    FMB1NUM(1)     TYPE X VALUE '10'.  "       "

DATA:    MAX_COMMIT(4)  TYPE N VALUE '0100'. "Anzahl Trans. je Commit

DATA:    REP_NAME_D(8)  TYPE C VALUE 'SAPMF02D'. " Modulpoolname Debitor
DATA:    REP_NAME_L(8)  TYPE C VALUE 'SAPMF02C'. " Modulpoolname Limit

FIELD-SYMBOLS: <F1>.

************************************************************************
*        Falls 'Call Transaction ... Using ...' gewünscht bitte die
*        drei folgenden Datenfelder aussternen und die
*        drei gleichlautenden Parameter einsternen.
*        Vor der Benutzung des 'Call Transaction ... Using ...'
*        bitte die Datei prüfen.
************************************************************************
*DATA:    XCALL(1)       TYPE C.        " X=Call transaction ..usin
*DATA:    ANZ_MODE(1)    TYPE C.        " A=alles N=nichts E=Error
*DATA:    UPDATE(1)      TYPE C.        " S=Synchron A=Asynchron

*------- Aufbau des Selektionsbildes -----------------------------------
SELECTION-SCREEN SKIP 1.
select-options: FILESIN FOR DXFILE-FILENAME NO INTERVALS no-display..
parameters: DS_NAME  LIKE RFPDO-RFBIFILE
                                      .  " Dateiname

SELECTION-SCREEN SKIP 1.
*selection-screen uline.
*selection-screen skip 1.

SELECTION-SCREEN BEGIN OF BLOCK BL2 WITH FRAME TITLE TEXT-BL2.
PARAMETERS:
  OS_XON       LIKE  RFPDO-RFBIOLDSTR. " Alte Strukturen ?
SELECTION-SCREEN END OF BLOCK BL2.

SELECTION-SCREEN BEGIN OF BLOCK BL3 WITH FRAME TITLE TEXT-BL3.
PARAMETERS: FL_CHECK    LIKE RFPDO-RFBICHCK.  " Datei nur prüfen
SELECTION-SCREEN END OF BLOCK BL3.


PARAMETERS: XCALL       LIKE RFPDO-RFBICALL default 'X'.
*                                           . " X=Call trans...using ..
PARAMETERS: ANZ_MODE    LIKE RFPDO-ALLGAZMD  " A=alles N=nichts E=Error
                             DEFAULT 'N'.
PARAMETERS: UPDATE      LIKE RFPDO-ALLGVBMD  " S=Synchron A=Asynchron
                             DEFAULT 'S'.

*eject
************************************************************************
*        Hauptablauf
************************************************************************

at selection-screen output.
read table FILESIN index 1.
DS_NAME = FILESIN-low.

START-OF-SELECTION.
CLEAR: XEOF, XNEWG,
       GROUP_COUNT, TRANS_COUNT, SATZ2_COUNT,
       COMMIT_COUNT.

*------- Datei nur prüfen ? --------------------------------------------
IF FL_CHECK NE SPACE.
  MESSAGE I018 WITH DS_NAME.
ENDIF.

*------- Call Transaction .. Using ..? ---------------------------------
IF XCALL NE SPACE.
  IF FL_CHECK NE SPACE.
    MESSAGE I022.
  ELSE.
    MESSAGE I021.
  ENDIF.
ENDIF.

*------- Datei öffnen / lesen ---------------------------------------
OPEN DATASET DS_NAME FOR INPUT IN TEXT MODE MESSAGE MSG.
IF SY-SUBRC NE 0.
  MESSAGE I899 WITH MSG.
  MESSAGE A002 WITH DS_NAME.
ENDIF.

CLEAR WA.
READ DATASET DS_NAME INTO WA.
IF SY-SUBRC NE 0.
  MESSAGE A003 WITH DS_NAME.
ENDIF.

*------- erster Satz muss Mappensatz sein ------------------------------
IF WA(1) NE '0'.
  MESSAGE A004 WITH DS_NAME.
ENDIF.

*------- Mappedaten prüfen und Mappe öffnen ----------------------------
PERFORM MAPPE_PRUEFEN_OEFFNEN.

*------- 1. Kopfsatz lesen / bearbeiten --------------------------------
PERFORM KOPFSATZ_LESEN.

*-- Falls nur der Mappenvorsatz BGR00 übergeben worden ist, so wird ----
*-- eine leere Mappe erzeugt  ------------------------------------------
IF XEOF = 'X'.
  MESSAGE I070 WITH DS_NAME.
  MESSAGE I071 WITH BGR00-GROUP.
  PERFORM MAPPE_SCHLIESSEN.
  EXIT.
ENDIF.

PERFORM KOPFSATZ_BEARBEITEN.

WHILE XEOF NE 'X'.
  PERFORM INIT_DEBI_STRUKTUREN.

*-----------------------------------------------------------------------
*        Batch-Input-Datensätzen für die Transaktion lesen
*-----------------------------------------------------------------------
  DO.
    CLEAR WA.
    READ DATASET DS_NAME INTO WA.

*------- End of File erreicht ? --> Exit Do-Schleife -------------------
    IF SY-SUBRC NE 0.
      XEOF = 'X'.
      EXIT.
    ENDIF.

*------- Nächste Mappe ? --> Exit Do-Schleife --------------------
    IF WA(1) = '0'.
      XNEWG = 'X'.
      EXIT.
    ENDIF.

*------- Nächste Transaktion ? --> Exit Do-Schleife --------------------
    IF WA(1) = '1'.
      EXIT.
    ENDIF.

*------- Kennzeichen für Datensatz (Typ 2) gesetzt ? -------------------
    SATZ2_COUNT = SATZ2_COUNT + 1.
    IF WA(1) NE '2'.
      MESSAGE I102 WITH TRANS_COUNT SATZ2_COUNT.
      PERFORM DUMP_BKN00.
      MESSAGE A013.
    ENDIF.

* Daten werden wegen der Feldlänge-Erweiterung des Feldes TBNAM
* von 10B (<4.0) auf 30B verschoben
    IF OS_XON = XON.
      SHIFT WA BY 20 PLACES RIGHT.
      WA(31) = WA+20(11).
    ENDIF.

*------- Tabellenname angegeben ? --------------------------------------
    IF WA+1(1)  = NODATA
    OR WA+1(10) = SPACE.
      MESSAGE I103 WITH TRANS_COUNT SATZ2_COUNT.
      PERFORM DUMP_BKN00.
      MESSAGE A013.
    ENDIF.

*------- Daten aus Workarea in Strukturen übertragen--------------------
    PERFORM WA_UEBERTRAGEN.
  ENDDO.

*-----------------------------------------------------------------------
*        Transaktion erzeugen.
*-----------------------------------------------------------------------

*------- Daten in Dynpros übertragen -----------------------------------
  PERFORM DATEN_UEBERTRAGUNG.
  IF XEOF NE 'X'.

*------- Neue Mappe ? --------------------------------------------------
    IF XNEWG = 'X'.
      PERFORM MAPPEN_WECHSEL.

*------- nächsten Kopfsatz lesen ---------------------------------------
      PERFORM KOPFSATZ_LESEN.
    ENDIF.

*------- nächsten Kopfsatz bearbeiten ----------------------------------
    PERFORM KOPFSATZ_BEARBEITEN.
  ENDIF.
ENDWHILE.

*------- Mappe schliessen ----------------------------------------------
PERFORM MAPPE_SCHLIESSEN.


*-----------------------------------------------------------------------
*        Zentrale Adress Verwaltung  ZAV
*        Gemeinsame Routinen für Debitor und Kreditor
*-----------------------------------------------------------------------
INCLUDE RFBIZAV0.

*eject.
************************************************************************
*        Interne Perform-Routinen
************************************************************************
*eject
*-----------------------------------------------------------------------
*        Form  AKTIVITAET_ERMITTELN
*-----------------------------------------------------------------------
*        Ermitteln von Aktion   (AKTYP)
*                      Vorgang  (DYNCL)
*                      Funktion (FUNCL) aus T020 (XT020).
*-----------------------------------------------------------------------
FORM AKTIVITAET_ERMITTELN.
  IF BKN00-TCODE(1) = NODATA
  OR BKN00-TCODE    = SPACE.
    MESSAGE I112 WITH TRANS_COUNT.
    PERFORM DUMP_BKN00.
    MESSAGE A013.
  ENDIF.

*------- Tcode erlaubt? -----------------------------------------------
  IF BKN00-TCODE = 'FD20'
  OR BKN00-TCODE = 'FD22'.
    IF XMESS_FD32 NE 'X'.
      MESSAGE I026 WITH TRANS_COUNT BKN00-TCODE.
      XMESS_FD32 = 'X'.
    ENDIF.
    BKN00-TCODE = 'FD32'.
  ENDIF.
  IF  BKN00-TCODE NE 'XD01'            " Anl. Debitor zentral
  AND BKN00-TCODE NE 'XD02'            " Änd. Debitor zentral
  AND BKN00-TCODE NE 'XD05'            " Änd. Sperren zentral
  AND BKN00-TCODE NE 'XD06'            " Änd. Lövm    zentral
  AND BKN00-TCODE NE 'FD32'.           " Pflegen Kreditlimit
    MESSAGE I109 WITH TRANS_COUNT BKN00-TCODE.
    PERFORM DUMP_BKN00.
    MESSAGE A013.
  ENDIF.

*------- T020 lesen (1. interne Tabelle, 2. ATAB-TAbelle) --------------
  LOOP AT XT020 WHERE TCODE = BKN00-TCODE.
    EXIT.
  ENDLOOP.
  IF SY-SUBRC NE 0.
    SELECT SINGLE * FROM T020 WHERE TCODE = BKN00-TCODE.
    IF SY-SUBRC = 0.
      XT020 = T020.
      APPEND XT020.
    ELSE.
      MESSAGE I108 WITH TRANS_COUNT BKN00-TCODE.
      PERFORM DUMP_BKN00.
      MESSAGE A013.
    ENDIF.
  ENDIF.
ENDFORM.


*eject
*-----------------------------------------------------------------------
*        BKNA1_ERWEITERUNG_PRUEFEN.
*-----------------------------------------------------------------------
*        Falls der Kunde eine alte BKNA1-Struktur benutzt, werden die
*        neuen Felder mit NODATA initialisiert.
*-----------------------------------------------------------------------
FORM BKNA1_ERWEITERUNG_PRUEFEN.

*------- BKNA1-Erweiterung zu 4.0C: J_1KFREPRE/J_1KFTBUS/J_1KFTIND/ ---
*-------                            NODEL/                         ----
  IF BKNA1-SENDE(1) NE NODATA.

*------- BKNA1-Erweiterung zu 4.0A: FITYP/.../TXLW2 --------------------
    IF BKNA1-J_1KFREPRE(1) NE NODATA.

*------- BKNA1-Erweiterung zu 3.0F: CIVVE/MILVE ------------------------
      IF BKNA1-FITYP(1) NE NODATA.

*------- BKNA1-Erweiterung zu 3.0A: PERIV/KTOCD/DTAMS/DTAWS/PFORT/HZUOR-
        IF BKNA1-CIVVE(1) NE NODATA.

*------- BKNA1-Erweiterung zu 2.1B: KATR1 - KATR10 --------------------
          IF BKNA1-PERIV(1) NE NODATA.

*------- BKNA1-Erweiterung zu 2.0A: TXJCD -----------------------------
            IF BKNA1-KATR1(1) NE NODATA.

*------- BKNA1-Erweiterung zu 1.2A: STKZN, GFORM usw. -----------------
              IF BKNA1-TXJCD(1) NE NODATA.

*------- BKNA1-Erweiterung zu 1.1H: STCEG ------------------------------
                IF BKNA1-STKZN(1) NE NODATA.
                  BKNA1-STCEG(1) = NODATA.
                ENDIF.

                BKNA1-STKZN(1) = NODATA.
                BKNA1-GFORM(1) = NODATA.
                BKNA1-BRAN1(1) = NODATA.
                BKNA1-BRAN2(1) = NODATA.
                BKNA1-BRAN3(1) = NODATA.
                BKNA1-BRAN4(1) = NODATA.
                BKNA1-BRAN5(1) = NODATA.
                BKNA1-UMSA1(1) = NODATA.
                BKNA1-UMJAH(1) = NODATA.
                BKNA1-UWAER(1) = NODATA.
                BKNA1-JMZAH(1) = NODATA.
                BKNA1-JMJAH(1) = NODATA.
              ENDIF.

              BKNA1-TXJCD(1) = NODATA.

            ENDIF.

            BKNA1-KATR1(1) = NODATA.
            BKNA1-KATR2(1) = NODATA.
            BKNA1-KATR3(1) = NODATA.
            BKNA1-KATR4(1) = NODATA.
            BKNA1-KATR5(1) = NODATA.
            BKNA1-KATR6(1) = NODATA.
            BKNA1-KATR7(1) = NODATA.
            BKNA1-KATR8(1) = NODATA.
            BKNA1-KATR9(1) = NODATA.
            BKNA1-KATR10(1) = NODATA.

          ENDIF.

          BKNA1-PERIV(1) = NODATA.
          BKNA1-PFORT(1) = NODATA.
          BKNA1-KTOCD(1) = NODATA.
          BKNA1-DTAMS(1) = NODATA.
          BKNA1-DTAWS(1) = NODATA.
          BKNA1-HZUOR(1) = NODATA.

        ENDIF.

        BKNA1-CIVVE(1) = NODATA.
        BKNA1-MILVE(1) = NODATA.

      ENDIF.

      BKNA1-FITYP(1) = NODATA.
      BKNA1-STCDT(1) = NODATA.
      BKNA1-STCD3(1) = NODATA.
      BKNA1-STCD4(1) = NODATA.
      BKNA1-XICMS(1) = NODATA.
      BKNA1-XXIPI(1) = NODATA.
      BKNA1-XSUBT(1) = NODATA.
      BKNA1-CFOPC(1) = NODATA.
      BKNA1-TXLW1(1) = NODATA.
      BKNA1-TXLW2(1) = NODATA.
      BKNA1-CCC01(1) = NODATA.
      BKNA1-CCC02(1) = NODATA.
      BKNA1-CCC03(1) = NODATA.
      BKNA1-CCC04(1) = NODATA.
      BKNA1-CASSD(1) = NODATA.
      BKNA1-KDKG1(1) = NODATA.
      BKNA1-KDKG2(1) = NODATA.
      BKNA1-KDKG3(1) = NODATA.
      BKNA1-KDKG4(1) = NODATA.
      BKNA1-KDKG5(1) = NODATA.
      BKNA1-KNURL(1) = NODATA.
    ENDIF.
    BKNA1-J_1KFREPRE(1) = NODATA.
    BKNA1-J_1KFTBUS(1) = NODATA.
    BKNA1-J_1KFTIND(1) = NODATA.
    BKNA1-NODEL(1) = NODATA.

    IF XMESS_BKNA1-SENDE NE 'X'.
      MESSAGE I133 WITH TRANS_COUNT 'BKNA1' NODATA.
      MESSAGE I023 WITH 'BKNA1'.
      MESSAGE I024.
      MESSAGE I025 WITH 'BKNA1'.
      XMESS_BKNA1-SENDE = 'X'.
    ENDIF.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        BKNB1_ERWEITERUNG_PRUEFEN.
*-----------------------------------------------------------------------
*        Falls der Kunde eine alte BKNB1-Struktur benutzt, werden die
*        neuen Felder mit NODATA initialisiert.
*-----------------------------------------------------------------------
FORM BKNB1_ERWEITERUNG_PRUEFEN.
*------- BKNB1-Erweiterung zu 4.6A: TLFNS/CESSION_KZ             -------
  IF BKNB1-SENDE(1) NE NODATA.
*------- BKNB1-Erweiterung zu 4.0C: WBRSL/NODEL       -------
    IF BKNB1-TLFNS(1) NE NODATA.
*------- BKNB1-Erweiterung zu 4.0A: GUZTE/GRICD/GRIDT -------
      IF BKNB1-WBRSL(1) NE NODATA.
*------- BKNB1-Erweiterung zu 3.0E: INTAD(130)        ------
        IF BKNB1-GUZTE(1) NE NODATA.
*------- BKNB1-Erweiterung zu 3.0D: PERNR(8) TLFXS(31)        ------
          IF BKNB1-INTAD(1) NE NODATA.
*------- BKNB1-Erweiterung zu 3.0A: EKVBD/SREGL/XEDIP/FRGRP/VRSDG ------
            IF BKNB1-PERNR(1) NE NODATA.
*------- BKNB1-Erweiterung zu 2.2A: LOCKB(7) UZAWE(2)-------------------
              IF BKNB1-EKVBD(1) NE NODATA.
*------- BKNB1-Erweiterung zu 2.1A: URLID(4) MGRUP(2)-------------------
                IF BKNB1-LOCKB(1) NE NODATA.
*------- BKNB1-Erweiterung zu 1.3A: ZGRUP(2) ---------------------------
                  IF BKNB1-URLID(1) NE NODATA.

*------- BKNB1-Erweiterung zu 1.2A: ALTKN(10) --------------------------
                    IF BKNB1-ZGRUP(1) NE NODATA.
                      BKNB1-ALTKN(1) = NODATA.
                    ENDIF.

                    BKNB1-ZGRUP(1) = NODATA.
                  ENDIF.

                  BKNB1-URLID(1) = NODATA.
                  BKNB1-MGRUP(1) = NODATA.
                ENDIF.

                BKNB1-LOCKB(1) = NODATA.
                BKNB1-UZAWE(1) = NODATA.
              ENDIF.

              BKNB1-EKVBD(1) = NODATA.
              BKNB1-SREGL(1) = NODATA.
              BKNB1-XEDIP(1) = NODATA.
              BKNB1-FRGRP(1) = NODATA.
              BKNB1-VRSDG(1) = NODATA.

            ENDIF.

            BKNB1-PERNR(1) = NODATA.
            BKNB1-TLFXS(1) = NODATA.
          ENDIF.
          BKNB1-INTAD(1) = NODATA.
        ENDIF.
        BKNB1-GUZTE(1) = NODATA.
        BKNB1-GRICD(1) = NODATA.
        BKNB1-GRIDT(1) = NODATA.
      ENDIF.
      BKNB1-WBRSL(1) = NODATA.
      BKNB1-NODEL(1) = NODATA.
    ENDIF.
    BKNB1-TLFNS(1) = NODATA.
    BKNB1-cession_kz(1) = NODATA.

    IF XMESS_BKNB1-SENDE NE 'X'.
      MESSAGE I133 WITH TRANS_COUNT 'BKNB1' NODATA.
      MESSAGE I023 WITH 'BKNB1'.
      MESSAGE I024.
      MESSAGE I025 WITH 'BKNB1'.
      XMESS_BKNB1-SENDE = 'X'.
    ENDIF.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        BKNBK_ERWEITERUNG_PRUEFEN.
*-----------------------------------------------------------------------
*        Falls der Kunde eine alte BKNBK-Struktur benutzt, werden die
*        neuen Felder mit NODATA initialisiert.
*-----------------------------------------------------------------------
FORM BKNBK_ERWEITERUNG_PRUEFEN.

*------- BKNBK-Erweiterung zu 4.0A: KOINH(35) --------------------------
  IF XBKNBK-SENDE(1) NE NODATA.
*------- PROVZ-Erweiterung zu 3.0D: PROVZ(3) --------------------------
    IF XBKNBK-KOINH(1) NE NODATA.
*------- BKNBK-Erweiterung zu 2.2A: BKREF(20),BRNCH(40) ----------------
      IF XBKNBK-PROVZ(1) NE NODATA.
*------- BKNBK-Erweiterung zu 2.1A: PSKTO(16) --------------------------
        IF XBKNBK-BKREF(1) NE NODATA.

*------- BKNBK-Erweiterung zu 1.3A: BNKLZ(15) --------------------------
          IF XBKNBK-PSKTO(1) NE NODATA.
            XBKNBK-BNKLZ(1) = NODATA.
          ENDIF.

          XBKNBK-PSKTO(1) = NODATA.
        ENDIF.

        XBKNBK-BKREF(1) = NODATA.
        XBKNBK-BRNCH(1) = NODATA.
      ENDIF.
      XBKNBK-PROVZ(1) = NODATA.
    ENDIF.
    XBKNBK-KOINH(1) = NODATA.

    IF XMESS_BKNBK-SENDE NE 'X'.
      MESSAGE I133 WITH TRANS_COUNT 'BKNBK' NODATA.
      MESSAGE I023 WITH 'BKNBK'.
      MESSAGE I024.
      MESSAGE I025 WITH 'BKNBK'.
      XMESS_BKNBK-SENDE = 'X'.
    ENDIF.
  ENDIF.

ENDFORM.


*eject
*-----------------------------------------------------------------------
*        BKNKK_ERWEITERUNG_PRUEFEN.
*-----------------------------------------------------------------------
*        Falls der Kunde eine alte BKNKK-Struktur benutzt, werden die
*        neuen Felder mit NODATA initialisiert.
*-----------------------------------------------------------------------
FORM BKNKK_ERWEITERUNG_PRUEFEN.
*------- BKNKK-Erweiterung zu 3.0A: DBPAY(3), DBRTG(5), DBEKR(20),
*-------                            DBWAE(5), DBMON(8)
  IF BKNKK-SENDE(1) NE NODATA.
*------- BKNKK-Erweiterung zu 2.2A: GRUPP(4), SBDAT(8), KDGRP(8) -------
    IF BKNKK-DBPAY(1) NE NODATA.
*------- BKNKK-Erweiterung zu 1.3A: Überarbeitung Kreditlimit ----------
      IF BKNKK-GRUPP(1) NE NODATA.

        BKNKK-CTLPC(1) = NODATA.
        BKNKK-DTREV(1) = NODATA.
        BKNKK-CRBLB(1) = NODATA.
        BKNKK-SBGRP(1) = NODATA.
        BKNKK-NXTRV(1) = NODATA.
        BKNKK-KRAUS(1) = NODATA.
        BKNKK-PAYDB(1) = NODATA.
        BKNKK-DBRAT(1) = NODATA.
        BKNKK-REVDB(1) = NODATA.
      ENDIF.

      BKNKK-GRUPP(1) = NODATA.
      BKNKK-SBDAT(1) = NODATA.
      BKNKK-KDGRP(1) = NODATA.
    ENDIF.

    BKNKK-DBPAY(1) = NODATA.
    BKNKK-DBRTG(1) = NODATA.
    BKNKK-DBEKR(1) = NODATA.
    BKNKK-DBWAE(1) = NODATA.
    BKNKK-DBMON(1) = NODATA.

    IF XMESS_BKNKK-SENDE NE 'X'.
      MESSAGE I133 WITH TRANS_COUNT 'BKNKK' NODATA.
      MESSAGE I023 WITH 'BKNKK'.
      MESSAGE I024.
      MESSAGE I025 WITH 'BKNKK'.
      XMESS_BKNKK-SENDE = 'X'.
    ENDIF.
  ENDIF.
ENDFORM.


*eject
*-----------------------------------------------------------------------
*        Form  BNKA_BEARBEITEN
*-----------------------------------------------------------------------
*        Bankanschrift prüfen/übertragen
*        Es können nur neue Einträge in BNKA hinzugefügt werden.
*        Existierende Einträge können nicht geändert werden.
*-----------------------------------------------------------------------
FORM BNKA_BEARBEITEN.

*------- Wurden BNKA-Daten übergeben ----------------------------------
  CHECK XBKNBK-BANKA(1) NE NODATA
  OR    XBKNBK-PROVZ(1) NE NODATA
  OR    XBKNBK-STRAS(1) NE NODATA
  OR    XBKNBK-ORT01(1) NE NODATA
  OR    XBKNBK-SWIFT(1) NE NODATA
  OR    XBKNBK-BGRUP(1) NE NODATA
  OR    XBKNBK-XPGRO(1) NE NODATA
  OR    XBKNBK-BNKLZ(1) NE NODATA.

*------- Delete-Flag gesetzt? -----------------------------------------
  IF XBKNBK-XDELE EQ 'X'.
    MESSAGE I120 WITH TRANS_COUNT
                      XBKNBK-BANKS XBKNBK-BANKL XBKNBK-BANKN.
    MESSAGE I115.
    MESSAGE I116.
    PERFORM DUMP_BKN00.
    PERFORM DUMP_BKNBK.
    EXIT.
  ENDIF.

*------- T005 lesen ---------------------------------------------------
  IF XBKNBK-BANKS(1) = NODATA
  OR XBKNBK-BANKS    = SPACE.
    MESSAGE I120 WITH TRANS_COUNT
                      XBKNBK-BANKS XBKNBK-BANKL XBKNBK-BANKN.
    MESSAGE I118.
    MESSAGE I116.
    PERFORM DUMP_BKN00.
    PERFORM DUMP_BKNBK.
    EXIT.
  ENDIF.

*------- T005 lesen (1. interne Tabelle, 2. ATAB-TAbelle) --------------
  LOOP AT XT005 WHERE LAND1 = XBKNBK-BANKS.
    EXIT.
  ENDLOOP.
  IF SY-SUBRC NE 0.
    SELECT SINGLE * FROM T005 WHERE LAND1 = XBKNBK-BANKS.
    IF SY-SUBRC = 0.
      XT005 = T005.
      APPEND XT005.
    ELSE.
      MESSAGE I120 WITH TRANS_COUNT
                        XBKNBK-BANKS XBKNBK-BANKL XBKNBK-BANKN.
      MESSAGE I119 WITH XBKNBK-BANKS.
      MESSAGE I116.
      PERFORM DUMP_BKN00.
      PERFORM DUMP_BKNBK.
      EXIT.
    ENDIF.
  ENDIF.

*------- BANK_KEY ermitteln -------------------------------------------
  CLEAR BANK_KEY.
  IF XT005-BNKEY = '2'.
    BANK_KEY = XBKNBK-BANKN.
  ELSE.
    BANK_KEY = XBKNBK-BANKL.
  ENDIF.

*------- Existiert die Bank schon in BNKA? ----------------------------
  IF BANK_KEY NE SPACE.
    SELECT SINGLE * FROM BNKA WHERE BANKS = XBKNBK-BANKS
                              AND   BANKL = BANK_KEY.
    IF SY-SUBRC = 0.
      MESSAGE I120 WITH TRANS_COUNT
                        XBKNBK-BANKS XBKNBK-BANKL XBKNBK-BANKN.
      MESSAGE I117 WITH XBKNBK-BANKS BANK_KEY.
      MESSAGE I124 WITH XBKNBK-BANKA.
      MESSAGE I116.
      EXIT.
    ENDIF.
  ENDIF.

*------- neue Bankanschrift übertragen --------------------------------
  PERFORM OKCODE_BANK.
  PERFORM DYNPRO_FUELLEN USING 'B100'.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  XDYTR = 'X'.
ENDFORM.

*begin of j_1a
*eject
*-----------------------------------------------------------------------
*        Form  KNAT_BEARBEITEN
*-----------------------------------------------------------------------
*        Steuekategorien prüfen/übertragen
*-----------------------------------------------------------------------
FORM KNAT_BEARBEITEN.
  CHECK XBKNAT-TAXGR(1) NE NODATA.

*------- T005 lesen -------------------------------------------
  IF XBKNAT-TAXGR(1) = NODATA
  OR XBKNAT-TAXGR    = SPACE.
    MESSAGE I051(8A) WITH TRANS_COUNT XBKNAT-TAXGR.
    MESSAGE I052(8A).
    PERFORM DUMP_BKN00.
    PERFORM DUMP_BKNAT.
    EXIT.
  ENDIF.

* check, if group is existing
  READ TABLE XT007C WITH KEY KOART = 'D'
                             TAXGR = XBKNAT-TAXGR.

  IF SY-SUBRC NE 0.
    SELECT SINGLE * FROM T007C WHERE KOART = 'D'
                               AND   TAXGR = XBKNAT-TAXGR.
    IF SY-SUBRC = 0.
      XT007C = T007C.
      APPEND XT007C.
    ELSE.
      MESSAGE I051(8A) WITH TRANS_COUNT XBKNAT-TAXGR.
      MESSAGE I053(8A).
      PERFORM DUMP_BKN00.
      PERFORM DUMP_BKNAT.
      EXIT.
    ENDIF.
  ENDIF.
ENDFORM.
*end of j_1a

*eject
*&---------------------------------------------------------------------*
*&      Form  KNBW_BEARBEITEN
*&---------------------------------------------------------------------*
*    Quellensteuertypen prüfen
*----------------------------------------------------------------------*
FORM KNBW_BEARBEITEN.

  CHECK XBKNBW-WITHT(1) NE NODATA.

  IF XBKNBW-WITHT(1) = NODATA
  OR XBKNBW-WITHT    = SPACE.
    MESSAGE I135 WITH TRANS_COUNT XBKNBW-WITHT.
    MESSAGE I136.
    PERFORM DUMP_BKN00.
    PERFORM DUMP_BKNBW.
    EXIT.
  ENDIF.

  READ TABLE XT059P WITH KEY LAND1 = T001-LAND1
                             WITHT = XBKNBW-WITHT.

  IF SY-SUBRC NE 0.
    SELECT SINGLE * FROM T059P WHERE LAND1 = T001-LAND1
                               AND   WITHT = XBKNBW-WITHT.
    IF SY-SUBRC = 0.
      XT059P = T059P.
      APPEND XT059P.
    ELSE.
      MESSAGE I135 WITH TRANS_COUNT XBKNBW-WITHT.
      MESSAGE I137.
      PERFORM DUMP_BKN00.
      PERFORM DUMP_BKNBW.
      EXIT.
    ENDIF.
  ENDIF.

ENDFORM.                               " KNBW_BEARBEITEN

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0130
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Bankverbindungen auf Dynpro 0130.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0130.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNBK-BANKS(1)'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0324
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Partnerrollen auf Dynpro 0324.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0324.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNVP-PARVW(1)'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0326
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Nachrichten auf Dynpro 0326.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0326.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNVD-DOCTP(1)'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0340
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Abladestellen auf Dynpro 0340.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0340.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNVA-ABLAD(1)'.
  APPEND FT.
ENDFORM.

*mi/46a begin
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0420
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Empfangstellen auf Dynpro 0420.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0420.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'WRF12-EMPST(1)'.
  APPEND FT.
ENDFORM.

*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0410
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Abteilungen auf Dynpro 0410.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0410.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'WRF4-ABTNR(1)'.
  APPEND FT.
ENDFORM.
*mi/46a end

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0360
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Ansprechpartner auf Dynpro 0360.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0360.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNVK-NAME1(1)'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0370
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Außenhandelsdaten auf Dynpro 0370.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0370.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNEX-LNDEX(1)'.
  APPEND FT.
ENDFORM.

*begin of j_1a
*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0600
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Steuekategorien auf Dynpro 0600.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0600.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNAT-TAXGR(1)'.
  APPEND FT.
ENDFORM.
*end of j_1a

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_0610
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Quellensteuer auf Dynpro 0610.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_0610.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNBW-WITHT(1)'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_1130
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der abw. Regulierer auf Dynpro 1130.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_1130.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNZA-EMPFD(1)'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_1350
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Steuern auf Dynpro 1350.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_1350.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNVI-TAXKD(1)'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  CURSOR_SETZEN_1355
*-----------------------------------------------------------------------
*        In Loop-Verarbeitung Cursor auf Zeile 1 positionieren.
*        Verarbeitung der Lizenzen auf Dynpro 1355.
*-----------------------------------------------------------------------
FORM CURSOR_SETZEN_1355.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_CURSOR'.
  FT-FVAL = 'KNVL-LICNR(1)'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DATEN_UREBERTRAGUNG
*-----------------------------------------------------------------------
*        Verarbeiten der eingelesenen Debitordaten.
*        Füllen und Ausgeben der Dynpros.
*-----------------------------------------------------------------------
FORM DATEN_UEBERTRAGUNG.

*------- BDC-Tabelle für neue Transaktion initialisieren --------------
  REFRESH FT.


* begin P30K113875
  CLEAR: SPERRE_GESETZT,
         LOESCH_GESETZT.
* end P30K113875

*------- Abw. Regulierer verteilen --------------------------
  DESCRIBE TABLE XBKNZA LINES REFE1.
  IF REFE1 GT 0.
    PERFORM XBKNZA_SPLIT.
  ENDIF.

*------- Nicht zu bearbeitende Bilder aus DYNTAB entfernen (FD32) ------
  IF  BKN00-TCODE  EQ 'FD32'
  AND BKNKA        EQ I_BKNKA.
*mi/46a begin
    DELETE DYNTAB WHERE DYNNR = 'L120'.
*   LOOP AT dyntab WHERE dynnr = 'L120'.
*     DELETE dyntab.
*   ENDLOOP.
*mi/46a end
  ENDIF.

*------- Nicht zu bearbeitende Bilder aus DYNTAB entfernen (XD02) ------
*        'Ansprechpartner' (0360)
  DESCRIBE TABLE XBKNVK LINES REFE1.
  IF ( BKN00-TCODE  EQ 'XD02' AND REFE1 EQ 0 )
  OR ( BKN00-KTOKD  =  '0170' OR  KNA1-DEAR6 = 'X' ).    "ms Konsument
*mi/46a begin
    DELETE DYNTAB WHERE DYNNR = '0360'.
*   LOOP AT dyntab WHERE dynnr = '0360'.
*     DELETE dyntab.
*   ENDLOOP.
*mi/46a end
  ENDIF.

*       'Nachrichten' (0326)
* Das Dynpro wird nur dann prozessiert, falls der Kontengruppe ein
* Nachrichtenschema zugeordnet ist.
* Das Dynpro wird nicht prozessiert, falls CHAR1 angekreuzt.
  DESCRIBE TABLE XBKNVD LINES REFE1.
  IF REFE1 EQ 0.
    CLEAR CHAR1.
* Debitor anlegen
    IF BKN00-KTOKD NE SPACE AND BKN00-KTOKD NE NODATA.
      SELECT SINGLE * FROM T077D WHERE KTOKD EQ BKN00-KTOKD
                                 AND   KALSM NE SPACE.
      IF SY-SUBRC NE 0.
        CHAR1 = 'X'.
      ENDIF.
    ELSE.
* Debitor aendern
* Falls KNA1 noch nicht gefüllt ist, so wird es jetzt gemacht
      IF KNA1-KTOKD EQ SPACE.
        CALL FUNCTION 'V_KNA1_SINGLE_READ'
             EXPORTING
                  PI_KUNNR         = KUNNR
             IMPORTING
                  PE_KNA1          = KNA1
             EXCEPTIONS
                  NO_RECORDS_FOUND = 1
                  OTHERS           = 2.
      ENDIF.
* das aktuelle KNA1 abfragen
      IF KNA1-KTOKD NE SPACE.
        SELECT SINGLE * FROM T077D WHERE KTOKD EQ KNA1-KTOKD
                                   AND   KALSM NE SPACE.
        IF SY-SUBRC NE 0.
          CHAR1 = 'X'.
        ENDIF.
      ELSE.
        CHAR1 = 'X'.
      ENDIF.
    ENDIF.
    IF  CHAR1 EQ 'X'.
      LOOP AT DYNTAB WHERE DYNNR = '0326'.
        DELETE DYNTAB.
      ENDLOOP.
    ENDIF.
  ENDIF.

*------- Anzahl Bilder in DYNTAB ---------------------------------------
  DESCRIBE TABLE DYNTAB LINES DYN_COUNT.

*------- Einstiegsbild ermitteln ---------------------------------------
  CASE XT020-AKTYP.
    WHEN 'H'.
      PERFORM D0100_FUELLEN.           " Anl. Debitor
    WHEN 'V'.
      CASE XT020-FUNCL.
        WHEN SPACE.
          CASE XT020-DYNCL.
            WHEN 'C'.
              PERFORM DL100_FUELLEN.   " Pfleg. Kreditlimit
            WHEN OTHERS.
              PERFORM D0101_FUELLEN.   " Änd. Debitor
          ENDCASE.
        WHEN 'S'.
          PERFORM D0500_FUELLEN.       " Änd. Debitor Sperre
        WHEN 'L'.
          PERFORM D0500_FUELLEN.       " Änd. Debitor Lövm.
      ENDCASE.
  ENDCASE.

*------- Datenbilder bearbeiten ----------------------------------------
  CLEAR: KNA1_ZUDA, KNVV_ZUDA.
  LOOP AT DYNTAB.
    TABIX = SY-TABIX.
    IF DYNTAB-XLIST = SPACE.
      PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
      IF DYNTAB-DYNNR = '0125'.
        PERFORM D0125_BRANCHENCODES.
      ENDIF.

*------- neu zu 2.1B: Zusatzdaten übergeben (nur einmal) ---------------
      IF  DYNTAB-DTYPE = 'A'
      AND KNA1_ZUDA    = SPACE.
        PERFORM KNA1_ZUSATZDATEN.
      ENDIF.
      IF  DYNTAB-DTYPE = 'V'
      AND KNVV_ZUDA    = SPACE.
        PERFORM KNVV_ZUSATZDATEN.
      ENDIF.
* begin of j_1a
* Zusatzdaten Steuerkategorien aufrufen
      IF FL_CHECK     = SPACE AND
         DYNTAB-DYNNR = '0120'.
        DESCRIBE TABLE XBKNAT LINES SY-TFILL.
        IF SY-TFILL > 0.
          PERFORM D0600_VERARBEITUNG.
        ENDIF.
      ENDIF.
* end of j_1a
* Popup m. den BuKr-abhg. abw. Regulierer aus Dynpro 0215 aufrufen
      IF DYNTAB-DYNNR = '0215'.
        DESCRIBE TABLE XBKNZAB LINES REFE1.
        IF REFE1 > 0.
          PERFORM KNZA_VERARBEITUNG.
        ENDIF.
      ENDIF.
    ELSE.
      CASE DYNTAB-DYNNR.
        WHEN '0130'.
          PERFORM D0130_VERARBEITUNG.
        WHEN '1350'.
          PERFORM D1350_VERARBEITUNG.
        WHEN '0324'.
          PERFORM D0324_VERARBEITUNG.
        WHEN '0326'.
          PERFORM D0326_VERARBEITUNG.
        WHEN '0340'.
          PERFORM D0340_VERARBEITUNG.
        WHEN '0370'.
          PERFORM D0370_VERARBEITUNG.
        WHEN '0360'.
          PERFORM D0360_VERARBEITUNG.
        WHEN '0610'.                   "erweiterte Quellensteuer
          IF T001-WT_NEWWT = 'X'.      "Quellensteuer aktiv
            PERFORM D0610_VERARBEITUNG.
          ENDIF.
      ENDCASE.
    ENDIF.

* begin P30K113875
*------- Sind Sperrdaten oder Löschvormerkungen zu übertragen ? --------
*   if  tabix       eq  1            "P30K113875
*   and xt020-funcl ne 'S'           "P30K113875
    IF XT020-FUNCL NE 'S'                                   "P30K113875
    AND XT020-FUNCL NE 'L'
    AND XT020-DYNCL NE 'C'.
* end P30K113875
      PERFORM FUNKTION_SPERRDATEN.
      PERFORM FUNKTION_LOESCHVORMERKUNGEN.
    ENDIF.

*------- Sichern auf letztem Bild und Daten an QUEUE abeben ------------
    IF TABIX = DYN_COUNT.
      PERFORM OKCODE_F11.
      PERFORM TRANSAKTION_SENDEN.
      CLEAR SATZ2_COUNT.
    ENDIF.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_WA
*-----------------------------------------------------------------------
*        Im Abbruchfall soll der fehlerhafte Satz ausgedumpt werden.
*-----------------------------------------------------------------------
FORM DUMP_WA USING TABLE.
  CALL FUNCTION 'NAMETAB_GET'
       EXPORTING
            LANGU          = SY-LANGU
            TABNAME        = TABLE
       TABLES
            NAMETAB        = NAMETAB
       EXCEPTIONS
            NO_TEXTS_FOUND = 1.
  LOOP AT NAMETAB.
    CLEAR CHAR.
    CHAR(5)    = NAMETAB-TABNAME.
    CHAR+5(1)  = '-'.
    CHAR+6(10) = NAMETAB-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKN00
*-----------------------------------------------------------------------
*        BKN00 ausdumpen.
*-----------------------------------------------------------------------
FORM DUMP_BKN00.
  DESCRIBE TABLE NAMETAB_BKN00 LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKN00'
         TABLES
              NAMETAB        = NAMETAB_BKN00
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I016.
  LOOP AT NAMETAB_BKN00.
    CLEAR CHAR.
    CHAR(5)    = NAMETAB_BKN00-TABNAME.
    CHAR+5(1)  = '-'.
    CHAR+6(10) = NAMETAB_BKN00-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*begin of j_1a
*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNAT
*-----------------------------------------------------------------------
*        BLFAT ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNAT.
  DESCRIBE TABLE NAMETAB_BKNAT LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNAT'
         TABLES
              NAMETAB        = NAMETAB_BKNAT
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNAT.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNAT-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNAT-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.
*end of j_1a

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNBK
*-----------------------------------------------------------------------
*        BKNBK ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNBK.
  DESCRIBE TABLE NAMETAB_BKNBK LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNBK'
         TABLES
              NAMETAB        = NAMETAB_BKNBK
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNBK.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNBK-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNBK-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DUMP_BKNBW
*&---------------------------------------------------------------------*
*   BKNBW ausgeben
*----------------------------------------------------------------------*
FORM DUMP_BKNBW.
  DESCRIBE TABLE NAMETAB_BKNBW LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNBW'
         TABLES
              NAMETAB        = NAMETAB_BKNBW
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNBW.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNBW-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNBW-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.

ENDFORM.                               " DUMP_BKNBW

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNEX
*-----------------------------------------------------------------------
*        BKNEX ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNEX.
  DESCRIBE TABLE NAMETAB_BKNEX LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNEX'
         TABLES
              NAMETAB        = NAMETAB_BKNEX
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNEX.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNEX-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNEX-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNVA
*-----------------------------------------------------------------------
*        BKNVA ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNVA.
  DESCRIBE TABLE NAMETAB_BKNVA LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNVA'
         TABLES
              NAMETAB        = NAMETAB_BKNVA
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNVA.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNVA-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNVA-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNVD
*-----------------------------------------------------------------------
*        BKNVD ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNVD.
  DESCRIBE TABLE NAMETAB_BKNVD LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNVD'
         TABLES
              NAMETAB        = NAMETAB_BKNVD
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNVD.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNVD-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNVD-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNVI
*-----------------------------------------------------------------------
*        BKNVI ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNVI.
  DESCRIBE TABLE NAMETAB_BKNVI LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNVI'
         TABLES
              NAMETAB        = NAMETAB_BKNVI
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNVI.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNVI-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNVI-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNVK
*-----------------------------------------------------------------------
*        BKNVK ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNVK.
  DESCRIBE TABLE NAMETAB_BKNVK LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNVK'
         TABLES
              NAMETAB        = NAMETAB_BKNVK
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNVK.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNVK-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNVK-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNVL
*-----------------------------------------------------------------------
*        BKNVL ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNVL.
  DESCRIBE TABLE NAMETAB_BKNVL LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNVL'
         TABLES
              NAMETAB        = NAMETAB_BKNVL
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNVL.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNVL-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNVL-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNVP
*-----------------------------------------------------------------------
*        BKNVP ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNVP.
  DESCRIBE TABLE NAMETAB_BKNVP LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNVP'
         TABLES
              NAMETAB        = NAMETAB_BKNVP
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNVP.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNVP-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNVP-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DUMP_BKNZA
*-----------------------------------------------------------------------
*        BKNZA ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BKNZA.
  DESCRIBE TABLE NAMETAB_BKNZA LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BKNZA'
         TABLES
              NAMETAB        = NAMETAB_BKNZA
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BKNZA.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BKNZA-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BKNZA-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*mi/46a begin
*-----------------------------------------------------------------------
*        Form  DUMP_BWRF12
*-----------------------------------------------------------------------
*        BWRF12 ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BWRF12.
  DESCRIBE TABLE NAMETAB_BWRF12 LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BWRF12'
         TABLES
              NAMETAB        = NAMETAB_BWRF12
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BWRF12.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BWRF12-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BWRF12-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.

*-----------------------------------------------------------------------
*        Form  DUMP_BWRF4
*-----------------------------------------------------------------------
*        BWRF4 ausgeben.
*-----------------------------------------------------------------------
FORM DUMP_BWRF4.
  DESCRIBE TABLE NAMETAB_BWRF4 LINES SY-TFILL.
  IF SY-TFILL = 0.
    CALL FUNCTION 'NAMETAB_GET'
         EXPORTING
              LANGU          = SY-LANGU
              TABNAME        = 'BWRF4'
         TABLES
              NAMETAB        = NAMETAB_BWRF4
         EXCEPTIONS
              NO_TEXTS_FOUND = 1.
  ENDIF.

  MESSAGE I017.
  LOOP AT NAMETAB_BWRF4.
    CLEAR CHAR.
    CHAR(1)    = 'X'.
    CHAR+1(5)  = NAMETAB_BWRF4-TABNAME.
    CHAR+6(1)  = '-'.
    CHAR+7(10) = NAMETAB_BWRF4-FIELDNAME.
    ASSIGN (CHAR) TO <F1>.
    SHIFT CHAR.
    WERT = <F1>.
    MESSAGE I014 WITH CHAR WERT.
  ENDLOOP.
ENDFORM.
*mi/46a end

*eject
*-----------------------------------------------------------------------
*        Form  D0100_FUELLEN
*-----------------------------------------------------------------------
*        Batchinput-Daten für Anlegen-Einstiegsbild übertragen
*        Wegen SPA/GPA-Parametern, müssen auf dem Einstiegsbild die
*        Felder mit Space übergeben werden, falls sie nicht
*        explizit gefüllt wurden.
*-----------------------------------------------------------------------
FORM D0100_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '0100'.
  PERFORM KEY_FELDER_FUELLEN.

*------- Ansprechpartner für Konsument angeben -------------------------
  if BKN00-KTOKD = '0170' OR KNA1-DEAR6 = 'X'.
    IF XBKNVK-PARNR(1)                    NE NODATA.
      CLEAR FT.
      FT-FNAM = 'KNVK-PARNR'.
      FT-FVAL = XBKNVK-PARNR.
      APPEND FT.
    endif.
  endif.

*------- Keys des Vorlagestammsatzes clearen ---------------------------
  CLEAR FT.
  FT-FNAM = 'RF02D-REF_KUNNR'.
  FT-FVAL = SPACE.
  APPEND FT.
  CLEAR FT.
  FT-FNAM = 'RF02D-REF_BUKRS'.
  FT-FVAL = SPACE.
  APPEND FT.
  CLEAR FT.
  FT-FNAM = 'RF02D-REF_VKORG'.
  FT-FVAL = SPACE.
  APPEND FT.
  CLEAR FT.
  FT-FNAM = 'RF02D-REF_VTWEG'.
  FT-FVAL = SPACE.
  APPEND FT.
  CLEAR FT.
  FT-FNAM = 'RF02D-REF_SPART'.
  FT-FVAL = SPACE.
  APPEND FT.

  CLEAR FT.
  FT-FNAM = 'RF02D-KTOKD'.
  IF BKN00-KTOKD(1) NE NODATA.
    FT-FVAL =  BKN00-KTOKD.
  ELSE.
    FT-FVAL =  SPACE.
  ENDIF.
  APPEND FT.

*ZAV: Pflege des Flags 'ZAV verwenden'.
  PERFORM ZAV_VERWENDUNGSFLAG_SETZEN.

ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D0101_FUELLEN
*-----------------------------------------------------------------------
*        Batchinput-Daten für Ändern-Einstiegsbild übertragen 0101
*-----------------------------------------------------------------------
FORM D0101_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '0101'.
  PERFORM KEY_FELDER_FUELLEN.

*------- zu bearbeitende Bilder auf Einstiegsbild ankreuzen ------------
  LOOP AT DYNTAB WHERE DYNNR NE '1350'.
    CLEAR FT.
    FT-FNAM(7)   = 'RF02D-D'.
    FT-FNAM+7(4) =  DYNTAB-DYNNR.
    FT-FVAL      = 'X'.
* ZAV: es wird zwar mit Dynpro 0111 gearbeitet; Feld auf Einstiegsbild
*      heißt aber RF02D-D0110
    IF NOT ZAV_FLAG IS INITIAL.
      IF DYNTAB-DYNNR = '0111' OR DYNTAB-DYNNR = '0112'.
        FT-FNAM+7(4) =  '0110'.
      ENDIF.
    ENDIF.
* ZAV Ende
    APPEND FT.
  ENDLOOP.

*ZAV: Pflege des Flags 'ZAV verwenden'.
  PERFORM ZAV_VERWENDUNGSFLAG_SETZEN.

ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D0500_FUELLEN
*-----------------------------------------------------------------------
*        Batchinput-Daten für Sperren/Loevm-Einstiegsbild übertragen
*-----------------------------------------------------------------------
FORM D0500_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '0500'.
  PERFORM KEY_FELDER_FUELLEN.
ENDFORM.

*begin of j_1a
*eject
*-----------------------------------------------------------------------
*        Form  D0600_FUELLEN
*-----------------------------------------------------------------------
*        Batchinput-Daten für Steuerkategorien übertragen
*-----------------------------------------------------------------------
FORM D0600_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '0600'.

  IF XBKNAT-TAXGR(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNAT-TAXGR                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNAT-TAXGR.
    APPEND FT.
  ENDIF.
  IF XBKNAT-SBJDF(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNAT-SBJDF                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNAT-SBJDF.
    APPEND FT.
  ENDIF.
  IF XBKNAT-SBJDT(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNAT-SBJDT                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNAT-SBJDT.
    APPEND FT.
  ENDIF.
  IF XBKNAT-EXNR(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNAT-EXNR                     '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNAT-EXNR.
    APPEND FT.
  ENDIF.
  IF XBKNAT-EXRT(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNAT-EXRT                     '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNAT-EXRT.
    APPEND FT.
  ENDIF.
  IF XBKNAT-EXDF(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNAT-EXDF                     '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNAT-EXDF.
    APPEND FT.
  ENDIF.
  IF XBKNAT-EXDT(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNAT-EXDT                     '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNAT-EXDT.
    APPEND FT.
  ENDIF.
ENDFORM.
*end of j_1a

*eject
*-----------------------------------------------------------------------
*        Form  DL100_FUELLEN
*-----------------------------------------------------------------------
*        Kreditlimit FD32 Einstiegsbild
*-----------------------------------------------------------------------
FORM DL100_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_L '0100'.

  CLEAR FT.
  FT-FNAM = 'RF02L-KUNNR'.
  IF BKN00-KUNNR(1) NE NODATA.
    FT-FVAL = BKN00-KUNNR.
  ELSE.
    FT-FVAL = SPACE.
  ENDIF.
  APPEND FT.

  CLEAR FT.
  FT-FNAM = 'RF02L-KKBER'.
  IF BKN00-KKBER(1) NE NODATA.
    FT-FVAL = BKN00-KKBER.
  ELSE.
    FT-FVAL = SPACE.
  ENDIF.
  APPEND FT.

*------- zu bearbeitende Bilder auf Einstiegsbild ankreuzen ------------
  LOOP AT DYNTAB.
    CLEAR FT.
    FT-FNAM(8)   = 'RF02L-D0'.
    FT-FNAM+8(3) =  DYNTAB-DYNNR+1(3).
    FT-FVAL      = 'X'.
    APPEND FT.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D0125_BRANCHENCODES
*-----------------------------------------------------------------------
*        Branchencodes 2-5 übertragen (D0125)
*-----------------------------------------------------------------------
FORM D0125_BRANCHENCODES.

*------- Wurden Branchencodes 2-5 übergeben ? -------------------------
  CHECK BKNA1-BRAN2(1) NE NODATA
  OR    BKNA1-BRAN3(1) NE NODATA
  OR    BKNA1-BRAN4(1) NE NODATA
  OR    BKNA1-BRAN5(1) NE NODATA.

*------- Branchencodes übertragen -------------------------------------
  PERFORM OKCODE_F16.
  PERFORM DYNPRO_FUELLEN USING '1250'.
* perform okcode_f03.                      "S11K144454/3.0
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D2130_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Bankverbindungen
*-----------------------------------------------------------------------
FORM D2130_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2130'.
  IF XBKNBK-BANKS(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BANKS'.
    FT-FVAL = XBKNBK-BANKS.
    APPEND FT.
  ENDIF.
  IF XBKNBK-BANKL(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BANKL'.
    FT-FVAL = XBKNBK-BANKL.
    APPEND FT.
  ENDIF.
  IF XBKNBK-BANKN(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BANKN'.
    FT-FVAL = XBKNBK-BANKN.
    APPEND FT.
  ENDIF.
ENDFORM.

*begin of j_1a
*eject
*-----------------------------------------------------------------------
*        Form  D2600_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Steuerkategorien
*-----------------------------------------------------------------------
FORM D2600_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2600'.
  IF XBKNAT-TAXGR(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNAT-TAXGR'.
    FT-FVAL = XBKNAT-TAXGR.
    APPEND FT.
  ENDIF.
ENDFORM.
*end of j_1a

*eject
*-----------------------------------------------------------------------
*        Form  D2610_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Quellensteuer
*-----------------------------------------------------------------------
FORM D2610_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2610'.
  IF XBKNBW-WITHT(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBW-WITHT'.
    FT-FVAL = XBKNBW-WITHT.
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form D0130_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0130_VERARBEITUNG.
  CLEAR XDYTR.
  PERFORM D0130_FUELLEN_EINZELFELDER.
  LOOP AT XBKNBK.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D2130_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0130.
    IF XBKNBK-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
      XDYTR = 'X'.
    ENDIF.
    PERFORM BNKA_BEARBEITEN.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNBK LINES REFE1.
  IF  REFE1 NE  0
  AND XDYTR NE 'X'.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  ENDIF.

  DESCRIBE TABLE XBKNZAA LINES REFE1.
  IF REFE1 GT 0.
    PERFORM KNZA_VERARBEITUNG.
  ENDIF.
ENDFORM.

*begin of j_1a
*eject
*-----------------------------------------------------------------------
*       Form D0600_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0600_VERARBEITUNG.
* setzen funktionscode für steuerkategorien
  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = 'STKT'.
  APPEND FT.

*dynpro verarbeiten
  PERFORM DYNPRO_BEGIN USING REP_NAME_D '0600'.
  LOOP AT XBKNAT.
    PERFORM OKCODE_POSZ.
    PERFORM D2600_FUELLEN.
    PERFORM D0600_FUELLEN.
    PERFORM CURSOR_SETZEN_0600.
    IF XBKNAT-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN  USING REP_NAME_D '0600'.
    ENDIF.
    PERFORM KNAT_BEARBEITEN.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNAT LINES REFE1.
  IF REFE1 NE 0.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D '0600'.
  ENDIF.

* zurück zum aufrufer
  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/3'.
  APPEND FT.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
ENDFORM.
*end of j_1a

*&---------------------------------------------------------------------*
*&      Form  D0610_VERARBEITUNG
*&---------------------------------------------------------------------*
*    Erweiterte Quellensteuer
*----------------------------------------------------------------------*
FORM D0610_VERARBEITUNG.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.

  LOOP AT XBKNBW.
    PERFORM OKCODE_POSZ.
    PERFORM D2610_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0610.
    IF XBKNBW-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
    ENDIF.
    PERFORM KNBW_BEARBEITEN.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNBW LINES REFE1.
  IF REFE1 NE 0.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  ENDIF.

ENDFORM.                               " D0610_VERARBEITUNG

*eject
*-----------------------------------------------------------------------
*        Form  D2324_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Partnerrollen
*-----------------------------------------------------------------------
FORM D2324_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2324'.
  IF XBKNVP-PARVW(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVP-PARVW'.
    FT-FVAL = XBKNVP-PARVW.
    APPEND FT.
  ENDIF.
  IF XBKNVP-KTONR(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'RF02D-KTONR'.
    FT-FVAL = XBKNVP-KTONR.
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form D0324_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0324_VERARBEITUNG.
  CLEAR XDYTR.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.

  LOOP AT XBKNVP WHERE XDELE = 'X'.
    XBKNVP-DEFPA = ' '.
    XBKNVP-XDELE = ' '.
    PERFORM OKCODE_POSZ.
    PERFORM D2324_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0324.
  ENDLOOP.

  LOOP AT XBKNVP.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D2324_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0324.
    IF XBKNVP-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
      XDYTR = 'X'.
    ENDIF.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNVP LINES REFE1.
  IF  REFE1 NE  0
  AND XDYTR NE 'X'.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D2326_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Nachrichten
*-----------------------------------------------------------------------
FORM D2326_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2326'.
  IF XBKNVD-DOCTP(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVD-DOCTP'.
    FT-FVAL = XBKNVD-DOCTP.
    APPEND FT.
  ENDIF.
  IF XBKNVD-SPRAS(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVD-SPRAS'.
    FT-FVAL = XBKNVD-SPRAS.
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form D0326_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0326_VERARBEITUNG.
  CLEAR XDYTR.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  LOOP AT XBKNVD.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D2326_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0326.
    IF XBKNVD-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
      XDYTR = 'X'.
    ENDIF.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNVD LINES REFE1.
  IF  REFE1 NE  0
  AND XDYTR NE 'X'.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D2340_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Abladestellen
*-----------------------------------------------------------------------
FORM D2340_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2340'.
  IF XBKNVA-ABLAD(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-ABLAD'.
    FT-FVAL = XBKNVA-ABLAD.
    APPEND FT.
  ENDIF.
  IF XBKNVA-KNFAK(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-KNFAK'.
    FT-FVAL = XBKNVA-KNFAK.
    APPEND FT.
  ENDIF.
ENDFORM.

*mi/46a begin
*-----------------------------------------------------------------------
*        Form  D2420_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Empfangstellen
*-----------------------------------------------------------------------
FORM D2420_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '2420'.
  IF XBWRF12-EMPST(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF12-EMPST'.
    FT-FVAL = XBWRF12-EMPST.
    APPEND FT.
  ENDIF.
ENDFORM.

*-----------------------------------------------------------------------
*        Form  D2410_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Abteilungen
*-----------------------------------------------------------------------
FORM D2410_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '2410'.
  IF XBWRF4-ABTNR(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF4-ABTNR'.
    FT-FVAL = XBWRF4-ABTNR.
    APPEND FT.
  ENDIF.
ENDFORM.
*mi/46a end

*eject
*-----------------------------------------------------------------------
*       Form D0340_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0340_VERARBEITUNG.
  CLEAR XDYTR.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  LOOP AT XBKNVA where xdele <> 'X'.           "mi/46a
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D2340_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0340.
*mi/46a begin deletion
*    IF XBKNVA-XDELE = 'X'.
*      PERFORM OKCODE_F14.
*      PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
*      XDYTR = 'X'.
*    ENDIF.
*mi/46a end deletion
    PERFORM KNVA_ZEITEN_BEARBEITEN.
  ENDLOOP.

*mi/46a begin deletion
*------- Letzte Zeile abschicken ---------------------------------------
*  DESCRIBE TABLE XBKNVA LINES REFE1.
*  IF  REFE1 NE  0
*  AND XDYTR NE 'X'.
*    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
*  ENDIF.
*mi/46a end deletion

*mi/46a begin
  PERFORM D0420_VERARBEITUNG.        "Dann Empfangsstellen bearbeiten
  PERFORM D0410_VERARBEITUNG.        "Dann Abteilungen bearbeiten
  PERFORM D0420_VERARBEITUNG_XDELE.  "Zuerst ggf. Abteilungen löschen
                                     "Als letztes Abladestellen löschen
  read table xbknva with key xdele = 'X'.
  check sy-subrc = 0.
  clear xdytr.
  LOOP AT XBKNVA where xdele = 'X'.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D2340_FUELLEN.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0340.
    PERFORM OKCODE_F14.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
    XDYTR = 'X'.
  ENDLOOP.
*mi/46a end
ENDFORM.


*mi/46a begin
*-----------------------------------------------------------------------
*       Form D0420_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0420_VERARBEITUNG.
  CLEAR XDYTR.

* Zu verarbeitende Sätze vorhanden?
  read table xbwrf12 with key xdele = nodata.
  check sy-subrc = 0.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/19'.
  APPEND FT.

  PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '0420'.
  LOOP AT XBwrf12 where xdele <> 'X'.
    CLEAR XDYTR.
    CLEAR FT.
    FT-FNAM = 'BDC_OKCODE'.
    FT-FVAL = '/19'.
    APPEND FT.
    PERFORM D2420_FUELLEN.
    PERFORM D0420_FUELLEN.
  ENDLOOP.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/03'.
  APPEND FT.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
ENDFORM.


*-----------------------------------------------------------------------
*       Form D0410_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0410_VERARBEITUNG.
  CLEAR XDYTR.

* Zu verarbeitende Sätze vorhanden?
  read table xbwrf4 index 1.      "key xdele = nodata.
  check sy-subrc = 0.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/25'.
  APPEND FT.

  PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '0410'.
  LOOP AT XBwrf4.  " where xdele <> 'X'.
    CLEAR XDYTR.
    CLEAR FT.
    FT-FNAM = 'BDC_OKCODE'.
    FT-FVAL = '/19'.
    APPEND FT.
    PERFORM D2410_FUELLEN.
    PERFORM D0410_FUELLEN.
    PERFORM CURSOR_SETZEN_0410.
    IF XBWRF4-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '0410'.
      XDYTR = 'X'.
    else.
      CLEAR FT.
      FT-FNAM = 'BDC_OKCODE'.
      FT-FVAL = '/02'.
      APPEND FT.
      perform d0411_fuellen.
      CLEAR FT.
      FT-FNAM = 'BDC_OKCODE'.
      FT-FVAL = '/03'.
      APPEND FT.
      PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '0410'.
    ENDIF.
  ENDLOOP.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/03'.
  APPEND FT.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
ENDFORM.


*-----------------------------------------------------------------------
*       Form D0420_VERARBEITUNG_XDELE
*-----------------------------------------------------------------------
*       Zu löschende Empfangsstellen bearbeiten
*-----------------------------------------------------------------------
FORM D0420_VERARBEITUNG_XDELE.
  CLEAR XDYTR.

* Zu löschende Sätze vorhanden?
  read table xbwrf12 with key xdele = 'X'.
  check sy-subrc = 0.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/19'.
  APPEND FT.

  PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '0420'.
  LOOP AT XBwrf12 where xdele = 'X'.
    CLEAR XDYTR.
    CLEAR FT.
    FT-FNAM = 'BDC_OKCODE'.
    FT-FVAL = '/19'.
    APPEND FT.
    PERFORM D2420_FUELLEN.
    PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '0420'.
    PERFORM CURSOR_SETZEN_0420.
    PERFORM OKCODE_F14.
    PERFORM DYNPRO_BEGIN USING 'SAPLWR22' '0420'.
    XDYTR = 'X'.
  ENDLOOP.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/03'.
  APPEND FT.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
ENDFORM.


*----------------------------------------------------------
*        Form D0420_FUELLEN
*----------------------------------------------------------
FORM D0420_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPLWR22'.
  FT-DYNPRO   = '0420'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBwrf12-empst(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF12-EMPST                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBWRF12-empst                  .
    APPEND FT.
  ENDIF.
  IF XBwrf12-ablad(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF12-ABLAD                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBWRF12-ablad                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*----------------------------------------------------------
*        Form D0410_FUELLEN
*----------------------------------------------------------
FORM D0410_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPLWR22'.
  FT-DYNPRO   = '0410'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBwrf4-abtnr(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF4-ABTNR                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBWRF4-abtnr                  .
    APPEND FT.
  ENDIF.
  IF XBwrf4-empst(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF4-EMPST                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBWRF4-empst                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*----------------------------------------------------------
*        Form D0411_FUELLEN
*----------------------------------------------------------
FORM D0411_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPLWR22'.
  FT-DYNPRO   = '0411'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBwrf4-layvr(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF4-LAYVR                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBWRF4-layvr                  .
    APPEND FT.
  ENDIF.
  IF XBwrf4-flvar(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF4-FLVAR                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBWRF4-flvar                  .
    APPEND FT.
  ENDIF.
  IF XBwrf4-verfl(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF4-VERFL                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBWRF4-verfl                  .
    APPEND FT.
  ENDIF.
  IF XBwrf4-verfe(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'WRF4-VERFE                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBWRF4-verfe                  .
    APPEND FT.
  ENDIF.
ENDFORM.
*mi/46a end


*eject
*-----------------------------------------------------------------------
*        Form  D2360_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Ansprechpartner
*-----------------------------------------------------------------------
FORM D2360_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2360'.
  IF  XBKNVK-PARNR(1) NE NODATA.
* AND BKN00-TCODE     NE 'XD01'.     "zu 2.1A deaktiviert
    CLEAR FT.
    FT-FNAM = 'KNVK-PARNR'.
    FT-FVAL = XBKNVK-PARNR.
    APPEND FT.
  ENDIF.
  IF XBKNVK-NAME1(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-NAME1'.
    FT-FVAL = XBKNVK-NAME1.
    APPEND FT.
  ENDIF.
  IF XBKNVK-NAMEV(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-NAMEV'.
    FT-FVAL = XBKNVK-NAMEV.
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARGE(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARGE'.
    FT-FVAL = XBKNVK-PARGE.
    APPEND FT.
  ENDIF.
  IF XBKNVK-GBDAT(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-GBDAT'.
    FT-FVAL = XBKNVK-GBDAT.
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form D0360_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0360_VERARBEITUNG.
  CLEAR XDYTR.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.

*\BE ZAV
  IF NOT ZAV_FLAG IS INITIAL.
    PERFORM ERMITTLE_ALLE_CONT_PARTNER USING 'KNA1'.
  ENDIF.
*\BE ZAV Ende

  LOOP AT XBKNVK.
    CLEAR XDYTR.
    CLEAR KNVK_MESS.
    PERFORM OKCODE_POSZ.
*\BE ZAV
    IF NOT ZAV_FLAG IS INITIAL.
      PERFORM ZAV_PARNR_BESTIMMEN.
    ENDIF.
*\BE ZAV Ende
    PERFORM D2360_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0360.
    IF XBKNVK-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
      XDYTR = 'X'.
    ENDIF.

*------- Hinzufügen => es darf keine Partnernummer übergeben werden ---
*------- ab Release 2.1A dürfen Nummern übergeben werden! -------------
*   PERFORM parnr_uepar_pruefen.             "mit 2.1A deaktiviert

*------- Anrede darf nicht länger als 15 Stellen sein -----------------
*------- zu 3.0D wegen scrollbarer Felder deaktiviert -----------------
    IF  XBKNVK-ANRED NE SPACE
    AND XBKNVK-ANRED(1) NE NODATA.
*     xbknvk-anred+16(12) = space.                 "P30K070730/3.0D
    ENDIF.
    PERFORM D1360_DATEN_BEARBEITEN.
    PERFORM D1365_DATEN_BEARBEITEN.
    PERFORM D1366_DATEN_BEARBEITEN.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNVK LINES REFE1.
  IF  REFE1 NE  0
  AND XDYTR NE 'X'.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D2370_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Außenhandelsdaten
*-----------------------------------------------------------------------
FORM D2370_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2370'.
  IF XBKNEX-LNDEX(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNEX-LNDEX'.
    FT-FVAL = XBKNEX-LNDEX.
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form D0370_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*-----------------------------------------------------------------------
FORM D0370_VERARBEITUNG.
  CLEAR XDYTR.

*------- CIVVE/MILVE sind Auswahlknöpfe, nie beide = 'X' ---------------
  IF  BKNA1-CIVVE = 'X'.
    CLEAR BKNA1-MILVE.
  ELSEIF BKNA1-MILVE = 'X'.
    CLEAR BKNA1-CIVVE.
  ENDIF.
  PERFORM D0370_FUELLEN_EINZELFELDER.
  LOOP AT XBKNEX.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D2370_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_0370.
    IF XBKNEX-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
      XDYTR = 'X'.
    ENDIF.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNEX LINES REFE1.
  IF  REFE1 NE  0
  AND XDYTR NE 'X'.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D2350_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Steuern
*-----------------------------------------------------------------------
FORM D2350_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2350'.
  IF XBKNVI-ALAND(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVI-ALAND'.
    FT-FVAL = XBKNVI-ALAND.
    APPEND FT.
  ENDIF.
  IF XBKNVI-TATYP(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVI-TATYP'.
    FT-FVAL = XBKNVI-TATYP.
    APPEND FT.
  ENDIF.
  IF XBKNVI-TAXKD(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVI-TAXKD'.
    FT-FVAL = XBKNVI-TAXKD.
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form D1350_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*       Sonderfall Steuern/Lizenzen: Lizenzpflege ist nur über die
*       Steuerpflege möglich (Teilschlüssel). Deshalb muß der Teil-
*       schlüssel ALAND/TATYP aus Tabelle XBKNVL immer in XBKNVI ent-
*       halten sein, d.h. er ist ggf. neu aufzunehmen.
*-----------------------------------------------------------------------
FORM D1350_VERARBEITUNG.
  CLEAR XDYTR.
  CLEAR LICEX.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.

*------- Steuerdaten: Vollständigkeit prüfen --------------------------
  PERFORM STEUERDATEN_PRUEFEN.

*------- Lizenzdaten: Vollständigkeit prüfen --------------------------
  PERFORM LIZENZEN_PRUEFEN.

*------- XBKNVL-Teilschlüssel in XBKNVI enthalten ? -------------------
  LOOP AT XBKNVL.
    LOOP AT XBKNVI WHERE ALAND = XBKNVL-ALAND
                   AND   TATYP = XBKNVL-TATYP.
    ENDLOOP.
    IF SY-SUBRC NE 0.
      XBKNVI-ALAND = XBKNVL-ALAND.
      XBKNVI-TATYP = XBKNVL-TATYP.
      XBKNVI-TAXKD = NODATA.
      APPEND XBKNVI.
    ENDIF.
  ENDLOOP.

*------- Steuer-/Lizenzverarbeitung beginnen --------------------------
  LOOP AT XBKNVI.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D2350_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING DYNTAB-DYNNR.
    PERFORM CURSOR_SETZEN_1350.

*------- Ggf. Lizenzen bearbeiten -------------------------------------
    LOOP AT XBKNVL WHERE ALAND = XBKNVI-ALAND
                   AND   TATYP = XBKNVI-TATYP.
    ENDLOOP.
    IF SY-SUBRC = 0.
      LICEX = 'X'.
      PERFORM OKCODE_KNVL.
      PERFORM D1355_VERARBEITUNG.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
    ENDIF.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNVI LINES REFE1.
  IF  REFE1 NE  0
  AND XDYTR NE 'X'
  AND LICEX NE 'X'.
    PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D2355_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für Lizenzen
*-----------------------------------------------------------------------
FORM D2355_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '2355'.
  IF XBKNVL-ALAND(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-ALAND'.
    FT-FVAL = XBKNVL-ALAND.
    APPEND FT.
  ENDIF.
  IF XBKNVL-TATYP(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-TATYP'.
    FT-FVAL = XBKNVL-TATYP.
    APPEND FT.
  ENDIF.
  IF XBKNVL-LICNR(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-LICNR'.
    FT-FVAL = XBKNVL-LICNR.
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form D1355_VERARBEITUNG
*-----------------------------------------------------------------------
*       Bei Listen wird jede Zeile einzeln gesendet.
*       Bei Lizenzen dürfen nur jeweil die Sätze bearbeitet werden,
*       die den Schlüssel der aktuellen XBKNVI-Zeile beinhalten.
*-----------------------------------------------------------------------
FORM D1355_VERARBEITUNG.
  CLEAR XDYTR.
  CLEAR REFE1.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D '1355'.
  LOOP AT XBKNVL WHERE ALAND = XBKNVI-ALAND
                 AND   TATYP = XBKNVI-TATYP.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D2355_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING '1355'.
    PERFORM CURSOR_SETZEN_1355.
    IF XBKNVL-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D '1355'.
      XDYTR = 'X'.
    ENDIF.
    ADD 1 TO REFE1.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  IF  REFE1 NE  0
  AND XDYTR NE 'X'.
*   PERFORM DYNPRO_BEGIN USING REP_NAME_D '1355'.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form DYNPRO_BEGIN
*-----------------------------------------------------------------------
FORM DYNPRO_BEGIN USING PROGRAM DYNPRO.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-PROGRAM  = PROGRAM.
  FT-DYNPRO   = DYNPRO.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  DYNTAB_AUFBAUEN
*-----------------------------------------------------------------------
*        Für jede Transaktion werden in der DYNTAB die
*        abzuarbeitenden Bilder aufgelistet.
*
*        Aus den übergebenen Key-Feldern werden die zu
*        bearbeitenden Bereiche abgeleitet.
*
*        Besonderheit beim Anlegen:
*        Beim Anlegen wird die KNA1 zur Probe gelesen, um festzustellen,
*        ob das A-Segment schon angelegt wurde.
*        In diesem Fall dürfen keine Daten des Allg. Bereichs an die
*        Schnittstelle übergeben werden.
*-----------------------------------------------------------------------
FORM DYNTAB_AUFBAUEN.
  REFRESH DYNTAB.
  CLEAR   DYNTAB.

  CLEAR   BI.

*------- Aktivität und Funktion aus T020 / XT020 ermitteln ---------
  PERFORM AKTIVITAET_ERMITTELN.

*------- Sonderfall: Kreditlimit --------------------------------------
  IF XT020-DYNCL = 'C'.
    CLEAR DYNTAB.
    DYNTAB-DYNNR = 'L120'.
    DYNTAB-DTYPE = 'L'.
    APPEND DYNTAB.
    IF  BKN00-KKBER NE NODATA
    AND BKN00-KKBER NE SPACE.
      CLEAR DYNTAB.
      DYNTAB-DYNNR = 'L210'.
      DYNTAB-DTYPE = 'L'.
      APPEND DYNTAB.
      BI-XKKBR  = 'X'.
    ENDIF.
    EXIT.
  ENDIF.

*------- Debitor: zu bearbeitende Bereiche ermitteln ------------------
  BI-XASEG = 'X'.

*\BE
* Alpha-Konvertierung generell durchführen, da im Rahmen der
* ZAV-Umstellung auf im Ändern-Modus mit der KUNNR auf Daten zugegriffen
* wird.
  CLEAR KUNNR.
  IF  BKN00-KUNNR(1) NE NODATA
   AND BKN00-KUNNR    NE SPACE.
    TRANSLATE BKN00-KUNNR TO UPPER CASE.   "#EC TRANSLANG
    PERFORM ALPHAFORMAT(SAPFS000) USING BKN00-KUNNR KUNNR.
  ENDIF.
*\BE Ende
*------- Anlegen: existiert allg. Bereich schon ? ----------------------
  IF XT020-AKTYP = 'H'.
    IF  BKN00-KUNNR(1) NE NODATA
    AND BKN00-KUNNR    NE SPACE.
*     TRANSLATE BKN00-KUNNR TO UPPER CASE.   "#EC TRANSLANG  "\BE s.o.
*     PERFORM ALPHAFORMAT(SAPFS000) USING BKN00-KUNNR KUNNR. "\BE s.o.
* \BE Beginn
* Umgestellt auf Lesebaustein; Puffer nicht ausnutzen, da ansonsten
* Daten nicht aktuell, wenn der gleiche Kunde mehrmals verarbeitet wird.
*     SELECT SINGLE * FROM KNA1 WHERE KUNNR = KUNNR.
      CALL FUNCTION 'V_KNA1_SINGLE_READ'
           EXPORTING
                PI_KUNNR            = KUNNR
                PI_BYPASSING_BUFFER = 'X'    "Daten müssen aktuell sein
*               PI_REFRESH_BUFFER   =
           IMPORTING
                PE_KNA1             = KNA1
           EXCEPTIONS
                NO_RECORDS_FOUND    = 1
                OTHERS              = 2.
* \BE Ende
      IF SY-SUBRC = 0.
        BI-XASEG = SPACE.
      ENDIF.
    ENDIF.
*\BE ZAV: auch im Ändern-Modus die KNA1 lesen
  ELSE.
    IF NOT ZAV_FLAG IS INITIAL.
      IF  BKN00-KUNNR(1) NE NODATA
      AND BKN00-KUNNR    NE SPACE.
        CALL FUNCTION 'V_KNA1_SINGLE_READ'
               EXPORTING
                   PI_KUNNR            = KUNNR
                   PI_BYPASSING_BUFFER = 'X'
*                     PI_REFRESH_BUFFER   =
               IMPORTING
                   PE_KNA1             = KNA1
               EXCEPTIONS
                   NO_RECORDS_FOUND    = 1
                   OTHERS              = 2.
      ENDIF.
    ENDIF.
*\BE Ende
  ENDIF.

*------- Buchungskreisdaten bearbeiten? -------------------------------
  IF  BKN00-BUKRS(1) NE NODATA
  AND BKN00-BUKRS    NE SPACE.
    BI-XBUKR = 'X'.
*--- Quellensteuer
    PERFORM T001_DATEN_ERMITTELN.
*------- Anlegen: Existiert Buchungskreis schon ? ----------------------
    IF XT020-AKTYP = 'H'
    AND BKN00-KUNNR(1) NE NODATA
    AND BKN00-KUNNR    NE SPACE.
      SELECT SINGLE * FROM KNB1 WHERE KUNNR = KUNNR
                                AND   BUKRS = BKN00-BUKRS.
      IF SY-SUBRC = 0.
        BI-XBUKR = SPACE.
      ENDIF.
    ENDIF.
  ENDIF.

*------- Verkaufsdaten bearbeiten? ------------------------------------
  IF  BKN00-VKORG(1) NE NODATA
  AND BKN00-VKORG    NE SPACE.
    BI-XVKOR = 'X'.

*------- Anlegen: Existiert Vertriebsbereich schon? --------------------
    IF XT020-AKTYP = 'H'
    AND BKN00-KUNNR(1) NE NODATA
    AND BKN00-KUNNR    NE SPACE.
      SELECT SINGLE * FROM KNVV WHERE KUNNR = KUNNR
                                AND   VKORG = BKN00-VKORG
                                AND   VTWEG = BKN00-VTWEG
                                AND   SPART = BKN00-SPART.
      IF SY-SUBRC = 0.
        BI-XVKOR = SPACE.
      ENDIF.
    ENDIF.
  ENDIF.

*------- Sperren: Dynpro setzen ----------------------------------------
  IF  XT020-AKTYP = 'V'
  AND XT020-FUNCL = 'S'.
    CLEAR DYNTAB.
    DYNTAB-DYNNR = '0510'.
    APPEND DYNTAB.
    MESSAGE I122 WITH TRANS_COUNT BKN00-TCODE.
  ENDIF.

*------- Löschvormerkung: Dynpro setzen --------------------------------
  IF  XT020-AKTYP = 'V'
  AND XT020-FUNCL = 'L'.
    CLEAR DYNTAB.
    DYNTAB-DYNNR = '0520'.
    APPEND DYNTAB.
    MESSAGE I123 WITH TRANS_COUNT BKN00-TCODE.
  ENDIF.

*------- DYNTAB aufbauen ( für anlegen / ändern ) ----------------------
  CLEAR: CHAR, CHAR1.
  IF XT020-FUNCL = SPACE.
    WHILE CHAR(4) NE '$END'
      VARY CHAR(4)  FROM DYNSEQ-D01 NEXT DYNSEQ-D02
      VARY CHAR1(1) FROM DYNSEQ-T01 NEXT DYNSEQ-T02
      VARY CHAR2(1) FROM DYNSEQ-L01 NEXT DYNSEQ-L02.
      CLEAR DYNTAB.
      CASE CHAR1(1).

*------- Dynpros für Allgemeine Daten ---------------------------------
        WHEN 'A'.
          IF BI-XASEG EQ 'X'.
            DYNTAB-DYNNR = CHAR(4).
            DYNTAB-DTYPE = CHAR1(1).
            DYNTAB-XLIST = CHAR2(1).
*ZAV: statt Dynpro 110 mit Dynpro 111 bzw. 112 (Konsument) arbeiten /ms
            IF DYNTAB-DYNNR = '0110'.
              IF NOT ZAV_FLAG IS INITIAL.
                if bkn00-ktokd = '0170' or kna1-dear6 = 'X'.
                  DYNTAB-DYNNR = '0112'.
                else.
                  DYNTAB-DYNNR = '0111'.
                endif.
              ENDIF.
            ENDIF.
*ZAV Ende
            APPEND DYNTAB.
          ENDIF.

*------- Dynpros für RF-Daten -----------------------------------------
        WHEN 'F'.
          IF BI-XBUKR EQ 'X'.
            DYNTAB-DYNNR = CHAR(4).
            DYNTAB-DTYPE = CHAR1(1).
            DYNTAB-XLIST = CHAR2(1).
            APPEND DYNTAB.
          ENDIF.

*------- Dynpros für RV-Daten -----------------------------------------
        WHEN 'V'.
          IF BI-XVKOR EQ 'X'.
            DYNTAB-DYNNR = CHAR(4).
            DYNTAB-DTYPE = CHAR1(1).
            DYNTAB-XLIST = CHAR2(1).
            APPEND DYNTAB.
          ENDIF.
      ENDCASE.
    ENDWHILE.

*------- Sonderfall: Steuern Vertrieb (D1350 aufnehmen) ---------------
    IF BI-XVKOR EQ 'X'.
      READ TABLE DYNTAB WITH KEY '0320'.
      TABIX = SY-TABIX + 1.
      DYNTAB-DYNNR = '1350'.
      DYNTAB-DTYPE = 'V'.
      DYNTAB-XLIST = 'X'.
      INSERT DYNTAB INDEX TABIX.
    ENDIF.
  ENDIF.

*-------- Südamerikanische Steuerbilder entfernen ----------------------
  LOOP AT DYNTAB WHERE DYNNR = '0600'.                      "QHA960119
*                   or dynnr = '0610'.                      "QHA960119
    DELETE DYNTAB.                                          "QHA960119
  ENDLOOP.                                                  "QHA960119

ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D1360_DATEN_BEARBEITEN
*-----------------------------------------------------------------------
*        Partner-Detaildaten prüfen/übertragen
*-----------------------------------------------------------------------
FORM D1360_DATEN_BEARBEITEN.

*------- Wurden Detaildaten übergeben ? -------------------------------
  CHECK XBKNVK-SORTL(1) NE NODATA
  OR    XBKNVK-PARLA(1) NE NODATA
  OR    XBKNVK-PARGE(1) NE NODATA
  OR    XBKNVK-FAMST(1) NE NODATA
  OR    XBKNVK-GBDAT(1) NE NODATA
  OR    XBKNVK-ABTPA(1) NE NODATA
  OR    XBKNVK-PAVIP(1) NE NODATA
  OR    XBKNVK-PARVO(1) NE NODATA
  OR    XBKNVK-NMAIL(1) NE NODATA
  OR    XBKNVK-UEPAR(1) NE NODATA
  OR    XBKNVK-VRTNR(1) NE NODATA
  OR    XBKNVK-BRYTH(1) NE NODATA
  OR    XBKNVK-AKVER(1) NE NODATA
  OR    XBKNVK-PARAU(1) NE NODATA
  OR    XBKNVK-SPNAM(1) NE NODATA      "K11K111524/3.0
*\BE ZAV Telefon-Nummer wird jetzt auf Detailbild 1361 verarbeitet
  OR  ( XBKNVK-TELF1(1)    NE NODATA
        AND NOT ZAV_FLAG IS INITIAL )
  OR  ( XBKNVK-ANRED(1)    NE NODATA
        AND NOT ZAV_FLAG IS INITIAL )
*\BE ZAV Ende
  OR    XBKNVK-TITEL_AP(1) NE NODATA.

*------- Delete-Flag gesetzt? -----------------------------------------
  IF XBKNVK-XDELE EQ 'X'.
    MESSAGE I197 WITH XBKNVK-NAME1.
    MESSAGE I198.
    KNVK_MESS = 'X'.
    EXIT.
  ENDIF.

*------- neue Detaildaten übertragen ----------------------------------
  PERFORM OKCODE_KNVK.
*\BE ZAV; Ansprung des neuen Detailbilds 1361
  IF ZAV_FLAG IS INITIAL.
    PERFORM DYNPRO_FUELLEN USING '1360'.
  ELSE.
    PERFORM DYNPRO_FUELLEN USING '1361'.
  ENDIF.
*\BE ZAV Ende
  PERFORM OKCODE_F03.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  XDYTR = 'X'.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D1365_DATEN_BEARBEITEN
*-----------------------------------------------------------------------
*        Partner-Besuchszeiten übertragen
*-----------------------------------------------------------------------
FORM D1365_DATEN_BEARBEITEN.

*------- Wurden Besuchszeiten übergeben ? ------------------------------
  CHECK KNVK_MESS NE 'X'.
  CHECK XBKNVK-MOAB1(1) NE NODATA
  OR    XBKNVK-MOBI1(1) NE NODATA
  OR    XBKNVK-MOAB2(1) NE NODATA
  OR    XBKNVK-MOBI2(1) NE NODATA
  OR    XBKNVK-DIAB1(1) NE NODATA
  OR    XBKNVK-DIBI1(1) NE NODATA
  OR    XBKNVK-DIAB2(1) NE NODATA
  OR    XBKNVK-DIBI2(1) NE NODATA
  OR    XBKNVK-MIAB1(1) NE NODATA
  OR    XBKNVK-MIBI1(1) NE NODATA
  OR    XBKNVK-MIAB2(1) NE NODATA
  OR    XBKNVK-MIBI2(1) NE NODATA
  OR    XBKNVK-DOAB1(1) NE NODATA
  OR    XBKNVK-DOBI1(1) NE NODATA
  OR    XBKNVK-DOAB2(1) NE NODATA
  OR    XBKNVK-DOBI2(1) NE NODATA
  OR    XBKNVK-FRAB1(1) NE NODATA
  OR    XBKNVK-FRBI1(1) NE NODATA
  OR    XBKNVK-FRAB2(1) NE NODATA
  OR    XBKNVK-FRBI2(1) NE NODATA
  OR    XBKNVK-SAAB1(1) NE NODATA
  OR    XBKNVK-SABI1(1) NE NODATA
  OR    XBKNVK-SAAB2(1) NE NODATA
  OR    XBKNVK-SABI2(1) NE NODATA
  OR    XBKNVK-SOAB1(1) NE NODATA
  OR    XBKNVK-SOBI1(1) NE NODATA
  OR    XBKNVK-SOAB2(1) NE NODATA
  OR    XBKNVK-SOBI2(1) NE NODATA.

*------- Delete-Flag gesetzt? -----------------------------------------
  IF XBKNVK-XDELE EQ 'X'.
    MESSAGE I197 WITH XBKNVK-NAME1.
    MESSAGE I198.
    KNVK_MESS = 'X'.
    EXIT.
  ENDIF.

*------- neue Besuchszeiten übertragen --------------------------------
  PERFORM OKCODE_F09.
  PERFORM DYNPRO_FUELLEN USING '1365'.
* perform okcode_f03.                   "S11K144454/3.0
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  XDYTR = 'X'.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  D1366_DATEN_BEARBEITEN
*-----------------------------------------------------------------------
*        Partner-Attribute übertragen
*-----------------------------------------------------------------------
FORM D1366_DATEN_BEARBEITEN.

*------- Wurden Attribute übergeben ? ----------------------------------
  CHECK KNVK_MESS NE 'X'.
  CHECK XBKNVK-PARH1(1) NE NODATA
  OR    XBKNVK-PARH2(1) NE NODATA
  OR    XBKNVK-PARH3(1) NE NODATA
  OR    XBKNVK-PARH4(1) NE NODATA
  OR    XBKNVK-PARH5(1) NE NODATA
  OR    XBKNVK-PAKN1(1) NE NODATA
  OR    XBKNVK-PAKN2(1) NE NODATA
  OR    XBKNVK-PAKN3(1) NE NODATA
  OR    XBKNVK-PAKN4(1) NE NODATA
  OR    XBKNVK-PAKN5(1) NE NODATA.

*------- Delete-Flag gesetzt? -----------------------------------------
  IF XBKNVK-XDELE EQ 'X'.
    MESSAGE I197 WITH XBKNVK-NAME1.
    MESSAGE I198.
    KNVK_MESS = 'X'.
    EXIT.
  ENDIF.

*------- neue Detaildaten übertragen ----------------------------------
  PERFORM OKCODE_ATTR.
  PERFORM DYNPRO_FUELLEN USING '1366'.
* perform okcode_f03.                   "S11K144454/3.0
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  XDYTR = 'X'.
ENDFORM.


*eject
*-----------------------------------------------------------------------
*        Form  D3130_FUELLEN
*-----------------------------------------------------------------------
*        Aufsetzfelder für abw. Regulierer
*-----------------------------------------------------------------------
FORM D3130_FUELLEN.
  CHECK FL_CHECK = SPACE.

  PERFORM DYNPRO_BEGIN USING REP_NAME_D '3130'.
  IF XBKNZA-EMPFD(1) NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNZA-EMPFD'.
    FT-FVAL = XBKNZA-EMPFD.
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form FUNKTION_LOESCHVORMERKUNGEN
*-----------------------------------------------------------------------
FORM FUNKTION_LOESCHVORMERKUNGEN.
  CHECK FL_CHECK = SPACE.


*------- wurden Löschvormerkungen übergeben ? --------------------------

* begin P30K113875

* check bkna1-loevm(1) ne nodata
* or    bknb1-loevm(1) ne nodata
* or    bknvv-loevm(1) ne nodata.


* Löschvorm. von dem Dynpro aus setzen zu dem Kezi zu verarbeiten sind.
* Dabei berücksichtigen, daß Dynpros evtl. total ausgeblendet sind.

  CHECK LOESCH_GESETZT = SPACE.      "Loschvormerkung nur einmal setzen

  CASE DYNTAB-DYNNR.

    WHEN '0110'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
*\BE ZAV Beginn
    WHEN '0111'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
*\MS Konsument Beginn
    WHEN '0112'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
*\MS Konsument Beginn
*\BE ZAV Ende
    WHEN '0120'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
    WHEN '0125'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
    WHEN '0130'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
    WHEN '0340'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
    WHEN '0370'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
    WHEN '0360'.
      CHECK BKNA1-LOEVM(1) NE NODATA.
    WHEN '0210'.
      CHECK BKNB1-LOEVM(1) NE NODATA.
    WHEN '0215'.
      CHECK BKNB1-LOEVM(1) NE NODATA.
    WHEN '0220'.
      CHECK BKNB1-LOEVM(1) NE NODATA.
    WHEN '0230'.
      CHECK BKNB1-LOEVM(1) NE NODATA.
    WHEN '0310'.
      CHECK BKNVV-LOEVM(1) NE NODATA.
    WHEN '0315'.
      CHECK BKNVV-LOEVM(1) NE NODATA.
    WHEN '0320'.
      CHECK BKNVV-LOEVM(1) NE NODATA.
    WHEN '0324'.
      CHECK BKNVV-LOEVM(1) NE NODATA.
    WHEN '0326'.
      CHECK BKNVV-LOEVM(1) NE NODATA.
    WHEN OTHERS.
      EXIT.
  ENDCASE.
* end P30K113875

*------- auf Löschvormerkungsbild springen -----------------------------
  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '0520'.
  APPEND FT.

*------- Lövm-daten auf Dynpro stellen und zurückspringen -------------
  PERFORM DYNPRO_FUELLEN USING '0520'.
  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/03'.
  APPEND FT.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.

* begin P30K113875
* Löschvormerkung wurde gesetzt
  LOESCH_GESETZT = 'X'.
* end P30K113875

ENDFORM.

*eject
*-----------------------------------------------------------------------
*       Form FUNKTION_SPERRDATEBN
*-----------------------------------------------------------------------
FORM FUNKTION_SPERRDATEN.
  CHECK FL_CHECK = SPACE.

*------- wurden Sperrdaten übergeben ? ---------------------------------
* begin P30K113875
* check bkna1-sperr(1) ne nodata
* or    bkna1-faksd(1) ne nodata
* or    bkna1-lifsd(1) ne nodata
* or    bkna1-aufsd(1) ne nodata
* or    bknb1-sperr(1) ne nodata
* or    bknvv-faksd(1) ne nodata
* or    bknvv-lifsd(1) ne nodata
* or    bknvv-aufsd(1) ne nodata.

* Sperre von dem Dynpro aus setzen zu dem Sperrkezi zu verarbeiten sind.
* Dabei berücksichtigen, daß Dynpros evtl. total ausgeblendet sind.


  CHECK SPERRE_GESETZT = SPACE.        "Sperre nur einmal setzen

  CASE DYNTAB-DYNNR.
    WHEN '0110'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
*\BE ZAV Beginn
    WHEN '0111'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
*\MS Konsument Beginn
    WHEN '0112'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
*\MS Konsument Ende
*\BE ZAV Ende
    WHEN '0120'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
    WHEN '0125'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
    WHEN '0130'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
    WHEN '0340'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
    WHEN '0370'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
    WHEN '0360'.
      CHECK BKNA1-SPERR(1) NE NODATA
      OR    BKNA1-AUFSD(1) NE NODATA
      OR    BKNA1-LIFSD(1) NE NODATA
      OR    BKNA1-FAKSD(1) NE NODATA.
    WHEN '0210'.
      CHECK BKNB1-SPERR(1) NE NODATA.
    WHEN '0215'.
      CHECK BKNB1-SPERR(1) NE NODATA.
    WHEN '0220'.
      CHECK BKNB1-SPERR(1) NE NODATA.
    WHEN '0230'.
      CHECK BKNB1-SPERR(1) NE NODATA.
    WHEN '0310'.
      CHECK BKNVV-AUFSD(1) NE NODATA
      OR    BKNVV-LIFSD(1) NE NODATA
      OR    BKNVV-FAKSD(1) NE NODATA.
    WHEN '0315'.
      CHECK BKNVV-AUFSD(1) NE NODATA
      OR    BKNVV-LIFSD(1) NE NODATA
      OR    BKNVV-FAKSD(1) NE NODATA.
    WHEN '0320'.
      CHECK BKNVV-AUFSD(1) NE NODATA
      OR    BKNVV-LIFSD(1) NE NODATA
      OR    BKNVV-FAKSD(1) NE NODATA.
    WHEN '0324'.
      CHECK BKNVV-AUFSD(1) NE NODATA
      OR    BKNVV-LIFSD(1) NE NODATA
      OR    BKNVV-FAKSD(1) NE NODATA.
    WHEN '0326'.
      CHECK BKNVV-AUFSD(1) NE NODATA
      OR    BKNVV-LIFSD(1) NE NODATA
      OR    BKNVV-FAKSD(1) NE NODATA.
    WHEN OTHERS.
      EXIT.
  ENDCASE.
* end P30K113875

*------- auf Sperrbild springen ----------------------------------------
  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '0510'.
  APPEND FT.

*------- Sperrdaten auf Dynpro stellen und zurückspringen -------------
  PERFORM DYNPRO_FUELLEN USING '0510'.
  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/03'.
  APPEND FT.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.

* begin P30K113875
* Sperre wurde gesetzt
  SPERRE_GESETZT = 'X'.
* end P30K113875
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  INIT_DEBI_STRUKTUREN
*-----------------------------------------------------------------------
*        Debitor-Strukturen mit Initialstrukturen 'initialisieren'.
*-----------------------------------------------------------------------
FORM INIT_DEBI_STRUKTUREN.
  REFRESH: XBKNBK,
           XBKNEX,
           XBKNVA,
           XBKNVD,
           XBKNVI,
           XBKNVK,
           XBKNVL,
           XBKNVP,
           XBKNZA,
*mi/46a begin
           XBWRF12,
           XBWRF4.
*mi/46a end

  BKNA1   = I_BKNA1.
  BKNB1   = I_BKNB1.
  BKNB5   = I_BKNB5.
  BKNVV   = I_BKNVV.
  BKNEX   = I_BKNEX.
  BKNVA   = I_BKNVA.
  BKNVD   = I_BKNVD.
  BKNVI   = I_BKNVI.
  BKNVK   = I_BKNVK.
  XBKNVK  = I_BKNVK.                                     "ms/46a
  BKNVL   = I_BKNVL.
  BKNVP   = I_BKNVP.
  BKNKA   = I_BKNKA.
  BKNKK   = I_BKNKK.
  BKNZA   = I_BKNZA.
*mi/46a begin
  BWRF12  = I_BWRF12.
  BWRF4   = I_BWRF4.
*mi/46a end
  BIADDR2 = I_BIADDR2.                                   "ms/46a
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  KEY_FELDER_FUELLEN
*-----------------------------------------------------------------------
*        Key-Felder auf Einstiegsbilder übertragen.
*        Wegen SPA/GPA-Parametern, müssen auf dem Einstiegsbild die
*        Felder mit Space übergeben werden, falls sie nicht
*        explizit gefüllt wurden.
*-----------------------------------------------------------------------
FORM KEY_FELDER_FUELLEN.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'RF02D-KUNNR'.
  IF BKN00-KUNNR(1) NE NODATA.
    FT-FVAL = BKN00-KUNNR.
  ELSE.
    FT-FVAL = SPACE.
  ENDIF.
  APPEND FT.

  CLEAR FT.
  FT-FNAM = 'RF02D-BUKRS'.
  IF BKN00-BUKRS(1) NE NODATA.
    FT-FVAL = BKN00-BUKRS.
  ELSE.
    FT-FVAL = SPACE.
  ENDIF.
  APPEND FT.

  CLEAR FT.
  FT-FNAM = 'RF02D-VKORG'.
  IF BKN00-VKORG(1) NE NODATA.
    FT-FVAL = BKN00-VKORG.
  ELSE.
    FT-FVAL = SPACE.
  ENDIF.
  APPEND FT.

  CLEAR FT.
  FT-FNAM = 'RF02D-VTWEG'.
  IF BKN00-VTWEG(1) NE NODATA.
    FT-FVAL = BKN00-VTWEG.
  ELSE.
    FT-FVAL = SPACE.
  ENDIF.
  APPEND FT.

  CLEAR FT.
  FT-FNAM = 'RF02D-SPART'.
  IF BKN00-SPART(1) NE NODATA.
    FT-FVAL = BKN00-SPART.
  ELSE.
    FT-FVAL = SPACE.
  ENDIF.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  KNA1_ZUSATZDATEN
*-----------------------------------------------------------------------
*        KNA1-Zusatzdaten übertragen (neu zu 2.1B)
*-----------------------------------------------------------------------
FORM KNA1_ZUSATZDATEN.

*------- Wurden KNA1-Zusatzdaten übergeben ? --------------------------
  KNA1_ZUDA = 'X'.
  CHECK BKNA1-KATR1(1) NE NODATA
  OR    BKNA1-KATR2(1) NE NODATA
  OR    BKNA1-KATR3(1) NE NODATA
  OR    BKNA1-KATR4(1) NE NODATA
  OR    BKNA1-KATR5(1) NE NODATA
  OR    BKNA1-KATR6(1) NE NODATA
  OR    BKNA1-KATR7(1) NE NODATA
  OR    BKNA1-KATR8(1) NE NODATA
  OR    BKNA1-KATR9(1) NE NODATA
  OR    BKNA1-KATR10(1) NE NODATA
  OR    BKNA1-KDKG1(1) NE NODATA
  OR    BKNA1-KDKG2(1) NE NODATA
  OR    BKNA1-KDKG3(1) NE NODATA
  OR    BKNA1-KDKG4(1) NE NODATA
  OR    BKNA1-KDKG5(1) NE NODATA.

*------- KNA1-Zusatzdaten übertragen ----------------------------------
  PERFORM OKCODE_ZUDA.
  PERFORM DYNPRO_FUELLEN USING 'Z100'.
* perform okcode_f03.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  XDYTR = 'X'.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  KNVA_ZEITEN_BEARBEITEN
*-----------------------------------------------------------------------
*        Warenannahmezeiten prüfen/Übertragen
*-----------------------------------------------------------------------
FORM KNVA_ZEITEN_BEARBEITEN.

*------- Wurden Warenannahmezeiten oder eine ID übergeben? ------------
  CHECK XBKNVA-WANID(1) NE NODATA
  OR    XBKNVA-MOAB1(1) NE NODATA
  OR    XBKNVA-MOBI1(1) NE NODATA
  OR    XBKNVA-MOAB2(1) NE NODATA
  OR    XBKNVA-MOBI2(1) NE NODATA
  OR    XBKNVA-DIAB1(1) NE NODATA
  OR    XBKNVA-DIBI1(1) NE NODATA
  OR    XBKNVA-DIAB2(1) NE NODATA
  OR    XBKNVA-DIBI2(1) NE NODATA
  OR    XBKNVA-MIAB1(1) NE NODATA
  OR    XBKNVA-MIBI1(1) NE NODATA
  OR    XBKNVA-MIAB2(1) NE NODATA
  OR    XBKNVA-MIBI2(1) NE NODATA
  OR    XBKNVA-DOAB1(1) NE NODATA
  OR    XBKNVA-DOBI1(1) NE NODATA
  OR    XBKNVA-DOAB2(1) NE NODATA
  OR    XBKNVA-DOBI2(1) NE NODATA
  OR    XBKNVA-FRAB1(1) NE NODATA
  OR    XBKNVA-FRBI1(1) NE NODATA
  OR    XBKNVA-FRAB2(1) NE NODATA
  OR    XBKNVA-FRBI2(1) NE NODATA
  OR    XBKNVA-SAAB1(1) NE NODATA
  OR    XBKNVA-SABI1(1) NE NODATA
  OR    XBKNVA-SAAB2(1) NE NODATA
  OR    XBKNVA-SABI2(1) NE NODATA
  OR    XBKNVA-SOAB1(1) NE NODATA
  OR    XBKNVA-SOBI1(1) NE NODATA
  OR    XBKNVA-SOAB2(1) NE NODATA
  OR    XBKNVA-SOBI2(1) NE NODATA.

*------- Delete-Flag gesetzt? -----------------------------------------
  IF XBKNVA-XDELE EQ 'X'.
    MESSAGE I180 WITH XBKNVA-ABLAD.
    MESSAGE I181.
    EXIT.
  ENDIF.

*------- WANID prüfen,ggf. Zeiten übernehmen --------------------------
  IF  XBKNVA-WANID(1) NE NODATA
  AND XBKNVA-WANID    NE SPACE.
    IF TVWA-WANID NE XBKNVA-WANID.
      SELECT SINGLE * FROM TVWA WHERE WANID = XBKNVA-WANID.
      IF SY-SUBRC NE 0.
        MESSAGE I182 WITH XBKNVA-ABLAD 'TVWA'.
        MESSAGE I181.
      ELSE.
        MESSAGE I183 WITH XBKNVA-ABLAD XBKNVA-WANID.
        MESSAGE I188 WITH 'TVWA'.
        MESSAGE I184.
      ENDIF.
    ELSE.
      MESSAGE I183 WITH XBKNVA-ABLAD XBKNVA-WANID.
      MESSAGE I184.
    ENDIF.
  ENDIF.

*------- neue Annahmezeiten-ID und /oder Zeiten übertragen ------------
  PERFORM OKCODE_KNVA.
  PERFORM DYNPRO_FUELLEN USING '1340'.
* perform okcode_f03.                      "S11K144454/3.0
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  XDYTR = 'X'.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  KNVV_ZUSATZDATEN
*-----------------------------------------------------------------------
*        KNVV-Zusatzdaten übertragen (neu zu 2.1B)
*-----------------------------------------------------------------------
FORM KNVV_ZUSATZDATEN.

*------- Wurden KNVV-Zusatzdaten übergeben ? --------------------------
  KNVV_ZUDA = 'X'.
  CHECK BKNVV-KVGR1(1) NE NODATA
  OR    BKNVV-KVGR2(1) NE NODATA
  OR    BKNVV-KVGR3(1) NE NODATA
  OR    BKNVV-KVGR4(1) NE NODATA
  OR    BKNVV-KVGR5(1) NE NODATA.

*------- KNA1-Zusatzdaten übertragen ----------------------------------
  PERFORM OKCODE_ZUDA.
  PERFORM DYNPRO_FUELLEN USING 'Z200'.
* perform okcode_f03.
  PERFORM DYNPRO_BEGIN USING REP_NAME_D DYNTAB-DYNNR.
  XDYTR = 'X'.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  KOPFSATZ_BEARBEITEN
*-----------------------------------------------------------------------
*        Bearbeiten der eingelesenen Kopfdaten
*-----------------------------------------------------------------------
FORM KOPFSATZ_BEARBEITEN.
* Daten werden wegen der Feldlänge-Erweiterung des Feldes TCODE
* von 4B (<4.0) auf 20B verschoben
  IF OS_XON = XON.
    SHIFT WA BY 16 PLACES RIGHT.
    WA(21) = WA+16(5).
  ENDIF.
  BKN00 = WA.
  TRANS_COUNT = TRANS_COUNT + 1.
  PERFORM DYNTAB_AUFBAUEN.

*------ Place to set a soft break-point -------------------------------
  IF TRANS_COUNT = TRANS_BREAK.
    TRANS_BREAK = TRANS_COUNT.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  KOPFSATZ_LESEN
*-----------------------------------------------------------------------
*        Kopfdaten in Workarea lesen
*-----------------------------------------------------------------------
FORM KOPFSATZ_LESEN.
  CLEAR WA.
  READ DATASET DS_NAME INTO WA.

*------- End of File erreicht ? --> Exit -------------------------------
  IF SY-SUBRC NE 0.
    XEOF = 'X'.
    EXIT.
  ENDIF.

  IF WA(1) NE '1'.
    MESSAGE I101 WITH GROUP_COUNT.
    MESSAGE I015.
    PERFORM DUMP_WA USING 'BGR00'.
    MESSAGE A013.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  LIZENZEN_PRUEFEN
*-----------------------------------------------------------------------
*        Lizenzdaten auf Vollständigkeit prüfen
*-----------------------------------------------------------------------
FORM LIZENZEN_PRUEFEN.
  LOOP AT XBKNVL.
    IF XBKNVL-ALAND NE NODATA
    OR XBKNVL-TATYP NE NODATA
    OR XBKNVL-LICNR NE NODATA
    OR XBKNVL-BELIC NE NODATA
    OR XBKNVL-DATAB NE NODATA
    OR XBKNVL-DATBI NE NODATA.
      IF XBKNVL-ALAND = NODATA
      OR XBKNVL-ALAND = SPACE
      OR XBKNVL-TATYP = NODATA
      OR XBKNVL-TATYP = SPACE
      OR XBKNVL-LICNR = NODATA
      OR XBKNVL-LICNR = SPACE.
        IF  BKNA1-NAME1 NE SPACE
        AND BKNA1-NAME1 NE NODATA.
          MESSAGE I194 WITH BKNA1-NAME1.
        ELSE.
          MESSAGE I194 WITH BKN00-KUNNR.
        ENDIF.
        MESSAGE I195 WITH XBKNVL-ALAND XBKNVL-TATYP XBKNVL-LICNR.
        MESSAGE I196 WITH XBKNVL-BELIC XBKNVL-DATAB XBKNVL-DATBI.
        DELETE XBKNVL.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  MAPPE_OEFFNEN
*-----------------------------------------------------------------------
*        Öffnen der BDC-Queue für Datentransfer
*-----------------------------------------------------------------------
FORM MAPPE_OEFFNEN.
  CALL FUNCTION 'BDC_OPEN_GROUP'
       EXPORTING
            CLIENT   = BGR00-MANDT
            GROUP    = BGR00-GROUP
            HOLDDATE = BGR00-START
            KEEP     = BGR00-XKEEP
            USER     = BGR00-USNAM.
  MESSAGE I007 WITH GROUP_COUNT BGR00-GROUP.
  GROUP_OPEN = 'X'.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  mappe_pruefen_oeffnen
*-----------------------------------------------------------------------
*        Prüfen/Bearbeiten der Daten im Mappenvorsatz.
*        Sonderzeichen für NODATA bestimmen
*        Öffnen der BDC-Queue für Datentransfer
*        Initialstrukturen mit NODATA erzeugen
*-----------------------------------------------------------------------
FORM MAPPE_PRUEFEN_OEFFNEN.
  CLEAR BGR00.
  BGR00 = WA.
  GROUP_COUNT = GROUP_COUNT + 1.

*------- Mappenname gesetzt? -------------------------------------------
  IF BGR00-GROUP = SPACE.
    MESSAGE I011 WITH GROUP_COUNT.
    MESSAGE I015.
    PERFORM DUMP_WA USING 'BGR00'.
    MESSAGE A013.
  ENDIF.

*------- Mandant gesetzt/ richtig gesetzt ? ----------------------------
  IF BGR00-MANDT IS INITIAL.
    MESSAGE I005 WITH GROUP_COUNT.
    MESSAGE I015.
    PERFORM DUMP_WA USING 'BGR00'.
    MESSAGE A013.
  ENDIF.
  IF BGR00-MANDT NE SY-MANDT.
    MESSAGE I006 WITH GROUP_COUNT BGR00-MANDT SY-MANDT.
    MESSAGE I015.
    PERFORM DUMP_WA USING 'BGR00'.
    MESSAGE A013.
  ENDIF.

*------- Username gesetzt ----------------------------------------------
  IF BGR00-USNAM = SPACE.
    MESSAGE I009 WITH GROUP_COUNT.
    MESSAGE I015.
    PERFORM DUMP_WA USING 'BGR00'.
    MESSAGE A013.
  ENDIF.

*------- Sonderzeichen NODATA prüfen / übernehmen ---------------------
  IF BGR00-NODATA(1) = SPACE.
    NODATA = C_NODATA.
  ELSE.
    IF BGR00-NODATA BETWEEN '0' AND '9'
    OR BGR00-NODATA BETWEEN 'A' AND 'I'
    OR BGR00-NODATA BETWEEN 'J' AND 'R'
    OR BGR00-NODATA BETWEEN 'S' AND 'Z'
    OR BGR00-NODATA BETWEEN 'a' AND 'i'
    OR BGR00-NODATA BETWEEN 'j' AND 'r'
    OR BGR00-NODATA BETWEEN 's' AND 'z'.
      MESSAGE I010 WITH GROUP_COUNT BGR00-NODATA.
      MESSAGE I015.
      PERFORM DUMP_WA USING 'BGR00'.
      MESSAGE A013.
    ENDIF.
    NODATA = BGR00-NODATA.
  ENDIF.
  MESSAGE I012 WITH GROUP_COUNT NODATA.

*------- Mappe öffnen --------------------------------------------------
  IF  FL_CHECK = SPACE
  AND XCALL    = SPACE.
    PERFORM MAPPE_OEFFNEN.
  ENDIF.

*------- Flags, Zähler initialisieren ----------------------------------
  CLEAR: XNEWG, TRANS_COUNT, SATZ2_COUNT.

*------- Initialstrukturen erzeugen (NODATA-Sonderzeichen ) ------------
  IF NODATA NE NODATA_OLD.
    PERFORM INIT_STRUKTUREN_ERZEUGEN(RFBIDEI0) USING NODATA.
    PERFORM INIT_BKNA1(RFBIDEI0) USING I_BKNA1.
    PERFORM INIT_BKNBK(RFBIDEI0) USING I_BKNBK.

    PERFORM INIT_BKNB1(RFBIDEI0) USING I_BKNB1.
    PERFORM INIT_BKNB5(RFBIDEI0) USING I_BKNB5.

    PERFORM INIT_BKNKA(RFBIDEI0) USING I_BKNKA.
    PERFORM INIT_BKNKK(RFBIDEI0) USING I_BKNKK.

    PERFORM INIT_BKNVV(RFBIDEI0) USING I_BKNVV.
    PERFORM INIT_BKNEX(RFBIDEI0) USING I_BKNEX.
    PERFORM INIT_BKNVA(RFBIDEI0) USING I_BKNVA.
    PERFORM INIT_BKNVD(RFBIDEI0) USING I_BKNVD.
    PERFORM INIT_BKNVI(RFBIDEI0) USING I_BKNVI.
    PERFORM INIT_BKNVK(RFBIDEI0) USING I_BKNVK.
    PERFORM INIT_BKNVL(RFBIDEI0) USING I_BKNVL.
    PERFORM INIT_BKNVP(RFBIDEI0) USING I_BKNVP.
*mi/46a begin
    PERFORM INIT_BWRF12(RFBIDEI0) USING I_BWRF12.
    PERFORM INIT_BWRF4(RFBIDEI0) USING I_BWRF4.
*mi/46a end
    PERFORM INIT_BIADDR2(RFBIDEI0) USING I_BIADDR2.      "ms/46a
    NODATA_OLD = NODATA.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  MAPPE_SCHLIESSEN
*-----------------------------------------------------------------------
FORM MAPPE_SCHLIESSEN.
  IF FL_CHECK = SPACE.
    IF GROUP_OPEN = 'X'.
      CALL FUNCTION 'BDC_CLOSE_GROUP'.
      MESSAGE I008 WITH GROUP_COUNT BGR00-GROUP.
      CLEAR GROUP_OPEN.
    ENDIF.
  ELSE.
    MESSAGE I019 WITH GROUP_COUNT BGR00-GROUP.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  MAPPEN_WECHSEL
*-----------------------------------------------------------------------
*        Neuer Mappenvorsatz wurde gesendet.
*        Aktuelle Mappe wird geschlosssen, neue Mappe geöffnet.
*-----------------------------------------------------------------------
FORM MAPPEN_WECHSEL.
  PERFORM MAPPE_SCHLIESSEN.
  PERFORM MAPPE_PRUEFEN_OEFFNEN.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  MESSAGE_AUSGEBEN
*-----------------------------------------------------------------------
*        'Call Transaction .. Using ..'
*        Meldung ins Protokoll ausgeben.
*-----------------------------------------------------------------------
FORM MESSAGE_CALL_TRANSACTION.

*------- neuer Eintrag aus T100 ----------------------------------------
  IF T100-SPRSL NE SY-LANGU
  OR T100-ARBGB NE SY-MSGID
  OR T100-MSGNR NE SY-MSGNO.
    CLEAR: TEXT, TEXT1, TEXT2, TEXT3, MSGVN.
    SELECT SINGLE * FROM T100 WHERE SPRSL = SY-LANGU
                              AND   ARBGB = SY-MSGID
                              AND   MSGNR = SY-MSGNO.
    IF SY-SUBRC = 0.
      TEXT = T100-TEXT.
      DO 4 TIMES VARYING MSGVN FROM SY-MSGV1 NEXT SY-MSGV2.
        IF TEXT CA '$'.
          REPLACE '$' WITH MSGVN INTO TEXT.
          CONDENSE TEXT.
        ENDIF.
        IF TEXT CA '&'.
          REPLACE '&' WITH MSGVN INTO TEXT.
          CONDENSE TEXT.
        ENDIF.
      ENDDO.
      TEXT1 = TEXT(40).
      TEXT2 = TEXT+40(40).
      TEXT3 = TEXT+80(40).
      MESSAGE I130 WITH TRANS_COUNT TEXT1 TEXT2 TEXT3.
    ELSE.
      MESSAGE I131 WITH TRANS_COUNT SY-MSGNO SY-MSGV1 SY-MSGV2.
    ENDIF.

*------- gleicher Eintrag aus T100 -------------------------------------
  ELSE.
    IF TEXT NE SPACE.
      CLEAR: TEXT, TEXT1, TEXT2, TEXT3, MSGVN.
      TEXT = T100-TEXT.
      DO 4 TIMES VARYING MSGVN FROM SY-MSGV1 NEXT SY-MSGV2.
        IF TEXT CA '$'.
          REPLACE '$' WITH MSGVN INTO TEXT.
          CONDENSE TEXT.
        ENDIF.
        IF TEXT CA '&'.
          REPLACE '&' WITH MSGVN INTO TEXT.
          CONDENSE TEXT.
        ENDIF.
      ENDDO.
      TEXT1 = TEXT(40).
      TEXT2 = TEXT+40(40).
      TEXT3 = TEXT+80(40).
      MESSAGE I130 WITH TRANS_COUNT TEXT1 TEXT2 TEXT3.
    ELSE.
      MESSAGE I131 WITH TRANS_COUNT SY-MSGNO SY-MSGV1 SY-MSGV2.
    ENDIF.
  ENDIF.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_ATTR
*-----------------------------------------------------------------------
*        OK-Code 'ATTR' für Attribute der Partner übergeben
*-----------------------------------------------------------------------
FORM OKCODE_ATTR.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = 'ATTR'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_BACK
*-----------------------------------------------------------------------
*        OK-Code 'BACK': 'Popup beenden'.
*-----------------------------------------------------------------------
FORM OKCODE_BACK.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/13'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_BANK
*-----------------------------------------------------------------------
*        OK-Code F16 'Bankanschrift' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_BANK.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/16'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_F03
*-----------------------------------------------------------------------
*        OK-Code F03 'Zurück' übergeben (call-Dynpros ohne DREQ)
*-----------------------------------------------------------------------
FORM OKCODE_F03.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/03'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_F09
*-----------------------------------------------------------------------
*        OK-Code F09 übergeben (z.B. Besuchszeiten KNVK)
*-----------------------------------------------------------------------
FORM OKCODE_F09.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/09'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_F11
*-----------------------------------------------------------------------
*        OK-Code F11 'Sichern' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_F11.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/11'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_F14
*-----------------------------------------------------------------------
*        OK-Code F14 'Zeile löschen' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_F14.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/14'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_F16
*-----------------------------------------------------------------------
*        OK-Code F16 'Branchencodes' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_F16.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/16'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_KNVA
*-----------------------------------------------------------------------
*        OK-Code F02 'Warenannahmezeiten' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_KNVA.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/02'.
  APPEND FT.
ENDFORM.

*mi/46a begin
*-----------------------------------------------------------------------
*        Form  OKCODE_F19
*-----------------------------------------------------------------------
*        OK-Code F19 'Empfangsstellen' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_F19.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/19'.
  APPEND FT.
ENDFORM.

*-----------------------------------------------------------------------
*        Form  OKCODE_F25
*-----------------------------------------------------------------------
*        OK-Code F25 'Abteilungen' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_F25.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/25'.
  APPEND FT.
ENDFORM.
*mi/46a end

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_KNVK
*-----------------------------------------------------------------------
*        OK-Code F02 'Partner-Detail' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_KNVK.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/02'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_KNVL
*-----------------------------------------------------------------------
*        OK-Code F02 'Lizenzen' übergeben
*-----------------------------------------------------------------------
FORM OKCODE_KNVL.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/02'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_KNZA
*-----------------------------------------------------------------------
*        OK-Code 'KNZA': 'Abw. Regulierer'.
*-----------------------------------------------------------------------
FORM OKCODE_KNZA.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = 'KNZA'.
  APPEND FT.
ENDFORM.
*eject
*-----------------------------------------------------------------------
*        Form  OKCODE_POSZ
*-----------------------------------------------------------------------
*        OK-Code 'POSZ': 'Positionieren auf 1.Zeile'.
*-----------------------------------------------------------------------
FORM OKCODE_POSZ.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '/06'.
  APPEND FT.
ENDFORM.

*-----------------------------------------------------------------------
*        Form  OKCODE_ZUDA
*-----------------------------------------------------------------------
*        OK-Code 'ZUDA': Zusatzdaten übergeben (KNA1 und/oder KNVV)
*-----------------------------------------------------------------------
FORM OKCODE_ZUDA.
  CHECK FL_CHECK = SPACE.

  CLEAR FT.
  FT-FNAM = 'BDC_OKCODE'.
  FT-FVAL = '=ZUDA'.
  APPEND FT.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  parnr_uepar_pruefen
*-----------------------------------------------------------------------
*        Nur bis Release 2.1A:
*        Beim Hinzufügen darf KEINE Partnernummer übergeben werden
*        Ab Release 2.1A dürfen Nummern übergeben werden!
*-----------------------------------------------------------------------
FORM PARNR_UEPAR_PRUEFEN.
  IF  BKN00-TCODE  = 'XD01'
  AND XBKNVK-PARNR NE SPACE
  AND XBKNVK-PARNR(1) NE NODATA.
    MESSAGE I187 WITH BKNA1-NAME1 XBKNVK-PARNR.
    MESSAGE I189 WITH XBKNVK-NAME1.
    MESSAGE I186.
    CLEAR XBKNVK-PARNR.
    XBKNVK-PARNR(1) = NODATA.
  ENDIF.
  IF  BKN00-TCODE  = 'XD01'
  AND XBKNVK-UEPAR NE SPACE
  AND XBKNVK-UEPAR(1) NE NODATA.
    MESSAGE I185 WITH BKNA1-NAME1.
    MESSAGE I189 WITH XBKNVK-UEPAR.
    MESSAGE I186.
    CLEAR XBKNVK-UEPAR.
    XBKNVK-UEPAR(1) = NODATA.
  ENDIF.
  MODIFY XBKNVK.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  STEUERDATEN_PRUEFEN
*-----------------------------------------------------------------------
*        Steuerdaten: Land und Steuertyp MÜSSEN angegeben sein
*-----------------------------------------------------------------------
FORM STEUERDATEN_PRUEFEN.
  LOOP AT XBKNVI.
    IF XBKNVI-ALAND NE NODATA
    OR XBKNVI-TATYP NE NODATA
    OR XBKNVI-TAXKD NE NODATA.
      IF XBKNVI-ALAND = NODATA
      OR XBKNVI-ALAND = SPACE.
        IF  BKNA1-NAME1 NE SPACE
        AND BKNA1-NAME1 NE NODATA.
          MESSAGE I190 WITH BKNA1-NAME1 XBKNVI-TATYP XBKNVI-TAXKD.
        ELSE.
          MESSAGE I190 WITH BKN00-KUNNR XBKNVI-TATYP XBKNVI-TAXKD.
        ENDIF.
        MESSAGE I193.
        DELETE XBKNVI.
      ELSE.
        IF XBKNVI-TATYP = NODATA
        OR XBKNVI-TATYP = SPACE.
          IF  BKNA1-NAME1 NE SPACE
          AND BKNA1-NAME1 NE NODATA.
            MESSAGE I191 WITH BKNA1-NAME1 XBKNVI-ALAND XBKNVI-TAXKD.
          ELSE.
            MESSAGE I191 WITH BKN00-KUNNR XBKNVI-ALAND XBKNVI-TAXKD.
          ENDIF.
          MESSAGE I193.
          DELETE XBKNVI.
        ELSE.
          IF XBKNVI-TAXKD = NODATA
          OR XBKNVI-TAXKD = SPACE.
            IF  BKNA1-NAME1 NE SPACE
            AND BKNA1-NAME1 NE NODATA.
              MESSAGE I192 WITH BKNA1-NAME1 XBKNVI-ALAND XBKNVI-TATYP.
            ELSE.
              MESSAGE I192 WITH BKN00-KUNNR XBKNVI-ALAND XBKNVI-TATYP.
            ENDIF.
            MESSAGE I193.
            DELETE XBKNVI.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDFORM.

*eject
*-----------------------------------------------------------------------
*        Form  TRANSAKTION_SENDEN
*-----------------------------------------------------------------------
FORM TRANSAKTION_SENDEN.
  CHECK FL_CHECK = SPACE.

*------- Batch-Input erstellen -----------------------------------------
  IF XCALL = SPACE.
    CALL FUNCTION 'BDC_INSERT'
         EXPORTING
              TCODE     = BKN00-TCODE
         TABLES
              DYNPROTAB = FT.

*------- zunächst 'Call Transaction'; nur bei Fehlern Batch-Input ------
  ELSE.
    CALL TRANSACTION BKN00-TCODE USING  FT
                                 MODE   ANZ_MODE
                                 UPDATE UPDATE.
    SUBRC = SY-SUBRC.
    PERFORM MESSAGE_CALL_TRANSACTION.
    IF SUBRC NE 0.
      IF GROUP_OPEN NE 'X'.
        PERFORM MAPPE_OEFFNEN.
      ENDIF.
      CALL FUNCTION 'BDC_INSERT'
           EXPORTING
                TCODE     = BKN00-TCODE
           TABLES
                DYNPROTAB = FT.
    ENDIF.
  ENDIF.

*------- Commit Work? ------------------------------------------------
  COMMIT_COUNT = COMMIT_COUNT + 1.
  IF COMMIT_COUNT = MAX_COMMIT.
    COMMIT WORK.
    CLEAR COMMIT_COUNT.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  T001_DATEN_ERMITTELN
*&---------------------------------------------------------------------*
*       Ermitteln der Buchungskreisdaten aus Tabelle T001.
*
* Bemerkung:
*  - die Buchungskreisdaten werden für die Südamerika-Lösung der
*    erweiterten Quellensteuer benötigt
*  - Static-Tabellen behalten ihre Lebensdauer solange bis die
*    aufrufende Transaktion beendet ist (ähnlich zu globalen Variablen
*    in Funktionsgruppen).
*----------------------------------------------------------------------*
FORM T001_DATEN_ERMITTELN.
  STATICS: BEGIN OF T_T001 OCCURS 5.
          INCLUDE STRUCTURE T001.
  STATICS: END OF T_T001.
  DATA: LOK_TABIX LIKE SY-TABIX.       "Hilfsvariable

  CHECK BKN00-BUKRS <> SPACE.

  READ TABLE T_T001 WITH KEY BUKRS = BKN00-BUKRS
        BINARY SEARCH.

  IF SY-SUBRC = 0.
    T001 = T_T001.
  ELSE.
    LOK_TABIX = SY-TABIX.       "Sy-tabix merken für evtl. Einfügen
  ENDIF.

* Form-Routine verlassen wenn Daten bereits gefunden
  CHECK SY-SUBRC <> 0.

  SELECT SINGLE * FROM  T001
         WHERE  BUKRS  = BKN00-BUKRS.
  IF SY-SUBRC = 0.
    INSERT T001 INTO T_T001 INDEX LOK_TABIX.
  ENDIF.

ENDFORM.                               " T001_DATEN_ERMITTELN

*eject
*-----------------------------------------------------------------------
*        FORM  WA_UEBERTRAGEN                                          *
*-----------------------------------------------------------------------
*        Daten aus Workareas in Strukturen übertragen.
*        Prüfung, ob der entrprechende Bereich bearbeitet werden kann.
*        D.h.: Die entsprechenden Kennz. XASEG, XBUKR, XVKOR
*              müssen sitzen.
*        BKNA1, BKNB1, BKNB5, BKNVV dürfen je Transaktion
*              nur einmal übergeben werden.
*        BKNBK, BKNZA (Multiple Tabelle) darf mehrmals übergeben werden,
*        ebenso BKNVA/D/I/K/L/P/EX.
*-----------------------------------------------------------------------
FORM WA_UEBERTRAGEN.
  CASE WA+1(10).

*-----------------------------------------------------------------------
*        BKNA1 Allgemeine Daten
*-----------------------------------------------------------------------
    WHEN 'BKNA1'.
* Daten werden wegen der Feldlänge-Erweiterung des Feldes SPRAS
* von 1B (<4.0) auf 2B verschoben
      IF OS_XON = XON.
        SHIFT WA BY 1 PLACES RIGHT.
        WA(339) = WA+1(338).
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNA1'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNA1 = WA.
        PERFORM DUMP_WA USING 'BKNA1'.
        MESSAGE A013.
      ENDIF.
      IF BKNA1 NE I_BKNA1.
        MESSAGE I107 WITH TRANS_COUNT SATZ2_COUNT 'BKNA1'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNA1 = WA.
        PERFORM DUMP_WA USING 'BKNA1'.
        MESSAGE A013.
      ENDIF.
* Konvertieren der internen 1-stelligen Sprachenlänge in die
* Ausgabelänge 2B.
      IF OS_XON = XON.
        TRANSLATE WA+337(1) TO UPPER CASE.
      ENDIF.   "vor 4.0 waren nur Großbuchstb. für die Sprache möglich

      BKNA1 = WA.
      PERFORM BKNA1_ERWEITERUNG_PRUEFEN.

*------- Keine A-Seg. Daten => keine A-Seg. Dynpros --------------------
      IF XT020-AKTYP = 'H'.
        BKNA1-SENDE = NODATA.
        IF BKNA1 = I_BKNA1.
          IF NOT ( BKN00-KTOKD = '0170' OR KNA1-DEAR6 = 'X' ).
            CLEAR BI-XASEG.
            DELETE DYNTAB WHERE DTYPE = 'A'.
          ENDIF.
        ENDIF.
      ENDIF.

* begin of j_1a
*-----------------------------------------------------------------------
*        BKNAT Steuerkategorien
*-----------------------------------------------------------------------
    WHEN 'BKNAT'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNAT'.
        PERFORM DUMP_BKN00.
        XBKNAT = I_BKNAT.
        XBKNAT = WA.
        PERFORM DUMP_BKNAT.
        MESSAGE A013.
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNAT'.
        PERFORM DUMP_BKN00.
        XBKNAT = I_BKNAT.
        XBKNAT = WA.
        PERFORM DUMP_BKNAT.
        MESSAGE A013.
      ENDIF.

      XBKNAT = I_BKNAT.
      XBKNAT = WA.

      APPEND XBKNAT.
* end of j_1a

*-----------------------------------------------------------------------
*        BKNBK Bankverbindungen
*-----------------------------------------------------------------------
    WHEN 'BKNBK'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNBK'.
        PERFORM DUMP_BKN00.
        XBKNBK = I_BKNBK.
        XBKNBK = WA.
        PERFORM DUMP_BKNBK.
        MESSAGE A013.
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNBK'.
        PERFORM DUMP_BKN00.
        XBKNBK = I_BKNBK.
        XBKNBK = WA.
        PERFORM DUMP_BKNBK.
        MESSAGE A013.
      ENDIF.
      XBKNBK = I_BKNBK.
      XBKNBK = WA.
      PERFORM BKNBK_ERWEITERUNG_PRUEFEN.
      IF  XBKNBK-DUMMY(1) NE NODATA
      AND XBKNBK-DUMMY    NE SPACE.
        XBKNBK-PROVZ = XBKNBK-DUMMY.
        XBKNBK-DUMMY = NODATA.
      ENDIF.
      APPEND XBKNBK.


*-----------------------------------------------------------------------
*        BKNB1 Buchungskreisdaten
*-----------------------------------------------------------------------
    WHEN 'BKNB1'.
      IF BI-XBUKR NE 'X'.
        MESSAGE I105 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNB1'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNB1 = WA.
        PERFORM DUMP_WA USING 'BKNB1'.
        MESSAGE A013.
      ENDIF.
      IF BKNB1 NE I_BKNB1.
        MESSAGE I107 WITH TRANS_COUNT SATZ2_COUNT 'BKNB1'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNB1 = WA.
        PERFORM DUMP_WA USING 'BKNB1'.
        MESSAGE A013.
      ENDIF.
      BKNB1 = WA.

      PERFORM BKNB1_ERWEITERUNG_PRUEFEN.

*------- Keine F-Seg. Daten => keine F-Seg. Dynpros --------------------
      IF XT020-AKTYP = 'H'.
        BKNB1-SENDE = NODATA.
        IF BKNB1 = I_BKNB1.
          CLEAR BI-XBUKR.
          LOOP AT DYNTAB WHERE DTYPE = 'F'.
            DELETE DYNTAB.
          ENDLOOP.
        ENDIF.
      ENDIF.

*-----------------------------------------------------------------------
*        BKNBW Quellensteuerdaten
*-----------------------------------------------------------------------
    WHEN 'BKNBW'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNBW'.
        PERFORM DUMP_BKN00.
        XBKNBW = I_BKNBW.
        XBKNBW = WA.
        PERFORM DUMP_BKNBW.
        MESSAGE A013.
      ENDIF.
      IF BI-XBUKR NE 'X'.
        MESSAGE I105 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNBW'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        XBKNBW = I_BKNBW.
        XBKNBW = WA.
        PERFORM DUMP_BKNBW.
        MESSAGE A013.
      ENDIF.

      XBKNBW = I_BKNBW.
      XBKNBW = WA.

      APPEND XBKNBW.

*-----------------------------------------------------------------------
*        BKNB5 Mahndaten
*-----------------------------------------------------------------------
    WHEN 'BKNB5'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNB5'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNB5 = WA.
        PERFORM DUMP_WA USING 'BKNB5'.
        MESSAGE A013.
      ENDIF.
      IF BI-XBUKR NE 'X'.
        MESSAGE I105 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNB5'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNB5 = WA.
        PERFORM DUMP_WA USING 'BKNB5'.
        MESSAGE A013.
      ENDIF.
      IF BKNB5 NE I_BKNB5.
        MESSAGE I107 WITH TRANS_COUNT SATZ2_COUNT 'BKNB5'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNB5 = WA.
        PERFORM DUMP_WA USING 'BKNB5'.
        MESSAGE A013.
      ENDIF.
      BKNB5 = WA.


*-----------------------------------------------------------------------
*        BLFZA Abw. Regulierer  (A und B-Segment)
*-----------------------------------------------------------------------
    WHEN 'BKNZA'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNZA'.
        PERFORM DUMP_BKN00.
        XBKNZA = I_BKNZA.
        XBKNZA = WA.
        PERFORM DUMP_BKNZA.
        MESSAGE A013.
      ENDIF.

      XBKNZA = I_BKNZA.
      XBKNZA = WA.

      IF XBKNZA-BUKRS = NODATA.
        XBKNZA-BUKRS = SPACE.
      ENDIF.

      IF BI-XASEG NE 'X' AND XBKNZA-BUKRS IS INITIAL.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNZA'.
        PERFORM DUMP_BKN00.
        PERFORM DUMP_BKNZA.
        MESSAGE A013.
      ENDIF.
      IF BI-XBUKR NE 'X' AND NOT XBKNZA-BUKRS IS INITIAL.
        MESSAGE I105 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNZA'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        PERFORM DUMP_BKNZA.
        MESSAGE A013.
      ENDIF.
      IF NOT XBKNZA-BUKRS IS INITIAL.
        IF XBKNZA-BUKRS NE BKN00-BUKRS.
          MESSAGE I139 WITH TRANS_COUNT XBKNZA-EMPFD XBKNZA-BUKRS.
          MESSAGE I140 WITH 'BKNZA-BUKRS'.
          MESSAGE I141 WITH 'BKNZA-BUKRS' BKN00-BUKRS.
          PERFORM DUMP_BKN00.
          MESSAGE I017.
          PERFORM DUMP_BKNZA.
          MESSAGE A013.
        ENDIF.
      ENDIF.
      APPEND XBKNZA.

*----------------------------------------------------------------------
*        BKNKA Kreditlimit zentral
*----------------------------------------------------------------------
    WHEN 'BKNKA'.
      IF XT020-DYNCL NE 'C'.
        MESSAGE I113 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNKA'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNKA = WA.
        PERFORM DUMP_WA USING 'BKNKA'.
        MESSAGE A013.
      ENDIF.
      IF BKNKA NE I_BKNKA.
        MESSAGE I107 WITH TRANS_COUNT SATZ2_COUNT 'BKNKA'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNKA = WA.
        PERFORM DUMP_WA USING 'BKNKA'.
        MESSAGE A013.
      ENDIF.
      BKNKA = WA.


*----------------------------------------------------------------------
*        BKNKK Kreditlimit Kontrollbereich
*----------------------------------------------------------------------
    WHEN 'BKNKK'.
      IF XT020-DYNCL NE 'C'.
        MESSAGE I113 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNKK'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNKK = WA.
        PERFORM DUMP_WA USING 'BKNKK'.
        MESSAGE A013.
      ENDIF.
      IF BI-XKKBR NE 'X'.
        MESSAGE I114 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNKK'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNKK = WA.
        PERFORM DUMP_WA USING 'BKNKK'.
        MESSAGE A013.
      ENDIF.
      IF BKNKK NE I_BKNKK.
        MESSAGE I107 WITH TRANS_COUNT SATZ2_COUNT 'BKNKK'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNKK = WA.
        PERFORM DUMP_WA USING 'BKNKK'.
        MESSAGE A013.
      ENDIF.
      BKNKK = WA.

      PERFORM BKNKK_ERWEITERUNG_PRUEFEN.

*-----------------------------------------------------------------------
*        BKNVV
*-----------------------------------------------------------------------
    WHEN 'BKNVV'.
      IF BI-XVKOR NE 'X'.
        MESSAGE I121 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNVV'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNVV = WA.
        PERFORM DUMP_WA USING 'BKNVV'.
        MESSAGE A013.
      ENDIF.
      IF BKNVV NE I_BKNVV.
        MESSAGE I107 WITH TRANS_COUNT SATZ2_COUNT 'BKNVV'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BKNVV = WA.
        PERFORM DUMP_WA USING 'BKNVV'.
        MESSAGE A013.
      ENDIF.
      BKNVV = WA.
      BKNVV-CHSPL = NODATA.                                      "mi/46a

*------- BKNVV-Erweiterung zu 4.6A: MEGRU, UEBTO, UNTTO, UEBTK ---------
      IF BKNVV-SENDE(1) NE NODATA.

*------- BKNVV-Erweiterung zu 4.0C: AGREL(1) ---------------------------
        IF BKNVV-MEGRU(1) NE NODATA.        "mi/46a

*------- BKNVV-Erweiterung zu 2.2A: PRFRE(1) ---------------------------
          IF BKNVV-AGREL(1) NE NODATA.

*------- BKNVV-Erweiterung zu 2.1B: KVGR1 - KVGR5 ----------------------
            IF BKNVV-PRFRE(1) NE NODATA.

*------- BKNVV-Erweiterung zu 2.1A: PERRL(2), BOKRE(1), KURST(4) -------
              IF BKNVV-KVGR1(1) NE NODATA.

*------- BKNVV-Erweiterung zu 2.0A: BEGRU(4) ---------------------------
                IF BKNVV-PERRL(1) NE NODATA.
                  BKNVV-BEGRU(1) = NODATA.
                ENDIF.

                BKNVV-PERRL(1) = NODATA.
                BKNVV-BOKRE(1) = NODATA.
                BKNVV-KURST(1) = NODATA.

              ENDIF.

              BKNVV-KVGR1(1) = NODATA.
              BKNVV-KVGR2(1) = NODATA.
              BKNVV-KVGR3(1) = NODATA.
              BKNVV-KVGR4(1) = NODATA.
              BKNVV-KVGR5(1) = NODATA.

            ENDIF.

            BKNVV-PRFRE(1) = NODATA.
            BKNVV-KABSS(1) = NODATA.
            BKNVV-KKBER(1) = NODATA.
            BKNVV-CASSD(1) = NODATA.
            BKNVV-RDOFF(1) = NODATA.
            BKNVV-KLABC(1) = NODATA.

          ENDIF.

          BKNVV-AGREL(1) = NODATA.

          IF XMESS_BKNVV-SENDE NE 'X'.
            MESSAGE I133 WITH TRANS_COUNT 'BKNVV' NODATA.
            MESSAGE I023 WITH 'BKNVV'.
            MESSAGE I024.
            MESSAGE I025 WITH 'BKNVV'.
            XMESS_BKNVV-SENDE = 'X'.
          ENDIF.

*mi/46a begin
        ENDIF.

        bknvv-megru(1) = nodata.
        bknvv-uebto(1) = nodata.
        bknvv-untto(1) = nodata.
        bknvv-uebtk(1) = nodata.
        bknvv-pvksm(1) = nodata.
        bknvv-podkz(1) = nodata.
*mi/46a end

      ENDIF.


*------- Keine V-Seg. Daten => keine V-Seg. Dynpros --------------------
      IF XT020-AKTYP = 'H'.
        BKNVV-SENDE = NODATA.
        IF BKNVV = I_BKNVV.
          CLEAR BI-XVKOR.
          LOOP AT DYNTAB WHERE DTYPE = 'V'.
            DELETE DYNTAB.
          ENDLOOP.
        ENDIF.
      ENDIF.

*-----------------------------------------------------------------------
*        BKNEX Außenhandel
*-----------------------------------------------------------------------
    WHEN 'BKNEX'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNEX'.
        PERFORM DUMP_BKN00.
        XBKNEX = I_BKNEX.
        XBKNEX = WA.
        PERFORM DUMP_BKNEX.
        MESSAGE A013.
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNEX'.
        PERFORM DUMP_BKN00.
        XBKNEX = I_BKNEX.
        XBKNEX = WA.
        PERFORM DUMP_BKNEX.
        MESSAGE A013.
      ENDIF.
      XBKNEX = I_BKNEX.
      XBKNEX = WA.
      APPEND XBKNEX.

*-----------------------------------------------------------------------
*        BKNVA Abladestellen
*-----------------------------------------------------------------------
    WHEN 'BKNVA'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNVA'.
        PERFORM DUMP_BKN00.
        XBKNVA = I_BKNVA.
        XBKNVA = WA.
        PERFORM DUMP_BKNVA.
        MESSAGE A013.
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNVA'.
        PERFORM DUMP_BKN00.
        XBKNVA = I_BKNVA.
        XBKNVA = WA.
        PERFORM DUMP_BKNVA.
        MESSAGE A013.
      ENDIF.
      XBKNVA = I_BKNVA.
      XBKNVA = WA.

*------- BKNVA-Erweiterung zu 1.3A: DEFAB -----------------------------
      IF XBKNVA-SENDE(1) NE NODATA.

        XBKNVA-DEFAB(1)    = NODATA.

        IF XMESS_BKNVA-SENDE NE 'X'.
          MESSAGE I133 WITH TRANS_COUNT 'BKNVA' NODATA.
          MESSAGE I023 WITH 'BKNVA'.
          MESSAGE I024.
          MESSAGE I025 WITH 'BKNVA'.
          XMESS_BKNVA-SENDE = 'X'.
        ENDIF.
      ENDIF.
      APPEND XBKNVA.

*mi/46a begin
*-----------------------------------------------------------------------
*        BWRF12 Empfangstellen
*-----------------------------------------------------------------------
    WHEN 'BWRF12'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BWRF12'.
        PERFORM DUMP_BKN00.
        XBWRF12 = I_BWRF12.
        XBWRF12 = WA.
        PERFORM DUMP_BWRF12.
        MESSAGE A013.
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BWRF12'.
        PERFORM DUMP_BKN00.
        XBWRF12 = I_BWRF12.
        XBWRF12 = WA.
        PERFORM DUMP_BWRF12.
        MESSAGE A013.
      ENDIF.
      XBWRF12 = I_BWRF12.
      XBWRF12 = WA.
      APPEND XBWRF12.

*-----------------------------------------------------------------------
*        BWRF4 Abteilungen
*-----------------------------------------------------------------------
    WHEN 'BWRF4'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BWRF4'.
        PERFORM DUMP_BKN00.
        XBWRF4 = I_BWRF4.
        XBWRF4 = WA.
        PERFORM DUMP_BWRF4.
        MESSAGE A013.
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BWRF4'.
        PERFORM DUMP_BKN00.
        XBWRF4 = I_BWRF4.
        XBWRF4 = WA.
        PERFORM DUMP_BWRF4.
        MESSAGE A013.
      ENDIF.
      XBWRF4 = I_BWRF4.
      XBWRF4 = WA.
      APPEND XBWRF4.
*mi/46a end

*-----------------------------------------------------------------------
*        BIADDR2 Privatadresse Konsument
*-----------------------------------------------------------------------
    WHEN 'BIADDR2'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BIADDR2'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BIADDR2 = WA.
        PERFORM DUMP_WA USING 'BIADDR2'.
        MESSAGE A013.
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BIADDR2'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BIADDR2 = WA.
        PERFORM DUMP_WA USING 'BIADDR2'.
        MESSAGE A013.
      ENDIF.
      IF BIADDR2 NE I_BIADDR2.
        MESSAGE I107 WITH TRANS_COUNT SATZ2_COUNT 'BIADDR2'.
        PERFORM DUMP_BKN00.
        MESSAGE I017.
        BIADDR2 = WA.
        PERFORM DUMP_WA USING 'BIADDR2'.
        MESSAGE A013.
      ENDIF.
      BIADDR2 = WA.

*-----------------------------------------------------------------------
*        BKNVK Ansprechpartner
*-----------------------------------------------------------------------
    WHEN 'BKNVK'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNVK'.
        PERFORM DUMP_BKN00.
        XBKNVK = I_BKNVK.
        XBKNVK = WA.
        PERFORM DUMP_BKNVK.
        MESSAGE A013.
      ENDIF.
      IF BI-XASEG NE 'X'.
        MESSAGE I104 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNVK'.
        PERFORM DUMP_BKN00.
        XBKNVK = I_BKNVK.
        XBKNVK = WA.
        PERFORM DUMP_BKNVK.
        MESSAGE A013.
      ENDIF.
      XBKNVK = I_BKNVK.
      XBKNVK = WA.

*------- BKNVK-Erweiterung zu 1.2A: SPNAM, TITEL_AP -------------------
      IF XBKNVK-SENDE(1) NE NODATA.

        XBKNVK-SPNAM(1)    = NODATA.
        XBKNVK-TITEL_AP(1) = NODATA.

        IF XMESS_BKNVK-SENDE NE 'X'.
          MESSAGE I133 WITH TRANS_COUNT 'BKNVK' NODATA.
          MESSAGE I023 WITH 'BKNVK'.
          MESSAGE I024.
          MESSAGE I025 WITH 'BKNVK'.
          XMESS_BKNVK-SENDE = 'X'.
        ENDIF.
      ENDIF.
      APPEND XBKNVK.

*-----------------------------------------------------------------------
*        BKNVD Nachrichten
*-----------------------------------------------------------------------
    WHEN 'BKNVD'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNVD'.
        PERFORM DUMP_BKN00.
        XBKNVD = I_BKNVD.
        XBKNVD = WA.
        PERFORM DUMP_BKNVD.
        MESSAGE A013.
      ENDIF.
      IF BI-XVKOR NE 'X'.
        MESSAGE I121 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNVD'.
        PERFORM DUMP_BKN00.
        XBKNVD = I_BKNVD.
        XBKNVD = WA.
        PERFORM DUMP_BKNVD.
        MESSAGE A013.
      ENDIF.
      XBKNVD = I_BKNVD.
      XBKNVD = WA.
      APPEND XBKNVD.

*-----------------------------------------------------------------------
*        BKNVI Steuern Vertrieb
*-----------------------------------------------------------------------
    WHEN 'BKNVI'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNVI'.
        PERFORM DUMP_BKN00.
        XBKNVI = I_BKNVI.
        XBKNVI = WA.
        PERFORM DUMP_BKNVI.
        MESSAGE A013.
      ENDIF.
      IF BI-XVKOR NE 'X'.
        MESSAGE I121 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNVI'.
        PERFORM DUMP_BKN00.
        XBKNVI = I_BKNVI.
        XBKNVI = WA.
        PERFORM DUMP_BKNVI.
        MESSAGE A013.
      ENDIF.
      XBKNVI = I_BKNVI.
      XBKNVI = WA.
      APPEND XBKNVI.

*-----------------------------------------------------------------------
*        BKNVL Lizenzen Vertrieb
*-----------------------------------------------------------------------
    WHEN 'BKNVL'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNVL'.
        PERFORM DUMP_BKN00.
        XBKNVL = I_BKNVL.
        XBKNVL = WA.
        PERFORM DUMP_BKNVL.
        MESSAGE A013.
      ENDIF.
      IF BI-XVKOR NE 'X'.
        MESSAGE I121 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNVL'.
        PERFORM DUMP_BKN00.
        XBKNVL = I_BKNVL.
        XBKNVL = WA.
        PERFORM DUMP_BKNVL.
        MESSAGE A013.
      ENDIF.
      XBKNVL = I_BKNVL.
      XBKNVL = WA.
      APPEND XBKNVL.

*-----------------------------------------------------------------------
*        BKNVP Partnerrollen
*-----------------------------------------------------------------------
    WHEN 'BKNVP'.
      IF XT020-FUNCL CA 'SL'.
        MESSAGE I110 WITH TRANS_COUNT 'BKNVP'.
        PERFORM DUMP_BKN00.
        XBKNVP = I_BKNVP.
        XBKNVP = WA.
        PERFORM DUMP_BKNVP.
        MESSAGE A013.
      ENDIF.
      IF BI-XVKOR NE 'X'.
        MESSAGE I121 WITH TRANS_COUNT BKN00-TCODE.
        MESSAGE I125 WITH 'BKNVP'.
        PERFORM DUMP_BKN00.
        XBKNVP = I_BKNVP.
        XBKNVP = WA.
        PERFORM DUMP_BKNVP.
        MESSAGE A013.
      ENDIF.
      XBKNVP = I_BKNVP.
      XBKNVP = WA.

*------- BKNVP-Erweiterung zu 3.0A: KNREF(30) -------------------------
      IF XBKNVP-SENDE(1) NE NODATA.

*------- BKNVP-Erweiterung zu 1.3A: DEFPA -----------------------------
        IF XBKNVP-KNREF(1) NE NODATA.
          XBKNVP-DEFPA(1)    = NODATA.
        ENDIF.

        XBKNVP-KNREF(1)    = NODATA.

        IF XMESS_BKNVP-SENDE NE 'X'.
          MESSAGE I133 WITH TRANS_COUNT 'BKNVP' NODATA.
          MESSAGE I023 WITH 'BKNVP'.
          MESSAGE I024.
          MESSAGE I025 WITH 'BKNVP'.
          XMESS_BKNVP-SENDE = 'X'.
        ENDIF.
      ENDIF.
      APPEND XBKNVP.

    WHEN OTHERS.
      MESSAGE I111 WITH TRANS_COUNT SATZ2_COUNT WA+1(10).
      PERFORM DUMP_BKN00.
      MESSAGE A013.
  ENDCASE.
ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  XBKNZA_SPLIT
*&---------------------------------------------------------------------*
*   XBKNZA (abw. Regulierer) auf A-Segm. (XBKNZAA) und
*   B-Segm. (XBKNZAB) verteilen
*----------------------------------------------------------------------*
FORM XBKNZA_SPLIT.
  CLEAR:   XBKNZAA, XBKNZAB.
  REFRESH: XBKNZAA, XBKNZAB.

  LOOP AT XBKNZA.
    IF XBKNZA-BUKRS IS INITIAL.
      CLEAR XBKNZAA.
      XBKNZAA = XBKNZA.
      APPEND XBKNZAA.
    ELSE.
      CLEAR XBKNZAB.
      XBKNZAB = XBKNZA.
      APPEND XBKNZAB.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  KNZA_VERARBEITUNG
*&---------------------------------------------------------------------*
*   Verarbeiten der uebergebenen abw. Regulierer (BKNZA)
*----------------------------------------------------------------------*
FORM KNZA_VERARBEITUNG.
  PERFORM OKCODE_KNZA.
  PERFORM DYNPRO_BEGIN  USING REP_NAME_D '1130'.
  PERFORM XBKNZA_LOOP.
  PERFORM DYNPRO_BEGIN  USING REP_NAME_D DYNTAB-DYNNR.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  XBKNZA_LOOP
*&---------------------------------------------------------------------*
*   Loop ueber die abw. Regulierer
*----------------------------------------------------------------------*
FORM XBKNZA_LOOP.
  CASE DYNTAB-DYNNR.
    WHEN '0130'.
      PERFORM XBKNZAA_LOOP.
    WHEN '0215'.
      PERFORM XBKNZAB_LOOP.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  XBKNZAA_LOOP
*&---------------------------------------------------------------------*
*   Loop ueber die abw. Regulierer im A-Segment (XBKNZAA)
*----------------------------------------------------------------------*
FORM XBKNZAA_LOOP.

  LOOP AT XBKNZA WHERE BUKRS IS INITIAL.
* Felder können durch Customizing ausgeblendet sein. Nur Übertragen
* wenn Daten dazu vorhanden
    CHECK XBKNZA-EMPFD(1) NE NODATA.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D3130_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING '1130'.
    PERFORM CURSOR_SETZEN_1130.
    IF XBKNZA-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM LINE_SELECT.
      PERFORM DYNPRO_BEGIN  USING REP_NAME_D '1130'.
      XDYTR = 'X'.
    ENDIF.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNZAA LINES REFE1.
  IF  REFE1 NE  0.
    IF XDYTR NE 'X'.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D '1130'.
    ENDIF.
    PERFORM OKCODE_BACK.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  XBKNZAB_LOOP
*&---------------------------------------------------------------------*
*   Loop ueber die abw. Regulierer im B-Segment (XBKNZAB)
*----------------------------------------------------------------------*
FORM XBKNZAB_LOOP.

  LOOP AT XBKNZA WHERE NOT BUKRS IS INITIAL.
* Felder können durch Customizing ausgeblendet sein. Nur Übertragen
* wenn Daten dazu vorhanden
    CHECK XBKNZA-EMPFD(1) NE NODATA.
    CLEAR XDYTR.
    PERFORM OKCODE_POSZ.
    PERFORM D3130_FUELLEN.
    PERFORM DYNPRO_FUELLEN USING '1130'.
    PERFORM CURSOR_SETZEN_1130.
    IF XBKNZA-XDELE = 'X'.
      PERFORM OKCODE_F14.
      PERFORM LINE_SELECT.
      PERFORM DYNPRO_BEGIN  USING REP_NAME_D '1130'.
      XDYTR = 'X'.
    ENDIF.
  ENDLOOP.

*------- Letzte Zeile abschicken ---------------------------------------
  DESCRIBE TABLE XBKNZAB LINES REFE1.
  IF  REFE1 NE  0.
    IF XDYTR NE 'X'.
      PERFORM DYNPRO_BEGIN USING REP_NAME_D '1130'.
    ENDIF.
    PERFORM OKCODE_BACK.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  LINE_SELECT
*&---------------------------------------------------------------------*
*   Den zu löschenden Eintrag selektieren
*----------------------------------------------------------------------*
FORM LINE_SELECT.
  CLEAR FT.
  FT-FNAM = 'SELECTED(01)'.
  FT-FVAL = 'X'.
  APPEND FT.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  D0112_FUELLEN
*&---------------------------------------------------------------------*
FORM D0112_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0112'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVK-PARGE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARGE                    '.
    FT-FVAL = XBKNVK-PARGE                   .
    APPEND FT.
  ENDIF.
  IF XBKNVK-GBDAT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-GBDAT                    '.
    FT-FVAL = XBKNVK-GBDAT                   .
    APPEND FT.
  ENDIF.
  IF XBKNVK-FAMST(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-FAMST                    '.
    FT-FVAL = XBKNVK-FAMST                   .
    APPEND FT.
  ENDIF.
  IF BIADDR2-TITLE_P                    NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-TITLE_MEDI        '.
     FT-FVAL = BIADDR2-TITLE_P               .
     APPEND FT.
  ENDIF.
  IF BIADDR2-FIRSTNAME                  NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-NAME_FIRST        '.
     FT-FVAL = BIADDR2-FIRSTNAME             .
     APPEND FT.
  ENDIF.
  IF BIADDR2-LASTNAME                   NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-NAME_LAST         '.
     FT-FVAL = BIADDR2-LASTNAME              .
     APPEND FT.
  ENDIF.
  IF BIADDR2-BIRTH_NAME                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-NAME2_P           '.
     FT-FVAL = BIADDR2-BIRTH_NAME            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-TITLE_ACA1                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-TITLE_ACA1        '.
     FT-FVAL = BIADDR2-TITLE_ACA1            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-TITLE_ACA2                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-TITLE_ACA2        '.
     FT-FVAL = BIADDR2-TITLE_ACA2            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-PREFIX1                    NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-PREFIX1           '.
     FT-FVAL = BIADDR2-PREFIX1               .
     APPEND FT.
  ENDIF.
  IF BIADDR2-PREFIX2                    NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-PREFIX2           '.
     FT-FVAL = BIADDR2-PREFIX2               .
     APPEND FT.
  ENDIF.
  IF BIADDR2-TITLE_SPPL                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-TITLE_SPPL        '.
     FT-FVAL = BIADDR2-TITLE_SPPL            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-NICKNAME                   NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-NICKNAME          '.
     FT-FVAL = BIADDR2-NICKNAME              .
     APPEND FT.
  ENDIF.
  IF BIADDR2-INITIALS                   NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-INITIALS          '.
     FT-FVAL = BIADDR2-INITIALS              .
     APPEND FT.
  ENDIF.
  IF BIADDR2-NAMEFORMAT                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-NAMEFORMAT        '.
     FT-FVAL = BIADDR2-NAMEFORMAT            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-NAMCOUNTRY                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-NAMCOUNTRY        '.
     FT-FVAL = BIADDR2-NAMCOUNTRY            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-LANGUP_ISO                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-LANGU_P           '.
     FT-FVAL = BIADDR2-LANGUP_ISO            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-SORT1_P                    NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-SORT1_P           '.
     FT-FVAL = BIADDR2-SORT1_P               .
     APPEND FT.
  ENDIF.
  IF BIADDR2-SORT2_P                    NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-SORT2_P           '.
     FT-FVAL = BIADDR2-SORT2_P               .
     APPEND FT.
  ENDIF.
  IF BIADDR2-C_O_NAME                   NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-NAME_CO           '.
     FT-FVAL = BIADDR2-C_O_NAME              .
     APPEND FT.
  ENDIF.
  IF BIADDR2-CITY                       NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-CITY1             '.
     FT-FVAL = BIADDR2-CITY                  .
     APPEND FT.
  ENDIF.
  IF BIADDR2-DISTRICT                   NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-CITY2             '.
     FT-FVAL = BIADDR2-DISTRICT              .
     APPEND FT.
  ENDIF.
  IF BIADDR2-POSTL_COD1                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-POST_CODE1        '.
     FT-FVAL = BIADDR2-POSTL_COD1            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-POSTL_COD2                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-POST_CODE2        '.
     FT-FVAL = BIADDR2-POSTL_COD2            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-PO_BOX                     NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-PO_BOX            '.
     FT-FVAL = BIADDR2-PO_BOX                .
     APPEND FT.
  ENDIF.
  IF BIADDR2-TRANSPZONE                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-TRANSPZONE        '.
     FT-FVAL = BIADDR2-TRANSPZONE            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-STREET                     NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-STREET            '.
     FT-FVAL = BIADDR2-STREET                .
     APPEND FT.
  ENDIF.
  IF BIADDR2-HOUSE_NO                   NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-HOUSE_NUM1        '.
     FT-FVAL = BIADDR2-HOUSE_NO              .
     APPEND FT.
  ENDIF.
  IF BIADDR2-HOUSE_NO2                  NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-HOUSE_NUM2        '.
     FT-FVAL = BIADDR2-HOUSE_NO2             .
     APPEND FT.
  ENDIF.
  IF BIADDR2-STR_SUPPL1                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-STR_SUPPL1        '.
     FT-FVAL = BIADDR2-STR_SUPPL1            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-STR_SUPPL2                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-STR_SUPPL2        '.
     FT-FVAL = BIADDR2-STR_SUPPL2            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-STR_SUPPL3                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-STR_SUPPL3        '.
     FT-FVAL = BIADDR2-STR_SUPPL3            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-LOCATION                   NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-LOCATION          '.
     FT-FVAL = BIADDR2-LOCATION              .
     APPEND FT.
  ENDIF.
  IF BIADDR2-FLOOR                      NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-FLOOR             '.
     FT-FVAL = BIADDR2-FLOOR                 .
     APPEND FT.
  ENDIF.
  IF BIADDR2-ROOM_NO                    NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-ROOMNUMBER        '.
     FT-FVAL = BIADDR2-ROOM_NO               .
     APPEND FT.
  ENDIF.
  IF BIADDR2-COUNTRY                    NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-COUNTRY           '.
     FT-FVAL = BIADDR2-COUNTRY               .
     APPEND FT.
  ENDIF.
  IF BIADDR2-REGION                     NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-REGION            '.
     FT-FVAL = BIADDR2-REGION                .
     APPEND FT.
  ENDIF.
  IF BIADDR2-TIME_ZONE                  NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-TIME_ZONE         '.
     FT-FVAL = BIADDR2-TIME_ZONE             .
     APPEND FT.
  ENDIF.
  IF BIADDR2-TAXJURCODE                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-TAXJURCODE        '.
     FT-FVAL = BIADDR2-TAXJURCODE            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-ADR_NOTES                  NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-REMARK            '.
     FT-FVAL = BIADDR2-ADR_NOTES             .
     APPEND FT.
  ENDIF.
  IF BIADDR2-COMM_TYPE                  NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-DEFLT_COMM        '.
     FT-FVAL = BIADDR2-COMM_TYPE             .
     APPEND FT.
  ENDIF.
  IF BIADDR2-TEL1_NUMBR                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-TEL_NUMBER        '.
     FT-FVAL = BIADDR2-TEL1_NUMBR            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-TEL1_EXT                   NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-TEL_EXTENS        '.
     FT-FVAL = BIADDR2-TEL1_EXT              .
     APPEND FT.
  ENDIF.
  IF BIADDR2-FAX_NUMBER                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-FAX_NUMBER        '.
     FT-FVAL = BIADDR2-FAX_NUMBER            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-FAX_EXTENS                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-FAX_EXTENS        '.
     FT-FVAL = BIADDR2-FAX_EXTENS            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-E_MAIL                     NE NODATA.
     CLEAR FT.
     FT-FNAM = 'SZA7_D0400-SMTP_ADDR         '.
     FT-FVAL = BIADDR2-E_MAIL                .
     APPEND FT.
  ENDIF.
  IF BIADDR2-BUILD_LONG                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-BUILDING          '.
     FT-FVAL = BIADDR2-BUILD_LONG            .
     APPEND FT.
  ENDIF.
  IF BIADDR2-REGIOGROUP                 NE NODATA.
     CLEAR FT.
     FT-FNAM = 'ADDR2_DATA-REGIOGROUP        '.
     FT-FVAL = BIADDR2-REGIOGROUP            .
     APPEND FT.
  ENDIF.
ENDFORM.                    " D0112_FUELLEN


*eject
************************************************************************
*        Generiertes Coding ......
*-----------------------------------------------------------
*        Generated  DATE 19990511.
*                   TIME 170329.
*                   USER SCHMITTMAT  .
*-----------------------------------------------------------

*eject
*----------------------------------------------------------
*        Form DYNPRO_FUELLEN
*----------------------------------------------------------
FORM DYNPRO_FUELLEN USING DYNNR.
  CHECK FL_CHECK = SPACE.
  CASE DYNNR.
    WHEN '0110'.
      PERFORM D0110_FUELLEN.
    WHEN '0120'.
      PERFORM D0120_FUELLEN.
    WHEN '0125'.
      PERFORM D0125_FUELLEN.
    WHEN '1250'.
      PERFORM D1250_FUELLEN.
    WHEN '0130'.
      PERFORM D0130_FUELLEN.
    WHEN '0340'.
      PERFORM D0340_FUELLEN.
    WHEN '1340'.
      PERFORM D1340_FUELLEN.
    WHEN '0370'.
      PERFORM D0370_FUELLEN.
    WHEN '0360'.
      PERFORM D0360_FUELLEN.
    WHEN '1360'.
      PERFORM D1360_FUELLEN.
    WHEN '1365'.
      PERFORM D1365_FUELLEN.
    WHEN '1366'.
      PERFORM D1366_FUELLEN.
    WHEN '0210'.
      PERFORM D0210_FUELLEN.
    WHEN '0215'.
      PERFORM D0215_FUELLEN.
    WHEN '0220'.
      PERFORM D0220_FUELLEN.
    WHEN '0230'.
      PERFORM D0230_FUELLEN.
    WHEN '0610'.
      PERFORM D0610_FUELLEN.
    WHEN '0310'.
      PERFORM D0310_FUELLEN.
    WHEN '0315'.
      PERFORM D0315_FUELLEN.
    WHEN '0320'.
      PERFORM D0320_FUELLEN.
    WHEN '1350'.
      PERFORM D1350_FUELLEN.
    WHEN '1355'.
      PERFORM D1355_FUELLEN.
    WHEN '0326'.
      PERFORM D0326_FUELLEN.
    WHEN '0324'.
      PERFORM D0324_FUELLEN.
    WHEN '0510'.
      PERFORM D0510_FUELLEN.
    WHEN '0520'.
      PERFORM D0520_FUELLEN.
    WHEN 'L120'.
      PERFORM DL120_FUELLEN.
    WHEN 'L210'.
      PERFORM DL210_FUELLEN.
    WHEN 'B100'.
      PERFORM DB100_FUELLEN.
    WHEN 'Z100'.
      PERFORM DZ100_FUELLEN.
    WHEN 'Z200'.
      PERFORM DZ200_FUELLEN.
    WHEN '0111'.
      PERFORM D0111_FUELLEN.
    WHEN '0112'.
      PERFORM D0112_FUELLEN.
    WHEN '1361'.
      PERFORM D1361_FUELLEN.
    WHEN '1130'.
      PERFORM D1130_FUELLEN.
  ENDCASE.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0110_FUELLEN
*----------------------------------------------------------
FORM D0110_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0110'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-ANRED(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-ANRED                    '.
    FT-FVAL = BKNA1-ANRED                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-NAME1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-NAME1                    '.
    FT-FVAL = BKNA1-NAME1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-SORTL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-SORTL                    '.
    FT-FVAL = BKNA1-SORTL                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-NAME2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-NAME2                    '.
    FT-FVAL = BKNA1-NAME2                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-NAME3(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-NAME3                    '.
    FT-FVAL = BKNA1-NAME3                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-NAME4(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-NAME4                    '.
    FT-FVAL = BKNA1-NAME4                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STRAS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STRAS                    '.
    FT-FVAL = BKNA1-STRAS                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-PFACH(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-PFACH                    '.
    FT-FVAL = BKNA1-PFACH                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-ORT01(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-ORT01                    '.
    FT-FVAL = BKNA1-ORT01                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-PSTLZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-PSTLZ                    '.
    FT-FVAL = BKNA1-PSTLZ                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-ORT02(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-ORT02                    '.
    FT-FVAL = BKNA1-ORT02                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-PFORT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-PFORT                    '.
    FT-FVAL = BKNA1-PFORT                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-PSTL2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-PSTL2                    '.
    FT-FVAL = BKNA1-PSTL2                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-LAND1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-LAND1                    '.
    FT-FVAL = BKNA1-LAND1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-REGIO(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-REGIO                    '.
    FT-FVAL = BKNA1-REGIO                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-SPRAS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-SPRAS                    '.
    FT-FVAL = BKNA1-SPRAS                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-TELX1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TELX1                    '.
    FT-FVAL = BKNA1-TELX1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-TELF1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TELF1                    '.
    FT-FVAL = BKNA1-TELF1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-TELFX(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TELFX                    '.
    FT-FVAL = BKNA1-TELFX                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-TELF2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TELF2                    '.
    FT-FVAL = BKNA1-TELF2                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-TELTX(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TELTX                    '.
    FT-FVAL = BKNA1-TELTX                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-TELBX(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TELBX                    '.
    FT-FVAL = BKNA1-TELBX                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-DATLT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-DATLT                    '.
    FT-FVAL = BKNA1-DATLT                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KNURL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KNURL                    '.
    FT-FVAL = BKNA1-KNURL                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0120_FUELLEN
*----------------------------------------------------------
FORM D0120_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0120'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-LIFNR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-LIFNR                    '.
    FT-FVAL = BKNA1-LIFNR                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-BEGRU(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BEGRU                    '.
    FT-FVAL = BKNA1-BEGRU                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KTOCD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KTOCD                    '.
    FT-FVAL = BKNA1-KTOCD                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-VBUND(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-VBUND                    '.
    FT-FVAL = BKNA1-VBUND                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KONZS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KONZS                    '.
    FT-FVAL = BKNA1-KONZS                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STCD1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STCD1                    '.
    FT-FVAL = BKNA1-STCD1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STCDT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STCDT                    '.
    FT-FVAL = BKNA1-STCDT                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STKZA(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STKZA                    '.
    FT-FVAL = BKNA1-STKZA                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STCD2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STCD2                    '.
    FT-FVAL = BKNA1-STCD2                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-FITYP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-FITYP                    '.
    FT-FVAL = BKNA1-FITYP                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STKZN(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STKZN                    '.
    FT-FVAL = BKNA1-STKZN                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STCD3(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STCD3                    '.
    FT-FVAL = BKNA1-STCD3                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STKZU(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STKZU                    '.
    FT-FVAL = BKNA1-STKZU                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STCD4(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STCD4                    '.
    FT-FVAL = BKNA1-STCD4                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-FISKN(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-FISKN                    '.
    FT-FVAL = BKNA1-FISKN                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-COUNC(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-COUNC                    '.
    FT-FVAL = BKNA1-COUNC                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-STCEG(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-STCEG                    '.
    FT-FVAL = BKNA1-STCEG                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-CITYC(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-CITYC                    '.
    FT-FVAL = BKNA1-CITYC                   .
    APPEND FT.
  ENDIF.
  IF ZAV_FLAG IS INITIAL.
  IF BKNA1-TXJCD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TXJCD                    '.
    FT-FVAL = BKNA1-TXJCD                   .
    APPEND FT.
  ENDIF.
  ENDIF.
  IF BKNA1-TXLW1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TXLW1                    '.
    FT-FVAL = BKNA1-TXLW1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-XSUBT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-XSUBT                    '.
    FT-FVAL = BKNA1-XSUBT                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-XICMS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-XICMS                    '.
    FT-FVAL = BKNA1-XICMS                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-TXLW2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-TXLW2                    '.
    FT-FVAL = BKNA1-TXLW2                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-XXIPI(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-XXIPI                    '.
    FT-FVAL = BKNA1-XXIPI                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-CFOPC(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-CFOPC                    '.
    FT-FVAL = BKNA1-CFOPC                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-J_1KFTBUS(1)                NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-J_1KFTBUS                '.
    FT-FVAL = BKNA1-J_1KFTBUS               .
    APPEND FT.
  ENDIF.
  IF BKNA1-J_1KFREPRE(1)               NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-J_1KFREPRE               '.
    FT-FVAL = BKNA1-J_1KFREPRE              .
    APPEND FT.
  ENDIF.
  IF BKNA1-J_1KFTIND(1)                NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-J_1KFTIND                '.
    FT-FVAL = BKNA1-J_1KFTIND               .
    APPEND FT.
  ENDIF.
  IF BKNA1-BBBNR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BBBNR                    '.
    FT-FVAL = BKNA1-BBBNR                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-BBSNR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BBSNR                    '.
    FT-FVAL = BKNA1-BBSNR                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-BUBKZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BUBKZ                    '.
    FT-FVAL = BKNA1-BUBKZ                   .
    APPEND FT.
  ENDIF.
  IF BRSCH1 NE NODATA.
  IF BKNA1-BRSCH(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BRSCH                    '.
    FT-FVAL = BKNA1-BRSCH                   .
    APPEND FT.
  ENDIF.
  ENDIF.
  IF BKNA1-BAHNS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BAHNS                    '.
    FT-FVAL = BKNA1-BAHNS                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-BAHNE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BAHNE                    '.
    FT-FVAL = BKNA1-BAHNE                   .
    APPEND FT.
  ENDIF.
  IF ZAV_FLAG IS INITIAL.
  IF BKNA1-LZONE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-LZONE                    '.
    FT-FVAL = BKNA1-LZONE                   .
    APPEND FT.
  ENDIF.
  ENDIF.
  IF BKNA1-LOCCO(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-LOCCO                    '.
    FT-FVAL = BKNA1-LOCCO                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0125_FUELLEN
*----------------------------------------------------------
FORM D0125_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0125'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-NIELS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-NIELS                    '.
    FT-FVAL = BKNA1-NIELS                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-RPMKR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-RPMKR                    '.
    FT-FVAL = BKNA1-RPMKR                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KUKLA(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KUKLA                    '.
    FT-FVAL = BKNA1-KUKLA                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-HZUOR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-HZUOR                    '.
    FT-FVAL = BKNA1-HZUOR                   .
    APPEND FT.
  ENDIF.
  IF BRSCH2 NE NODATA.
  IF BKNA1-BRSCH(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BRSCH                    '.
    FT-FVAL = BKNA1-BRSCH                   .
    APPEND FT.
  ENDIF.
  ENDIF.
  IF BKNA1-BRAN1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BRAN1                    '.
    FT-FVAL = BKNA1-BRAN1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-UMSA1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-UMSA1                    '.
    FT-FVAL = BKNA1-UMSA1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-UWAER(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-UWAER                    '.
    FT-FVAL = BKNA1-UWAER                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-UMJAH(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-UMJAH                    '.
    FT-FVAL = BKNA1-UMJAH                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-JMZAH(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-JMZAH                    '.
    FT-FVAL = BKNA1-JMZAH                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-JMJAH(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-JMJAH                    '.
    FT-FVAL = BKNA1-JMJAH                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-PERIV(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-PERIV                    '.
    FT-FVAL = BKNA1-PERIV                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-GFORM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-GFORM                    '.
    FT-FVAL = BKNA1-GFORM                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1250_FUELLEN
*----------------------------------------------------------
FORM D1250_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1250'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-BRAN2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BRAN2                    '.
    FT-FVAL = BKNA1-BRAN2                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-BRAN3(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BRAN3                    '.
    FT-FVAL = BKNA1-BRAN3                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-BRAN4(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BRAN4                    '.
    FT-FVAL = BKNA1-BRAN4                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-BRAN5(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-BRAN5                    '.
    FT-FVAL = BKNA1-BRAN5                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0130_FUELLEN
*----------------------------------------------------------
FORM D0130_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0130'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNBK-BANKS(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BANKS                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBK-BANKS                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-BANKL(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BANKL                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBK-BANKL                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-BANKN(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BANKN                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBK-BANKN                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-KOINH(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-KOINH                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBK-KOINH                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-BKONT(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BKONT                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBK-BKONT                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-BVTYP(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BVTYP                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBK-BVTYP                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-BKREF(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-BKREF                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBK-BKREF                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-XEZER(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBK-XEZER                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBK-XEZER                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0130_FUELLEN_EINZELFELDER
*----------------------------------------------------------
FORM D0130_FUELLEN_EINZELFELDER.
  CHECK FL_CHECK = SPACE.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0130'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-KNRZA(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KNRZA                    '.
    FT-FVAL = BKNA1-KNRZA                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-XZEMP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-XZEMP                    '.
    FT-FVAL = BKNA1-XZEMP                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-DTAMS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-DTAMS                    '.
    FT-FVAL = BKNA1-DTAMS                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-DTAWS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-DTAWS                    '.
    FT-FVAL = BKNA1-DTAWS                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0340_FUELLEN
*----------------------------------------------------------
FORM D0340_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0340'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVA-ABLAD(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-ABLAD                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVA-ABLAD                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DEFAB(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DEFAB                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVA-DEFAB                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-KNFAK(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-KNFAK                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVA-KNFAK                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1340_FUELLEN
*----------------------------------------------------------
FORM D1340_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1340'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVA-WANID(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-WANID                    '.
    FT-FVAL = XBKNVA-WANID                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-MOAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-MOAB1                    '.
    FT-FVAL = XBKNVA-MOAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-MOBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-MOBI1                    '.
    FT-FVAL = XBKNVA-MOBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-MOAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-MOAB2                    '.
    FT-FVAL = XBKNVA-MOAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-MOBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-MOBI2                    '.
    FT-FVAL = XBKNVA-MOBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DIAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DIAB1                    '.
    FT-FVAL = XBKNVA-DIAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DIBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DIBI1                    '.
    FT-FVAL = XBKNVA-DIBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DIAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DIAB2                    '.
    FT-FVAL = XBKNVA-DIAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DIBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DIBI2                    '.
    FT-FVAL = XBKNVA-DIBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-MIAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-MIAB1                    '.
    FT-FVAL = XBKNVA-MIAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-MIBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-MIBI1                    '.
    FT-FVAL = XBKNVA-MIBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-MIAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-MIAB2                    '.
    FT-FVAL = XBKNVA-MIAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-MIBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-MIBI2                    '.
    FT-FVAL = XBKNVA-MIBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DOAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DOAB1                    '.
    FT-FVAL = XBKNVA-DOAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DOBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DOBI1                    '.
    FT-FVAL = XBKNVA-DOBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DOAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DOAB2                    '.
    FT-FVAL = XBKNVA-DOAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-DOBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-DOBI2                    '.
    FT-FVAL = XBKNVA-DOBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-FRAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-FRAB1                    '.
    FT-FVAL = XBKNVA-FRAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-FRBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-FRBI1                    '.
    FT-FVAL = XBKNVA-FRBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-FRAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-FRAB2                    '.
    FT-FVAL = XBKNVA-FRAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-FRBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-FRBI2                    '.
    FT-FVAL = XBKNVA-FRBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-SAAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-SAAB1                    '.
    FT-FVAL = XBKNVA-SAAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-SABI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-SABI1                    '.
    FT-FVAL = XBKNVA-SABI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-SAAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-SAAB2                    '.
    FT-FVAL = XBKNVA-SAAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-SABI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-SABI2                    '.
    FT-FVAL = XBKNVA-SABI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-SOAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-SOAB1                    '.
    FT-FVAL = XBKNVA-SOAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-SOBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-SOBI1                    '.
    FT-FVAL = XBKNVA-SOBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-SOAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-SOAB2                    '.
    FT-FVAL = XBKNVA-SOAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVA-SOBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVA-SOBI2                    '.
    FT-FVAL = XBKNVA-SOBI2                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0370_FUELLEN
*----------------------------------------------------------
FORM D0370_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0370'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNEX-LNDEX(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNEX-LNDEX                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNEX-LNDEX                  .
    APPEND FT.
  ENDIF.
  IF XBKNEX-TDODA(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNEX-TDODA                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNEX-TDODA                  .
    APPEND FT.
  ENDIF.
  IF XBKNEX-TDOCO(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNEX-TDOCO                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNEX-TDOCO                  .
    APPEND FT.
  ENDIF.
  IF XBKNEX-SDNDA(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNEX-SDNDA                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNEX-SDNDA                  .
    APPEND FT.
  ENDIF.
  IF XBKNEX-SDNCO(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNEX-SDNCO                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNEX-SDNCO                  .
    APPEND FT.
  ENDIF.
  IF XBKNEX-DHRDA(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNEX-DHRDA                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNEX-DHRDA                  .
    APPEND FT.
  ENDIF.
  IF XBKNEX-DHRCO(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNEX-DHRCO                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNEX-DHRCO                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0370_FUELLEN_EINZELFELDER
*----------------------------------------------------------
FORM D0370_FUELLEN_EINZELFELDER.
  CHECK FL_CHECK = SPACE.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0370'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-CIVVE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-CIVVE                    '.
    FT-FVAL = BKNA1-CIVVE                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-MILVE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-MILVE                    '.
    FT-FVAL = BKNA1-MILVE                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-CCC01(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-CCC01                    '.
    FT-FVAL = BKNA1-CCC01                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-CCC02(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-CCC02                    '.
    FT-FVAL = BKNA1-CCC02                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-CCC03(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-CCC03                    '.
    FT-FVAL = BKNA1-CCC03                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-CCC04(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-CCC04                    '.
    FT-FVAL = BKNA1-CCC04                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0360_FUELLEN
*----------------------------------------------------------
FORM D0360_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0360'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF ZAV_FLAG IS INITIAL.
  IF XBKNVK-ANRED(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-ANRED                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVK-ANRED                  .
    APPEND FT.
  ENDIF.
  ENDIF.
  IF XBKNVK-NAMEV(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-NAMEV                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVK-NAMEV                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-NAME1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-NAME1                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVK-NAME1                  .
    APPEND FT.
  ENDIF.
  IF ZAV_FLAG IS INITIAL.
  IF XBKNVK-TELF1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-TELF1                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVK-TELF1                  .
    APPEND FT.
  ENDIF.
  ENDIF.
  IF XBKNVK-ABTNR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-ABTNR                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVK-ABTNR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAFKT(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PAFKT                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVK-PAFKT                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1360_FUELLEN
*----------------------------------------------------------
FORM D1360_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1360'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVK-SORTL(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-SORTL                    '.
    FT-FVAL = XBKNVK-SORTL                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-NAME1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-NAME1                    '.
    FT-FVAL = XBKNVK-NAME1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-NAMEV(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-NAMEV                    '.
    FT-FVAL = XBKNVK-NAMEV                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-TITEL_AP(1)                NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-TITEL_AP                 '.
    FT-FVAL = XBKNVK-TITEL_AP               .
    APPEND FT.
  ENDIF.
  IF XBKNVK-ANRED(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-ANRED                    '.
    FT-FVAL = XBKNVK-ANRED                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SPNAM(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-SPNAM                    '.
    FT-FVAL = XBKNVK-SPNAM                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAVIP(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PAVIP                    '.
    FT-FVAL = XBKNVK-PAVIP                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-TELF1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-TELF1                    '.
    FT-FVAL = XBKNVK-TELF1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARLA(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARLA                    '.
    FT-FVAL = XBKNVK-PARLA                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARGE(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARGE                    '.
    FT-FVAL = XBKNVK-PARGE                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-FAMST(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-FAMST                    '.
    FT-FVAL = XBKNVK-FAMST                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-GBDAT(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-GBDAT                    '.
    FT-FVAL = XBKNVK-GBDAT                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-ABTNR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-ABTNR                    '.
    FT-FVAL = XBKNVK-ABTNR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-ABTPA(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-ABTPA                    '.
    FT-FVAL = XBKNVK-ABTPA                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAFKT(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PAFKT                    '.
    FT-FVAL = XBKNVK-PAFKT                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARVO(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARVO                    '.
    FT-FVAL = XBKNVK-PARVO                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-UEPAR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'RF02D-KTONR                   '.
    FT-FVAL = XBKNVK-UEPAR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-VRTNR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-VRTNR                    '.
    FT-FVAL = XBKNVK-VRTNR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-BRYTH(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-BRYTH                    '.
    FT-FVAL = XBKNVK-BRYTH                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-NMAIL(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-NMAIL                    '.
    FT-FVAL = XBKNVK-NMAIL                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-AKVER(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-AKVER                    '.
    FT-FVAL = XBKNVK-AKVER                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARAU(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARAU                    '.
    FT-FVAL = XBKNVK-PARAU                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1365_FUELLEN
*----------------------------------------------------------
FORM D1365_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1365'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVK-MOAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-MOAB1                   '.
    FT-FVAL = XBKNVK-MOAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-MOBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-MOBI1                   '.
    FT-FVAL = XBKNVK-MOBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-MOAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-MOAB2                   '.
    FT-FVAL = XBKNVK-MOAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-MOBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-MOBI2                   '.
    FT-FVAL = XBKNVK-MOBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-DIAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-DIAB1                   '.
    FT-FVAL = XBKNVK-DIAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-DIBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-DIBI1                   '.
    FT-FVAL = XBKNVK-DIBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-DIAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-DIAB2                   '.
    FT-FVAL = XBKNVK-DIAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-DIBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-DIBI2                   '.
    FT-FVAL = XBKNVK-DIBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-MIAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-MIAB1                   '.
    FT-FVAL = XBKNVK-MIAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-MIBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-MIBI1                   '.
    FT-FVAL = XBKNVK-MIBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-MIAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-MIAB2                   '.
    FT-FVAL = XBKNVK-MIAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-MIBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-MIBI2                   '.
    FT-FVAL = XBKNVK-MIBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-DOAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-DOAB1                   '.
    FT-FVAL = XBKNVK-DOAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-DOBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-DOBI1                   '.
    FT-FVAL = XBKNVK-DOBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-DOAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-DOAB2                   '.
    FT-FVAL = XBKNVK-DOAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-DOBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-DOBI2                   '.
    FT-FVAL = XBKNVK-DOBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-FRAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-FRAB1                   '.
    FT-FVAL = XBKNVK-FRAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-FRBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-FRBI1                   '.
    FT-FVAL = XBKNVK-FRBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-FRAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-FRAB2                   '.
    FT-FVAL = XBKNVK-FRAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-FRBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-FRBI2                   '.
    FT-FVAL = XBKNVK-FRBI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SAAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-SAAB1                   '.
    FT-FVAL = XBKNVK-SAAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SABI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-SABI1                   '.
    FT-FVAL = XBKNVK-SABI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SAAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-SAAB2                   '.
    FT-FVAL = XBKNVK-SAAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SABI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-SABI2                   '.
    FT-FVAL = XBKNVK-SABI2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SOAB1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-SOAB1                   '.
    FT-FVAL = XBKNVK-SOAB1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SOBI1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-SOBI1                   '.
    FT-FVAL = XBKNVK-SOBI1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SOAB2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-SOAB2                   '.
    FT-FVAL = XBKNVK-SOAB2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-SOBI2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-SOBI2                   '.
    FT-FVAL = XBKNVK-SOBI2                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1366_FUELLEN
*----------------------------------------------------------
FORM D1366_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1366'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVK-PARH1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PARH1                   '.
    FT-FVAL = XBKNVK-PARH1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARH2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PARH2                   '.
    FT-FVAL = XBKNVK-PARH2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARH3(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PARH3                   '.
    FT-FVAL = XBKNVK-PARH3                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARH4(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PARH4                   '.
    FT-FVAL = XBKNVK-PARH4                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARH5(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PARH5                   '.
    FT-FVAL = XBKNVK-PARH5                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAKN1(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PAKN1                   '.
    FT-FVAL = XBKNVK-PAKN1                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAKN2(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PAKN2                   '.
    FT-FVAL = XBKNVK-PAKN2                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAKN3(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PAKN3                   '.
    FT-FVAL = XBKNVK-PAKN3                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAKN4(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PAKN4                   '.
    FT-FVAL = XBKNVK-PAKN4                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAKN5(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = '*KNVK-PAKN5                   '.
    FT-FVAL = XBKNVK-PAKN5                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0210_FUELLEN
*----------------------------------------------------------
FORM D0210_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0210'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNB1-AKONT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-AKONT                    '.
    FT-FVAL = BKNB1-AKONT                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZUAWA(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZUAWA                    '.
    FT-FVAL = BKNB1-ZUAWA                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-KNRZE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-KNRZE                    '.
    FT-FVAL = BKNB1-KNRZE                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-BLNKZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-BLNKZ                    '.
    FT-FVAL = BKNB1-BLNKZ                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-BEGRU(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-BEGRU                    '.
    FT-FVAL = BKNB1-BEGRU                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-FDGRV(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-FDGRV                    '.
    FT-FVAL = BKNB1-FDGRV                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-FRGRP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-FRGRP                    '.
    FT-FVAL = BKNB1-FRGRP                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-WBRSL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-WBRSL                    '.
    FT-FVAL = BKNB1-WBRSL                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-VZSKZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-VZSKZ                    '.
    FT-FVAL = BKNB1-VZSKZ                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZINDT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZINDT                    '.
    FT-FVAL = BKNB1-ZINDT                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZINRT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZINRT                    '.
    FT-FVAL = BKNB1-ZINRT                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-DATLZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-DATLZ                    '.
    FT-FVAL = BKNB1-DATLZ                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ALTKN(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ALTKN                    '.
    FT-FVAL = BKNB1-ALTKN                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-PERNR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-PERNR                    '.
    FT-FVAL = BKNB1-PERNR                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-EKVBD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-EKVBD                    '.
    FT-FVAL = BKNB1-EKVBD                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-GRICD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-GRICD                    '.
    FT-FVAL = BKNB1-GRICD                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-GRIDT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-GRIDT                    '.
    FT-FVAL = BKNB1-GRIDT                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0215_FUELLEN
*----------------------------------------------------------
FORM D0215_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0215'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNB1-ZTERM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZTERM                    '.
    FT-FVAL = BKNB1-ZTERM                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-TOGRU(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-TOGRU                    '.
    FT-FVAL = BKNB1-TOGRU                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-GUZTE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-GUZTE                    '.
    FT-FVAL = BKNB1-GUZTE                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-XZVER(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-XZVER                    '.
    FT-FVAL = BKNB1-XZVER                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-WAKON(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-WAKON                    '.
    FT-FVAL = BKNB1-WAKON                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-URLID(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-URLID                    '.
    FT-FVAL = BKNB1-URLID                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-KULTG(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-KULTG                    '.
    FT-FVAL = BKNB1-KULTG                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-CESSION_KZ(1)               NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-CESSION_KZ               '.
    FT-FVAL = BKNB1-CESSION_KZ              .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZWELS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZWELS                    '.
    FT-FVAL = BKNB1-ZWELS                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZAHLS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZAHLS                    '.
    FT-FVAL = BKNB1-ZAHLS                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-KNRZB(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-KNRZB                    '.
    FT-FVAL = BKNB1-KNRZB                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-HBKID(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-HBKID                    '.
    FT-FVAL = BKNB1-HBKID                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-XPORE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-XPORE                    '.
    FT-FVAL = BKNB1-XPORE                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZGRUP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZGRUP                    '.
    FT-FVAL = BKNB1-ZGRUP                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-XVERR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-XVERR                    '.
    FT-FVAL = BKNB1-XVERR                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-UZAWE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-UZAWE                    '.
    FT-FVAL = BKNB1-UZAWE                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-WEBTR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-WEBTR                    '.
    FT-FVAL = BKNB1-WEBTR                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-REMIT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-REMIT                    '.
    FT-FVAL = BKNB1-REMIT                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-XEDIP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-XEDIP                    '.
    FT-FVAL = BKNB1-XEDIP                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-LOCKB(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-LOCKB                    '.
    FT-FVAL = BKNB1-LOCKB                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-VRSDG(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-VRSDG                    '.
    FT-FVAL = BKNB1-VRSDG                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-SREGL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-SREGL                    '.
    FT-FVAL = BKNB1-SREGL                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0220_FUELLEN
*----------------------------------------------------------
FORM D0220_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0220'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNB5-MAHNA(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB5-MAHNA                    '.
    FT-FVAL = BKNB5-MAHNA                   .
    APPEND FT.
  ENDIF.
  IF BKNB5-MANSP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB5-MANSP                    '.
    FT-FVAL = BKNB5-MANSP                   .
    APPEND FT.
  ENDIF.
  IF BKNB5-KNRMA(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB5-KNRMA                    '.
    FT-FVAL = BKNB5-KNRMA                   .
    APPEND FT.
  ENDIF.
  IF BKNB5-GMVDT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB5-GMVDT                    '.
    FT-FVAL = BKNB5-GMVDT                   .
    APPEND FT.
  ENDIF.
  IF BKNB5-MADAT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB5-MADAT                    '.
    FT-FVAL = BKNB5-MADAT                   .
    APPEND FT.
  ENDIF.
  IF BKNB5-MAHNS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB5-MAHNS                    '.
    FT-FVAL = BKNB5-MAHNS                   .
    APPEND FT.
  ENDIF.
  IF BKNB5-BUSAB(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB5-BUSAB                    '.
    FT-FVAL = BKNB5-BUSAB                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-MGRUP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-MGRUP                    '.
    FT-FVAL = BKNB1-MGRUP                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-BUSAB(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-BUSAB                    '.
    FT-FVAL = BKNB1-BUSAB                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-XDEZV(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-XDEZV                    '.
    FT-FVAL = BKNB1-XDEZV                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-EIKTO(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-EIKTO                    '.
    FT-FVAL = BKNB1-EIKTO                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-XAUSZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-XAUSZ                    '.
    FT-FVAL = BKNB1-XAUSZ                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZSABE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZSABE                    '.
    FT-FVAL = BKNB1-ZSABE                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-PERKZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-PERKZ                    '.
    FT-FVAL = BKNB1-PERKZ                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-TLFNS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-TLFNS                    '.
    FT-FVAL = BKNB1-TLFNS                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-TLFXS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-TLFXS                    '.
    FT-FVAL = BKNB1-TLFXS                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-INTAD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-INTAD                    '.
    FT-FVAL = BKNB1-INTAD                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-KVERM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-KVERM                    '.
    FT-FVAL = BKNB1-KVERM                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZAMIM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZAMIM                    '.
    FT-FVAL = BKNB1-ZAMIM                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZAMIV(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZAMIV                    '.
    FT-FVAL = BKNB1-ZAMIV                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZAMIR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZAMIR                    '.
    FT-FVAL = BKNB1-ZAMIR                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZAMIO(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZAMIO                    '.
    FT-FVAL = BKNB1-ZAMIO                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-ZAMIB(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-ZAMIB                    '.
    FT-FVAL = BKNB1-ZAMIB                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0230_FUELLEN
*----------------------------------------------------------
FORM D0230_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0230'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNB1-VRSNR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-VRSNR                    '.
    FT-FVAL = BKNB1-VRSNR                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-VRBKZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-VRBKZ                    '.
    FT-FVAL = BKNB1-VRBKZ                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-VLIBB(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-VLIBB                    '.
    FT-FVAL = BKNB1-VLIBB                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-VERDT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-VERDT                    '.
    FT-FVAL = BKNB1-VERDT                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-VRSZL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-VRSZL                    '.
    FT-FVAL = BKNB1-VRSZL                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-VRSPR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-VRSPR                    '.
    FT-FVAL = BKNB1-VRSPR                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0610_FUELLEN
*----------------------------------------------------------
FORM D0610_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0610'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNBW-WITHT(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBW-WITHT                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBW-WITHT                  .
    APPEND FT.
  ENDIF.
  IF XBKNBW-WT_WITHCD(1)               NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBW-WT_WITHCD                '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBW-WT_WITHCD              .
    APPEND FT.
  ENDIF.
  IF XBKNBW-WT_AGENT(1)                NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBW-WT_AGENT                 '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBW-WT_AGENT               .
    APPEND FT.
  ENDIF.
  IF XBKNBW-WT_AGTDF(1)                NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBW-WT_AGTDF                 '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBW-WT_AGTDF               .
    APPEND FT.
  ENDIF.
  IF XBKNBW-WT_AGTDT(1)                NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBW-WT_AGTDT                 '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBW-WT_AGTDT               .
    APPEND FT.
  ENDIF.
  IF XBKNBW-WT_WTSTCD(1)               NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNBW-WT_WTSTCD                '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNBW-WT_WTSTCD              .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0310_FUELLEN
*----------------------------------------------------------
FORM D0310_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0310'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNVV-BZIRK(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-BZIRK                    '.
    FT-FVAL = BKNVV-BZIRK                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-AWAHR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-AWAHR                    '.
    FT-FVAL = BKNVV-AWAHR                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-VKBUR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-VKBUR                    '.
    FT-FVAL = BKNVV-VKBUR                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-BEGRU(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-BEGRU                    '.
    FT-FVAL = BKNVV-BEGRU                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-VKGRP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-VKGRP                    '.
    FT-FVAL = BKNVV-VKGRP                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-VSORT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-VSORT                    '.
    FT-FVAL = BKNVV-VSORT                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KDGRP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KDGRP                    '.
    FT-FVAL = BKNVV-KDGRP                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-EIKTO(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-EIKTO                    '.
    FT-FVAL = BKNVV-EIKTO                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KLABC(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KLABC                    '.
    FT-FVAL = BKNVV-KLABC                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-MEGRU(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-MEGRU                    '.
    FT-FVAL = BKNVV-MEGRU                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-WAERS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-WAERS                    '.
    FT-FVAL = BKNVV-WAERS                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KURST(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KURST                    '.
    FT-FVAL = BKNVV-KURST                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-RDOFF(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-RDOFF                    '.
    FT-FVAL = BKNVV-RDOFF                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-PVKSM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-PVKSM                    '.
    FT-FVAL = BKNVV-PVKSM                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KONDA(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KONDA                    '.
    FT-FVAL = BKNVV-KONDA                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KALKS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KALKS                    '.
    FT-FVAL = BKNVV-KALKS                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-PLTYP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-PLTYP                    '.
    FT-FVAL = BKNVV-PLTYP                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-VERSG(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-VERSG                    '.
    FT-FVAL = BKNVV-VERSG                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-AGREL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-AGREL                    '.
    FT-FVAL = BKNVV-AGREL                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0315_FUELLEN
*----------------------------------------------------------
FORM D0315_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0315'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNVV-LPRIO(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-LPRIO                    '.
    FT-FVAL = BKNVV-LPRIO                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KZAZU(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KZAZU                    '.
    FT-FVAL = BKNVV-KZAZU                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-VSBED(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-VSBED                    '.
    FT-FVAL = BKNVV-VSBED                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-PODKZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-PODKZ                    '.
    FT-FVAL = BKNVV-PODKZ                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-VWERK(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-VWERK                    '.
    FT-FVAL = BKNVV-VWERK                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-AUTLF(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-AUTLF                    '.
    FT-FVAL = BKNVV-AUTLF                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KZTLF(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KZTLF                    '.
    FT-FVAL = BKNVV-KZTLF                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-ANTLF(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-ANTLF                    '.
    FT-FVAL = BKNVV-ANTLF                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-UEBTK(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-UEBTK                    '.
    FT-FVAL = BKNVV-UEBTK                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-UNTTO(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-UNTTO                    '.
    FT-FVAL = BKNVV-UNTTO                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-UEBTO(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-UEBTO                    '.
    FT-FVAL = BKNVV-UEBTO                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0320_FUELLEN
*----------------------------------------------------------
FORM D0320_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0320'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNVV-MRNKZ(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-MRNKZ                    '.
    FT-FVAL = BKNVV-MRNKZ                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-BOKRE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-BOKRE                    '.
    FT-FVAL = BKNVV-BOKRE                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-PRFRE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-PRFRE                    '.
    FT-FVAL = BKNVV-PRFRE                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-PERFK(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-PERFK                    '.
    FT-FVAL = BKNVV-PERFK                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-PERRL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-PERRL                    '.
    FT-FVAL = BKNVV-PERRL                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-INCO1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-INCO1                    '.
    FT-FVAL = BKNVV-INCO1                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-INCO2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-INCO2                    '.
    FT-FVAL = BKNVV-INCO2                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-ZTERM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-ZTERM                    '.
    FT-FVAL = BKNVV-ZTERM                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KABSS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KABSS                    '.
    FT-FVAL = BKNVV-KABSS                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KKBER(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KKBER                    '.
    FT-FVAL = BKNVV-KKBER                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KTGRD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KTGRD                    '.
    FT-FVAL = BKNVV-KTGRD                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1350_FUELLEN
*----------------------------------------------------------
FORM D1350_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1350'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVI-TAXKD(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVI-TAXKD                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVI-TAXKD                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1355_FUELLEN
*----------------------------------------------------------
FORM D1355_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1355'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVL-ALAND(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-ALAND                    '.
    FT-FVAL = XBKNVL-ALAND                  .
    APPEND FT.
  ENDIF.
  IF XBKNVL-TATYP(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-TATYP                    '.
    FT-FVAL = XBKNVL-TATYP                  .
    APPEND FT.
  ENDIF.
  IF XBKNVL-LICNR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-LICNR                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVL-LICNR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVL-BELIC(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-BELIC                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVL-BELIC                  .
    APPEND FT.
  ENDIF.
  IF XBKNVL-DATAB(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-DATAB                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVL-DATAB                  .
    APPEND FT.
  ENDIF.
  IF XBKNVL-DATBI(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVL-DATBI                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVL-DATBI                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0326_FUELLEN
*----------------------------------------------------------
FORM D0326_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0326'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVD-DOCTP(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVD-DOCTP                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVD-DOCTP                  .
    APPEND FT.
  ENDIF.
  IF XBKNVD-SPRAS(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVD-SPRAS                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVD-SPRAS                  .
    APPEND FT.
  ENDIF.
  IF XBKNVD-NACHA(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVD-NACHA                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVD-NACHA                  .
    APPEND FT.
  ENDIF.
  IF XBKNVD-DOVER(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVD-DOVER                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVD-DOVER                  .
    APPEND FT.
  ENDIF.
  IF XBKNVD-DOANZ(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVD-DOANZ                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVD-DOANZ                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0324_FUELLEN
*----------------------------------------------------------
FORM D0324_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0324'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVP-PARVW(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVP-PARVW                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVP-PARVW                  .
    APPEND FT.
  ENDIF.
  IF XBKNVP-KTONR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'RF02D-KTONR                   '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVP-KTONR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVP-KNREF(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVP-KNREF                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVP-KNREF                  .
    APPEND FT.
  ENDIF.
  IF XBKNVP-DEFPA(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVP-DEFPA                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNVP-DEFPA                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0510_FUELLEN
*----------------------------------------------------------
FORM D0510_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0510'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-SPERR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-SPERR                    '.
    FT-FVAL = BKNA1-SPERR                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-SPERR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-SPERR                    '.
    FT-FVAL = BKNB1-SPERR                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-AUFSD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-AUFSD                    '.
    FT-FVAL = BKNA1-AUFSD                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-AUFSD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-AUFSD                    '.
    FT-FVAL = BKNVV-AUFSD                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-LIFSD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-LIFSD                    '.
    FT-FVAL = BKNA1-LIFSD                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-LIFSD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-LIFSD                    '.
    FT-FVAL = BKNVV-LIFSD                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-FAKSD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-FAKSD                    '.
    FT-FVAL = BKNA1-FAKSD                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-FAKSD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-FAKSD                    '.
    FT-FVAL = BKNVV-FAKSD                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-CASSD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-CASSD                    '.
    FT-FVAL = BKNA1-CASSD                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-CASSD(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-CASSD                    '.
    FT-FVAL = BKNVV-CASSD                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0520_FUELLEN
*----------------------------------------------------------
FORM D0520_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0520'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-LOEVM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-LOEVM                    '.
    FT-FVAL = BKNA1-LOEVM                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-LOEVM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-LOEVM                    '.
    FT-FVAL = BKNB1-LOEVM                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-LOEVM(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-LOEVM                    '.
    FT-FVAL = BKNVV-LOEVM                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-NODEL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-NODEL                    '.
    FT-FVAL = BKNA1-NODEL                   .
    APPEND FT.
  ENDIF.
  IF BKNB1-NODEL(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNB1-NODEL                    '.
    FT-FVAL = BKNB1-NODEL                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form DL120_FUELLEN
*----------------------------------------------------------
FORM DL120_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02C'.
  FT-DYNPRO   = '0120'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNKA-KLIMG(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKA-KLIMG                    '.
    FT-FVAL = BKNKA-KLIMG                   .
    APPEND FT.
  ENDIF.
  IF BKNKA-KLIME(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKA-KLIME                    '.
    FT-FVAL = BKNKA-KLIME                   .
    APPEND FT.
  ENDIF.
  IF BKNKA-WAERS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKA-WAERS                    '.
    FT-FVAL = BKNKA-WAERS                   .
    APPEND FT.
  ENDIF.
  IF BKNKA-DLAUS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKA-DLAUS                    '.
    FT-FVAL = BKNKA-DLAUS                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form DL210_FUELLEN
*----------------------------------------------------------
FORM DL210_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02C'.
  FT-DYNPRO   = '0210'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNKK-KLIMK(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-KLIMK                    '.
    FT-FVAL = BKNKK-KLIMK                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-KNKLI(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-KNKLI                    '.
    FT-FVAL = BKNKK-KNKLI                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-CTLPC(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-CTLPC                    '.
    FT-FVAL = BKNKK-CTLPC                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-CRBLB(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-CRBLB                    '.
    FT-FVAL = BKNKK-CRBLB                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-SBGRP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-SBGRP                    '.
    FT-FVAL = BKNKK-SBGRP                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-GRUPP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-GRUPP                    '.
    FT-FVAL = BKNKK-GRUPP                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-KDGRP(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-KDGRP                    '.
    FT-FVAL = BKNKK-KDGRP                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-DTREV(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-DTREV                    '.
    FT-FVAL = BKNKK-DTREV                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-SBDAT(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-SBDAT                    '.
    FT-FVAL = BKNKK-SBDAT                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-NXTRV(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-NXTRV                    '.
    FT-FVAL = BKNKK-NXTRV                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-KRAUS(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-KRAUS                    '.
    FT-FVAL = BKNKK-KRAUS                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-DBPAY(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-DBPAY                    '.
    FT-FVAL = BKNKK-DBPAY                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-REVDB(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-REVDB                    '.
    FT-FVAL = BKNKK-REVDB                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-DBRTG(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-DBRTG                    '.
    FT-FVAL = BKNKK-DBRTG                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-DBMON(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-DBMON                    '.
    FT-FVAL = BKNKK-DBMON                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-DBEKR(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-DBEKR                    '.
    FT-FVAL = BKNKK-DBEKR                   .
    APPEND FT.
  ENDIF.
  IF BKNKK-DBWAE(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNKK-DBWAE                    '.
    FT-FVAL = BKNKK-DBWAE                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form DB100_FUELLEN
*----------------------------------------------------------
FORM DB100_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPLBANK'.
  FT-DYNPRO   = '0100'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNBK-BANKA(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-BANKA                    '.
    FT-FVAL = XBKNBK-BANKA                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-PROVZ(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-PROVZ                    '.
    FT-FVAL = XBKNBK-PROVZ                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-STRAS(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-STRAS                    '.
    FT-FVAL = XBKNBK-STRAS                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-ORT01(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-ORT01                    '.
    FT-FVAL = XBKNBK-ORT01                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-BRNCH(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-BRNCH                    '.
    FT-FVAL = XBKNBK-BRNCH                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-SWIFT(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-SWIFT                    '.
    FT-FVAL = XBKNBK-SWIFT                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-BGRUP(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-BGRUP                    '.
    FT-FVAL = XBKNBK-BGRUP                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-XPGRO(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-XPGRO                    '.
    FT-FVAL = XBKNBK-XPGRO                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-BNKLZ(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-BNKLZ                    '.
    FT-FVAL = XBKNBK-BNKLZ                  .
    APPEND FT.
  ENDIF.
  IF XBKNBK-PSKTO(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'BNKA-PSKTO                    '.
    FT-FVAL = XBKNBK-PSKTO                  .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form DZ100_FUELLEN
*----------------------------------------------------------
FORM DZ100_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPLV02Z'.
  FT-DYNPRO   = '0100'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNA1-KATR1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR1                    '.
    FT-FVAL = BKNA1-KATR1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR2                    '.
    FT-FVAL = BKNA1-KATR2                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR3(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR3                    '.
    FT-FVAL = BKNA1-KATR3                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR4(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR4                    '.
    FT-FVAL = BKNA1-KATR4                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR5(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR5                    '.
    FT-FVAL = BKNA1-KATR5                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR6(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR6                    '.
    FT-FVAL = BKNA1-KATR6                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR7(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR7                    '.
    FT-FVAL = BKNA1-KATR7                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR8(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR8                    '.
    FT-FVAL = BKNA1-KATR8                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR9(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR9                    '.
    FT-FVAL = BKNA1-KATR9                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KATR10(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KATR10                   '.
    FT-FVAL = BKNA1-KATR10                  .
    APPEND FT.
  ENDIF.
  IF BKNA1-KDKG1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KDKG1                    '.
    FT-FVAL = BKNA1-KDKG1                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KDKG2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KDKG2                    '.
    FT-FVAL = BKNA1-KDKG2                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KDKG3(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KDKG3                    '.
    FT-FVAL = BKNA1-KDKG3                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KDKG4(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KDKG4                    '.
    FT-FVAL = BKNA1-KDKG4                   .
    APPEND FT.
  ENDIF.
  IF BKNA1-KDKG5(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNA1-KDKG5                    '.
    FT-FVAL = BKNA1-KDKG5                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form DZ200_FUELLEN
*----------------------------------------------------------
FORM DZ200_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPLV02Z'.
  FT-DYNPRO   = '0200'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF BKNVV-KVGR1(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KVGR1                    '.
    FT-FVAL = BKNVV-KVGR1                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KVGR2(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KVGR2                    '.
    FT-FVAL = BKNVV-KVGR2                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KVGR3(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KVGR3                    '.
    FT-FVAL = BKNVV-KVGR3                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KVGR4(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KVGR4                    '.
    FT-FVAL = BKNVV-KVGR4                   .
    APPEND FT.
  ENDIF.
  IF BKNVV-KVGR5(1)                    NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVV-KVGR5                    '.
    FT-FVAL = BKNVV-KVGR5                   .
    APPEND FT.
  ENDIF.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D0111_FUELLEN
*----------------------------------------------------------
FORM D0111_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '0111'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  TRAEGER_DYNP_ZAV = REP_NAME_D.
  PERFORM D0111_FUELLEN_ZAV USING 'KNA1'.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1361_FUELLEN
*----------------------------------------------------------
FORM D1361_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1361'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNVK-PAVIP(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PAVIP                    '.
    FT-FVAL = XBKNVK-PAVIP                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARGE(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARGE                    '.
    FT-FVAL = XBKNVK-PARGE                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-ABTNR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-ABTNR                    '.
    FT-FVAL = XBKNVK-ABTNR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-GBDAT(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-GBDAT                    '.
    FT-FVAL = XBKNVK-GBDAT                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PAFKT(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PAFKT                    '.
    FT-FVAL = XBKNVK-PAFKT                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-FAMST(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-FAMST                    '.
    FT-FVAL = XBKNVK-FAMST                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARVO(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARVO                    '.
    FT-FVAL = XBKNVK-PARVO                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-UEPAR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'RF02D-KTONR                   '.
    FT-FVAL = XBKNVK-UEPAR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-VRTNR(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-VRTNR                    '.
    FT-FVAL = XBKNVK-VRTNR                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-BRYTH(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-BRYTH                    '.
    FT-FVAL = XBKNVK-BRYTH                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-NMAIL(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-NMAIL                    '.
    FT-FVAL = XBKNVK-NMAIL                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-AKVER(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-AKVER                    '.
    FT-FVAL = XBKNVK-AKVER                  .
    APPEND FT.
  ENDIF.
  IF XBKNVK-PARAU(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNVK-PARAU                    '.
    FT-FVAL = XBKNVK-PARAU                  .
    APPEND FT.
  ENDIF.
  TRAEGER_DYNP_ZAV = REP_NAME_D.
  PERFORM D1361_FUELLEN_ZAV.
ENDFORM.

*eject
*----------------------------------------------------------
*        Form D1130_FUELLEN
*----------------------------------------------------------
FORM D1130_FUELLEN.
  CLEAR FT.
  FT-PROGRAM  = 'SAPMF02D'.
  FT-DYNPRO   = '1130'.
  FT-DYNBEGIN = 'X'.
  APPEND FT.
  IF XBKNZA-EMPFD(1)                   NE NODATA.
    CLEAR FT.
    FT-FNAM = 'KNZA-EMPFD                    '.
    FT-FNAM+30(4) =  '(01)'.
    CONDENSE FT-FNAM NO-GAPS.
    FT-FVAL = XBKNZA-EMPFD                  .
    APPEND FT.
  ENDIF.
ENDFORM.
