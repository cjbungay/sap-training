FUNCTION BC430_INDX_COMP.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(T_TAB) LIKE  DD03L-TABNAME
*"     VALUE(M_TAB) LIKE  DD03L-TABNAME
*"     VALUE(T_IND) LIKE  DD12V-INDEXNAME
*"     VALUE(M_IND) LIKE  DD12V-INDEXNAME
*"  TABLES
*"      ERRORS STRUCTURE  BC430_ERROR
*"  EXCEPTIONS
*"      T_INDX_NOT_ACTIVE
*"      M_INDX_NOT_ACTIVE
*"      SYSTEM_INCONSISTENT
*"      T_INDX_NOT_EXIST
*"----------------------------------------------------------------------

* Datenbereiche für den Aufruf der DD-Schnittstellen
DATA: DD12V_T LIKE DD12V,
      DD12V_M LIKE DD12V,
      DD17V_T LIKE DD17V OCCURS 10 WITH HEADER LINE,
      DD17V_M LIKE DD17V OCCURS 10 WITH HEADER LINE,
      GOTSTATE LIKE DCOBJIF-GOTSTATE.

* Typ zum Vergleich der Feldstruktur der beiden Indizes
TYPES: BEGIN OF FIELD_STR,
         FIELDNAME LIKE DD17V-FIELDNAME,
         POSITION LIKE DD17V-POSITION,
         DATATYPE LIKE DD03L-DATATYPE,
         LENG LIKE DD03L-LENG,
         USED TYPE C,
       END OF FIELD_STR.

* Datenbereiche für den Vergleich beider Indizes
DATA: FIELD_STR_T TYPE FIELD_STR OCCURS 10 WITH HEADER LINE,
      FIELD_STR_M TYPE FIELD_STR OCCURS 10 WITH HEADER LINE,
      DFIES_T TYPE DFIES,
      DFIES_M TYPE DFIES.

* Typ für die Liste der DB-Systeme auf denen der Index angelegt wird
TYPES: BEGIN OF LIST_DB,
         DBNAME LIKE DD12V-DBSYSSEL1,
         CREATE TYPE C,
       END OF LIST_DB.

* Datenbereiche für Liste der DB-Systeme
DATA: LIST_DB_T TYPE LIST_DB OCCURS 10 WITH HEADER LINE,
      LIST_DB_M TYPE LIST_DB OCCURS 10 WITH HEADER LINE.

* Datenbereiche für Zwischenergebnisse
DATA: LONG_NAME_T LIKE DFIES-LFIELDNAME,
      LONG_NAME_M LIKE DFIES-LFIELDNAME,
      ANZ_FIELDS_T TYPE I,
      ANZ_FIELDS_M TYPE I,
      STRUCTURE_IDENTICAL,
      ORDER_IDENTICAL,
      DB_SYSTEMS,
      COUNTER TYPE I.

* Makro, zum Schreiben der Liste der DB-Systeme
DEFINE FILL_LIST_DB.
  &1-DBNAME = '&2'.
  IF &3 = 'I'.
    &1-CREATE = 'N'.
  ENDIF.
  IF &3 = 'E'.
    &1-CREATE = 'Y'.
  ENDIF.
  APPEND &1.
END-OF-DEFINITION.

***********************************************************************
* Lesen des Index der Teilnehmer                                      *
***********************************************************************

CALL FUNCTION 'DDIF_INDX_GET'
     EXPORTING
          NAME          = T_TAB
          ID            = T_IND
          STATE         = 'M'
          LANGU         = SY-LANGU
     IMPORTING
          GOTSTATE      = GOTSTATE
          DD12V_WA      = DD12V_T
     TABLES
          DD17V_TAB     = DD17V_T
     EXCEPTIONS
          ILLEGAL_INPUT = 1
          OTHERS        = 2.

IF SY-SUBRC <> 0.
  RAISE SYSTEM_INCONSISTENT.
ENDIF.

IF GOTSTATE = ' '.
  RAISE T_INDX_NOT_EXIST.
ENDIF.
IF GOTSTATE NE 'A'.
  RAISE T_INDX_NOT_ACTIVE.
ENDIF.

