FUNCTION BC430_COMP_AND_FILL.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(T_TAB) LIKE  DD03L-TABNAME
*"     VALUE(M_TAB) LIKE  DD03L-TABNAME
*"     VALUE(FILL) TYPE  CHAR1 DEFAULT 'Y'
*"  TABLES
*"      ERRORS STRUCTURE  BC430_ERROR
*"  EXCEPTIONS
*"      T_TAB_NOT_EXIST
*"      T_TAB_NOT_ACTIVE
*"      M_TAB_NOT_ACTIVE
*"      SYSTEM_INCONSISTENT
*"----------------------------------------------------------------------

* Typ für den Vergleich der Tabellenstrukturen
  TYPES: BEGIN OF TABSTRUCT,
           FIELDNAME LIKE DD03L-FIELDNAME,
           KEYFLAG LIKE DD03L-KEYFLAG,
           DATATYPE LIKE DD03L-DATATYPE,
           LENG LIKE DD03L-LENG,
           DECIMALS LIKE DD03L-DECIMALS,
           OFFSET LIKE DFIES-OFFSET,
           POSITION LIKE DFIES-POSITION,
           MARKER(1) TYPE C,
         END OF TABSTRUCT.

* Typ für die Feldzuordnung
  TYPES: BEGIN OF ASSIGN,
           FELD1 LIKE DFIES-FIELDNAME,
           POS1 LIKE DFIES-POSITION,
           OFFSET1 LIKE DFIES-OFFSET,
           LENG1 LIKE DFIES-LENG,
           FELD2 LIKE DFIES-FIELDNAME,
           POS2 LIKE DFIES-POSITION,
           OFFSET2 LIKE DFIES-OFFSET,
           LENG2 LIKE DFIES-LENG,
         END OF ASSIGN.

* Datenbereiche für die Tabellenstrukturen von T_TAB und M_TAB
  DATA: T_TABI TYPE TABSTRUCT OCCURS 20 WITH HEADER LINE,
        M_TABI TYPE TABSTRUCT OCCURS 20 WITH HEADER LINE.

* Datenbereiche für die Feldzuordnung
  DATA: DFIES_A LIKE DFIES OCCURS 10 WITH HEADER LINE,
        ASSIGN_FIELD TYPE ASSIGN OCCURS 10 WITH HEADER LINE.

* Typ für das Füllen der Zieltabelle
  TYPES: BEGIN OF RECORDS,
           RECORD(200),
         END OF RECORDS.

* Datenbereiche für den Datentransfer
  DATA: REC_TAB1 TYPE RECORDS OCCURS 50 WITH HEADER LINE,
        REC_TAB2 TYPE RECORDS OCCURS 50 WITH HEADER LINE.

* Datenbereiche für Zwischenergebnisse
  DATA: FILL_POSSIBLE(1),
        STATE LIKE DCOBJDEF-STATE.

* Datenbereiche für Anz. Schlüsselfelder beider Tabellen
  DATA: ANZ_KEY_T_TABI TYPE I,
        ANZ_KEY_M_TABI TYPE I.

**********************************************************************
* Schritt 1: Lese die Struktur der Teilnehmertabelle T_TAB           *
**********************************************************************

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
       EXPORTING
            TABNAME        = T_TAB
*         FIELDNAME      = ' '
            LANGU          = SY-LANGU
*       IMPORTING
*            X030L_WA       = X030L
       TABLES
            DFIES_TAB      = DFIES_A
       EXCEPTIONS
            NOT_FOUND      = 1
            INTERNAL_ERROR = 2
            OTHERS         = 3.

* Falls Fehler auftritt, Ursache (nicht aktiv, nicht vorhanden) finden
  IF SY-SUBRC <> 0.
    CALL FUNCTION 'DDIF_STATE_GET'
         EXPORTING
              TYPE          = 'TABL'
              NAME          = T_TAB
*           ID            =
*           STATE         = 'M'
         IMPORTING
             GOTSTATE      = STATE
         EXCEPTIONS
            ILLEGAL_INPUT = 1
            OTHERS        = 2.
    .
    IF SY-SUBRC <> 0.
      RAISE SYSTEM_INCONSISTENT.
    ENDIF.

    IF STATE = ' '.
      RAISE T_TAB_NOT_EXIST.
    ELSE.
      RAISE T_TAB_NOT_ACTIVE.
    ENDIF.

  ENDIF.

* Feldinfo in interne Tabelle T_TABI übernehmen
  LOOP AT DFIES_A.
    MOVE-CORRESPONDING DFIES_A TO T_TABI.
    APPEND T_TABI.
  ENDLOOP.

  REFRESH DFIES_A.

**********************************************************************
* Schritt 2: Lese die Struktur der Vorlagentabelle M_TAB             *
**********************************************************************

  CALL FUNCTION 'DDIF_FIELDINFO_GET'
       EXPORTING
            TABNAME        = M_TAB
*         FIELDNAME      = ' '
            LANGU          = SY-LANGU
*       IMPORTING
*            X030L_WA       = X030L
       TABLES
            DFIES_TAB      = DFIES_A
       EXCEPTIONS
            NOT_FOUND      = 1
            INTERNAL_ERROR = 2
            OTHERS         = 3.

  IF SY-SUBRC <> 0.
    RAISE M_TAB_NOT_ACTIVE.     "Fataler Fehler, Vorlage nicht da!
  ENDIF.