***********************************************************************
* Lesen des vordefinierten Index                                      *
***********************************************************************

CALL FUNCTION 'DDIF_INDX_GET'
     EXPORTING
          NAME          = M_TAB
          ID            = M_IND
          STATE         = 'A'
          LANGU         = SY-LANGU
     IMPORTING
          GOTSTATE      = GOTSTATE
          DD12V_WA      = DD12V_M
     TABLES
          DD17V_TAB     = DD17V_M
     EXCEPTIONS
          ILLEGAL_INPUT = 1
          OTHERS        = 2.

IF SY-SUBRC <> 0.
  RAISE SYSTEM_INCONSISTENT.
ENDIF.

IF GOTSTATE NE 'A'.
  RAISE M_INDX_NOT_ACTIVE.
ENDIF.

***********************************************************************
* Vergleich von Unique-Flag, DB-Status, Liste DB-Systeme              *
***********************************************************************

* Prüfe, ob Unique-Flag bei beiden Indizes gleich ist
IF DD12V_T-UNIQUEFLAG NE DD12V_M-UNIQUEFLAG.
  ERRORS-TABNAME = T_TAB.
  ERRORS-FIELDNAME = T_IND.
  ERRORS-ERROR = 'UNIQUE_FLAG'.
  ERRORS-HINT = DD12V_M-UNIQUEFLAG.
  APPEND ERRORS.
ENDIF.

* Prüfe, ob der DB-Status (anlegen auf DB, nicht anlegen auf DB,
* nur auf best. DB anlegen) bei beiden Indizes gleich ist.
IF DD12V_M-UNIQUEFLAG EQ ' '.
  IF DD12V_T-DBSTATE NE DD12V_M-DBSTATE.
    ERRORS-TABNAME = T_TAB.
    ERRORS-FIELDNAME = T_IND.
    ERRORS-ERROR = 'DB_STATE'.
    ERRORS-HINT = DD12V_M-DBSTATE.
    APPEND ERRORS.
  ENDIF.

* Falls beide Indizes nur auf ausgewählten DB angelegt werden sollen,
* prüfe ob die Liste der DB identisch ist
  IF DD12V_M-DBSTATE EQ 'D' AND DD12V_T-DBSTATE = 'D'.

* Fülle Liste der DB-Plattformen: Teilnehmerindex
    FILL_LIST_DB LIST_DB_T ADA DD12V_T-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_T DB2 DD12V_T-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_T DB4 DD12V_T-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_T DB6 DD12V_T-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_T INF DD12V_T-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_T MSS DD12V_T-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_T ORA DD12V_T-DBINCLEXCL.

* Fülle Liste der DB-Plattformen: Vorlagenindex
    FILL_LIST_DB LIST_DB_M ADA DD12V_M-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_M DB2 DD12V_M-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_M DB4 DD12V_M-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_M DB6 DD12V_M-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_M INF DD12V_M-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_M MSS DD12V_M-DBINCLEXCL.
    FILL_LIST_DB LIST_DB_M ORA DD12V_M-DBINCLEXCL.

* Markiere DB-Plattformen bzgl. Anlegen/nicht Anlegen: Teilnehmerindex
    LOOP AT LIST_DB_T.
      IF LIST_DB_T-DBNAME EQ DD12V_T-DBSYSSEL1 OR
         LIST_DB_T-DBNAME EQ DD12V_T-DBSYSSEL2 OR
         LIST_DB_T-DBNAME EQ DD12V_T-DBSYSSEL3 OR
         LIST_DB_T-DBNAME EQ DD12V_T-DBSYSSEL4.
           IF DD12V_T-DBINCLEXCL = 'I'.
             LIST_DB_T-CREATE = 'Y'.
           ENDIF.
           IF DD12V_T-DBINCLEXCL = 'E'.
             LIST_DB_T-CREATE = 'N'.
           ENDIF.
      ENDIF.
      MODIFY LIST_DB_T.
    ENDLOOP.

* Markiere DB-Plattformen bzgl. Anlegen/nicht Anlegen: Vorlagenindex
    LOOP AT LIST_DB_M.
      IF LIST_DB_M-DBNAME EQ DD12V_M-DBSYSSEL1 OR
         LIST_DB_M-DBNAME EQ DD12V_M-DBSYSSEL2 OR
         LIST_DB_M-DBNAME EQ DD12V_M-DBSYSSEL3 OR
         LIST_DB_M-DBNAME EQ DD12V_M-DBSYSSEL4.
           IF DD12V_M-DBINCLEXCL = 'I'.
             LIST_DB_M-CREATE = 'Y'.
           ENDIF.
           IF DD12V_M-DBINCLEXCL = 'E'.
             LIST_DB_M-CREATE = 'N'.
           ENDIF.
      ENDIF.
      MODIFY LIST_DB_M.
    ENDLOOP.

* Vergleiche die beiden Listen
    DB_SYSTEMS = 'Y'.
    COUNTER = 1.
    LOOP AT LIST_DB_M.
      READ TABLE LIST_DB_T INDEX COUNTER.
      IF LIST_DB_T-CREATE NE LIST_DB_M-CREATE.
        DB_SYSTEMS = 'N'.
      ENDIF.
      ADD 1 TO COUNTER.
    ENDLOOP.

* Melde aufgetretene Abweichungen der Listen
    IF DB_SYSTEMS = 'N'.
      ERRORS-TABNAME = T_TAB.
      ERRORS-FIELDNAME = T_IND.
      ERRORS-ERROR = 'DB_LIST'.
      APPEND ERRORS.
    ENDIF.
  ENDIF.
ENDIF.

***********************************************************************
* Prüfe, on die Feldstruktur der beiden Indizes übereinstimmt.        *
* Zuerst wird geprüft, ob die Feldanzahl beider Indizes übereinstimmt.*
* Falls dies so ist, wird geprüft, ob eine 1 zu 1 Abbildung bzgl.     *
* Datentyp und Feldlänge zwischen den Feldern beider Indizes möglich  *
* ist. Falls auch dies gilt, wird geprüft, ob eine solche 1 zu 1      *
* Abbildung vorhanden ist, die die Feldreihenfolge in beiden Indizes  *
* beibehält.                                                          *
***********************************************************************

* Hole die Feldnamen und Positionen der Felder des Teilnehmerindex
LOOP AT DD17V_T.
  FIELD_STR_T-FIELDNAME = DD17V_T-FIELDNAME.
  FIELD_STR_T-POSITION = DD17V_T-POSITION.
  APPEND FIELD_STR_T.
ENDLOOP.

* Hole die Feldnamen und Positionen der Felder des Vorlagenindex
LOOP AT DD17V_M.
  FIELD_STR_M-FIELDNAME = DD17V_M-FIELDNAME.
  FIELD_STR_M-POSITION = DD17V_M-POSITION.
  APPEND FIELD_STR_M.
ENDLOOP.

* Lese die Datentypen und Feldlängen der Felder des Teilnehmerindex
LOOP AT FIELD_STR_T.
  LONG_NAME_T = FIELD_STR_T-FIELDNAME.
  CALL FUNCTION 'DDIF_FIELDINFO_GET'
       EXPORTING
            TABNAME        = T_TAB
            FIELDNAME      = FIELD_STR_T-FIELDNAME
            LANGU          = SY-LANGU
            LFIELDNAME     = LONG_NAME_T
*           ALL_TYPES      = ' '
       IMPORTING
*           X030L_WA       =
*           DDOBJTYPE      =
            DFIES_WA       = DFIES_T
*      TABLES
*           DFIES_TAB      =
*      EXCEPTIONS
*           NOT_FOUND      = 1
*           INTERNAL_ERROR = 2
*           OTHERS         = 3
            .
  FIELD_STR_T-DATATYPE = DFIES_T-DATATYPE.
  FIELD_STR_T-LENG = DFIES_T-LENG.
  MODIFY FIELD_STR_T.
ENDLOOP.

* Lese die Datentypen und Feldlängen der Felder des Vorlagenindex
LOOP AT FIELD_STR_M.
  LONG_NAME_M = FIELD_STR_M-FIELDNAME.
  CALL FUNCTION 'DDIF_FIELDINFO_GET'
       EXPORTING
            TABNAME        = M_TAB
            FIELDNAME      = FIELD_STR_M-FIELDNAME
            LANGU          = SY-LANGU
            LFIELDNAME     = LONG_NAME_M