* Übernehme die Feldinfo in interne Tabelle M_TABI
  LOOP AT DFIES_A.
    MOVE-CORRESPONDING DFIES_A TO M_TABI.
    APPEND M_TABI.
  ENDLOOP.

  REFRESH DFIES_A.

**********************************************************************
* Schritt 3: Erzeuge die Feldzuordnung.                              *
* Falls T_TABI Felder enthält, die in M_TABI nicht enthalten sind,   *
* wird dies ignoriert, d.h. diese Situation liefert keinen Fehler.   *
**********************************************************************

  LOOP AT M_TABI.
    LOOP AT T_TABI.
      IF T_TABI-LENG = M_TABI-LENG AND
         T_TABI-DATATYPE = M_TABI-DATATYPE AND
         T_TABI-DECIMALS = M_TABI-DECIMALS AND
         T_TABI-KEYFLAG = M_TABI-KEYFLAG AND
         T_TABI-MARKER NE 'X'.

        M_TABI-MARKER = 'X'.   "Corresponding field found in T_TABI
        MODIFY M_TABI.

        ASSIGN_FIELD-FELD1 = T_TABI-FIELDNAME.  "Field assignment
        ASSIGN_FIELD-POS1 = T_TABI-POSITION.
        ASSIGN_FIELD-OFFSET1 = T_TABI-OFFSET.
        ASSIGN_FIELD-LENG1 = T_TABI-LENG.
        ASSIGN_FIELD-FELD2 = M_TABI-FIELDNAME.
        ASSIGN_FIELD-POS2 = M_TABI-POSITION.
        ASSIGN_FIELD-OFFSET2 = M_TABI-OFFSET.
        ASSIGN_FIELD-LENG2 = M_TABI-LENG.
        APPEND ASSIGN_FIELD.

        T_TABI-MARKER = 'X'.   "Field in T_TABI is already assigned
        MODIFY T_TABI.

        EXIT.       "End the inner loop, continue with loop over M_TABI
      ENDIF.
    ENDLOOP.
  ENDLOOP.

**********************************************************************
* Schritt 4: Ermittle, ob zu jedem Feld der vordefinierten Tabelle   *
* ein typ- und längengleiches Feld in der Tabelle der Teilnehmer     *
* existiert. Fehler werden analysiert und in ERRORS geschrieben.     *
**********************************************************************

* Ermittle Abweichung in der Anzahl der Schlüsselfelder
  ANZ_KEY_M_TABI = 0.
  ANZ_KEY_T_TABI = 0.

  LOOP AT M_TABI.
    IF M_TABI-KEYFLAG = 'X'.
      ADD 1 TO ANZ_KEY_M_TABI.
    ENDIF.
  ENDLOOP.

  LOOP AT T_TABI.
    IF T_TABI-KEYFLAG = 'X'.
      ADD 1 TO ANZ_KEY_T_TABI.
    ENDIF.
  ENDLOOP.

  IF ANZ_KEY_M_TABI > ANZ_KEY_T_TABI.
    ERRORS-TABNAME = M_TAB.
    ERRORS-ERROR = 'KEY_TOO_SMALL'.
    APPEND ERRORS.
  ENDIF.
  IF ANZ_KEY_T_TABI > ANZ_KEY_M_TABI.
    ERRORS-TABNAME = M_TAB.
    ERRORS-ERROR = 'KEY_TOO_BIG'.
    APPEND ERRORS.
  ENDIF.

* Ermittle die Fehler in der Feldzuordnung
  FILL_POSSIBLE = 'Y'.

  LOOP AT M_TABI.
    IF M_TABI-MARKER NE 'X'.
      FILL_POSSIBLE = 'N'.
      ERRORS-TABNAME = M_TAB.
      ERRORS-FIELDNAME = M_TABI-FIELDNAME.
      IF M_TABI-KEYFLAG NE 'X'.
        ERRORS-ERROR = 'FIELD'.
      ELSE.
        ERRORS-ERROR = 'KEY'.
      ENDIF.
      APPEND ERRORS.
    ENDIF.
  ENDLOOP.

***********************************************************************
* Schritt 5: Kopiere die Inhalte der vordefinierten Tabelle in die    *
* Tabelle der Teilnehmer, falls diese strukturell kompatibel ist und  *
* falls FILL = 'Y' ist.                                               *
***********************************************************************

  IF FILL = 'Y'.
* Prüfe, ob die Tabellen strukturell kompatibel sind
    IF FILL_POSSIBLE = 'Y'.

* Lese die Daten aus TAB2
      SELECT * FROM (M_TAB) INTO REC_TAB2.
        APPEND REC_TAB2.
      ENDSELECT.

* Fülle die Daten in die interne Tabelle
      LOOP AT REC_TAB2.
        LOOP AT ASSIGN_FIELD.
          REC_TAB1+ASSIGN_FIELD-OFFSET1(ASSIGN_FIELD-LENG1) =
          REC_TAB2+ASSIGN_FIELD-OFFSET2(ASSIGN_FIELD-LENG2).
        ENDLOOP.
        APPEND REC_TAB1.
      ENDLOOP.

* Schreibe in die DB-Tabelle der Teilnehmer
      INSERT (T_TAB) FROM TABLE REC_TAB1 ACCEPTING DUPLICATE KEYS.

    ENDIF.
  ENDIF.

ENDFUNCTION.