*           ALL_TYPES      = ' '
       IMPORTING
*           X030L_WA       =
*           DDOBJTYPE      =
            DFIES_WA       = DFIES_M
*      TABLES
*           DFIES_TAB      =
*      EXCEPTIONS
*           NOT_FOUND      = 1
*           INTERNAL_ERROR = 2
*           OTHERS         = 3
            .
  FIELD_STR_M-DATATYPE = DFIES_M-DATATYPE.
  FIELD_STR_M-LENG = DFIES_M-LENG.
  MODIFY FIELD_STR_M.
ENDLOOP.

* Zähle die Felder beider Indizes
ANZ_FIELDS_T = 0.
LOOP AT FIELD_STR_T.
  ADD 1 TO ANZ_FIELDS_T.
ENDLOOP.

ANZ_FIELDS_M = 0.
LOOP AT FIELD_STR_M.
  ADD 1 TO ANZ_FIELDS_M.
ENDLOOP.

* Melde abweichende Feldanzahl
IF ANZ_FIELDS_M NE ANZ_FIELDS_T.
  ERRORS-TABNAME = T_TAB.
  ERRORS-FIELDNAME = T_IND.
  ERRORS-ERROR = 'FIELD_NUMBER'.
  IF ANZ_FIELDS_M < ANZ_FIELDS_T.
    ERRORS-HINT = 'TO_MANY'.
  ELSE.
    ERRORS-HINT = 'NOT_ENOUGH'.
  ENDIF.
  APPEND ERRORS.
ENDIF.

* Prüfe, ob eine 1 zu 1 Zuordnung bzgl. der Datentypen und Längen
* möglich ist
IF ANZ_FIELDS_M = ANZ_FIELDS_T.
  STRUCTURE_IDENTICAL = 'Y'.
  COUNTER = 1.
  SORT FIELD_STR_M BY DATATYPE LENG.
  SORT FIELD_STR_T BY DATATYPE LENG.
  LOOP AT FIELD_STR_M.
    READ TABLE FIELD_STR_T INDEX COUNTER.
    IF FIELD_STR_M-DATATYPE NE FIELD_STR_T-DATATYPE OR
       FIELD_STR_M-LENG NE FIELD_STR_T-LENG.
       STRUCTURE_IDENTICAL = 'N'.
    ENDIF.
    ADD 1 TO COUNTER.
  ENDLOOP.
ENDIF.

* Prüfe, ob eine solche 1 zu 1 Zuordnung die Reihenfolge erhält
IF ANZ_FIELDS_M = ANZ_FIELDS_T AND STRUCTURE_IDENTICAL = 'Y'.
  ORDER_IDENTICAL = 'Y'.
  COUNTER = 1.
  SORT FIELD_STR_M BY POSITION DATATYPE LENG.
  SORT FIELD_STR_T BY POSITION DATATYPE LENG.
  LOOP AT FIELD_STR_M.
    READ TABLE FIELD_STR_T INDEX COUNTER.
    IF FIELD_STR_M-DATATYPE NE FIELD_STR_T-DATATYPE OR
       FIELD_STR_M-LENG NE FIELD_STR_T-LENG.
       ORDER_IDENTICAL = 'N'.
    ENDIF.
    ADD 1 TO COUNTER.
  ENDLOOP.
ENDIF.

* Melde Fehler bzgl. Zuordenbarkeit
IF STRUCTURE_IDENTICAL = 'N'.
  ERRORS-TABNAME = T_TAB.
  ERRORS-FIELDNAME = T_IND.
  ERRORS-ERROR = 'WRONG_FIELDS'.
  APPEND ERRORS.
ENDIF.

* Melde Fehler bzgl. Reihenfolge
IF ORDER_IDENTICAL = 'N'.
  ERRORS-TABNAME = T_TAB.
  ERRORS-FIELDNAME = T_IND.
  ERRORS-ERROR = 'WRONG_ORDER'.
  APPEND ERRORS.
ENDIF.

ENDFUNCTION.
