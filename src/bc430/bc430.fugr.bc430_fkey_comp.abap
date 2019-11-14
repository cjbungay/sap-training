FUNCTION BC430_FKEY_COMP.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(T_FS_TAB) LIKE  DD03L-TABNAME
*"     VALUE(T_PT_TAB) LIKE  DD03L-TABNAME
*"     VALUE(M_FS_TAB) LIKE  DD03L-TABNAME
*"     VALUE(M_PT_TAB) LIKE  DD03L-TABNAME
*"  TABLES
*"      ERRORS STRUCTURE  BC430_ERROR
*"  EXCEPTIONS
*"      T_TAB_NOT_ACTIVE
*"      M_TAB_NOT_ACTIVE
*"      SYSTEM_INCONSISTENT
*"----------------------------------------------------------------------

* Datenbereiche für den Aufruf der DD-Schnittstellen
DATA: DD05M_T LIKE DD05M OCCURS 20 WITH HEADER LINE,
      DD05M_M LIKE DD05M OCCURS 20 WITH HEADER LINE,
      DD08V_T LIKE DD08V OCCURS 20 WITH HEADER LINE,
      DD08V_M LIKE DD08V OCCURS 20 WITH HEADER LINE,
      GOTSTATE LIKE DCOBJIF-GOTSTATE.

* Datenbereiche für Namen der Fremdschl.tabellen
DATA: STR_M LIKE DD05M-FORTABLE,
      STR_T LIKE DD05M-FORTABLE.

* Datenbereiche für Zwischenergebnisse
DATA: M_REL_EX(1),
      T_REL_EX(1),
      FS_KEY_STR_ID(1),
      FOUND(1),
      IS_TEXT_M(1),
      IS_TEXT_T(1).

* Setze Defaultwerte
M_REL_EX = 'N'.
T_REL_EX = 'N'.
FS_KEY_STR_ID = 'N'.
IS_TEXT_M = 'N'.
IS_TEXT_T = 'N'.

***********************************************************************
* Lese die Fremdschlüsseltabelle der Teilnehmer                       *
***********************************************************************

CALL FUNCTION 'DDIF_TABL_GET'
     EXPORTING
          NAME          = T_FS_TAB
          STATE         = 'A'
          LANGU         = SY-LANGU
     IMPORTING
          GOTSTATE      = GOTSTATE
*         DD02V_WA      =
*         DD09L_WA      =
     TABLES
*         DD03P_TAB     =
          DD05M_TAB     = DD05M_T
          DD08V_TAB     = DD08V_T
*         DD12V_TAB     =
*         DD17V_TAB     =
*         DD35V_TAB     =
*         DD36M_TAB     =
     EXCEPTIONS
          ILLEGAL_INPUT = 1
          OTHERS        = 2.
          .
IF SY-SUBRC <> 0.
  RAISE SYSTEM_INCONSISTENT.
ENDIF.

IF GOTSTATE = ' '.
  RAISE T_TAB_NOT_ACTIVE.  "FKey table of participants not active
ENDIF.

***********************************************************************
* Lese die Fremdschlüsseltabelle der Vorlage                          *
***********************************************************************

CALL FUNCTION 'DDIF_TABL_GET'
     EXPORTING
          NAME          = M_FS_TAB
          STATE         = 'A'
          LANGU         = SY-LANGU
     IMPORTING
          GOTSTATE      = GOTSTATE
*         DD02V_WA      =
*         DD09L_WA      =
     TABLES
*         DD03P_TAB     =
          DD05M_TAB     = DD05M_M
          DD08V_TAB     = DD08V_M
*         DD12V_TAB     =
*         DD17V_TAB     =
*         DD35V_TAB     =
*         DD36M_TAB     =
     EXCEPTIONS
          ILLEGAL_INPUT = 1
          OTHERS        = 2.

IF SY-SUBRC <> 0.
  RAISE SYSTEM_INCONSISTENT.
ENDIF.

IF GOTSTATE = ' '.
  RAISE M_TAB_NOT_ACTIVE.    "Predef. Table not active
ENDIF.

***********************************************************************
* Prüfe, ob beide Beziehungen existieren bzw. nicht existieren        *
***********************************************************************

* Prüfe, ob Beziehung zw. M_FS_TAB und M_PT_TAB existiert
LOOP AT DD05M_M.
  IF DD05M_M-CHECKTABLE = M_PT_TAB.
    M_REL_EX = 'Y'.
  ENDIF.
ENDLOOP.

* Prüfe, ob Beziehung zw. T_FS_TAB und T_PT_TAB existiert
LOOP AT DD05M_T.
  IF DD05M_T-CHECKTABLE = T_PT_TAB.
    T_REL_EX = 'Y'.
  ENDIF.
ENDLOOP.

* Prüfe, ob beide Fremdschlüssel Textfremdschlüssel sind
LOOP AT DD08V_M WHERE CHECKTABLE = M_PT_TAB.
  IF DD08V_M-FRKART = 'TEXT'.
    IS_TEXT_M = 'Y'.
  ENDIF.
ENDLOOP.
LOOP AT DD08V_T WHERE CHECKTABLE = T_PT_TAB.
  IF DD08V_T-FRKART = 'TEXT'.
    IS_TEXT_T = 'Y'.
  ENDIF.
ENDLOOP.

* Prüfe, ob die Feldzuordnung in beiden FS strukturell identisch ist
IF M_REL_EX = 'Y' AND T_REL_EX = 'Y'.
  FS_KEY_STR_ID = 'Y'.
  LOOP AT DD05M_M WHERE CHECKTABLE = M_PT_TAB.
    FOUND = 'N'.
    IF DD05M_M-FORTABLE NE M_FS_TAB.  "Generische/Konst./Umgeb. FS
      IF DD05M_M-FORKEY IS INITIAL. "Generisch,Konstant
        STR_M = DD05M_M-FORTABLE.
      ELSE.
        STR_M = 'UMGEBOGEN'.        "Umgebogen
      ENDIF.
    ELSE.
      STR_M = ' '.
    ENDIF.
    LOOP AT DD05M_T WHERE CHECKTABLE = T_PT_TAB.
      IF DD05M_T-FORTABLE NE T_FS_TAB. "Generische/Konst./Umgeb. FS
        IF DD05M_T-FORKEY IS INITIAL.
          STR_T = DD05M_T-FORTABLE.
        ELSE.
          STR_T = 'UMGEBOGEN'.
        ENDIF.
      ELSE.
        STR_T = ' '.
      ENDIF.
      IF DD05M_M-DATATYPE = DD05M_T-DATATYPE AND
         DD05M_M-LENG = DD05M_T-LENG AND STR_M = STR_T.
        FOUND = 'Y'.
      ENDIF.
    ENDLOOP.
    IF FOUND = 'N'.
      FS_KEY_STR_ID = 'N'.
    ENDIF.
  ENDLOOP.
ENDIF.

***********************************************************************
* Melde aufgetretene Fehler                                           *
***********************************************************************

IF M_REL_EX = 'Y' AND T_REL_EX = 'N'.
  ERRORS-TABNAME = T_FS_TAB.
  ERRORS-ERROR = 'FK_NOT_EX'.
  APPEND ERRORS.
ELSEIF M_REL_EX = 'Y' AND T_REL_EX = 'Y'.
  IF FS_KEY_STR_ID = 'N'.
    ERRORS-TABNAME = T_FS_TAB.
    ERRORS-ERROR = 'FK_STR_NOT_OK'.
    APPEND ERRORS.
  ENDIF.
  IF IS_TEXT_M EQ 'Y' AND IS_TEXT_T EQ 'N'.
    ERRORS-TABNAME = T_FS_TAB.
    ERRORS-ERROR = 'MUST_BE_TEXT'.
    APPEND ERRORS.
  ELSEIF IS_TEXT_M EQ 'N' AND IS_TEXT_T EQ 'Y'.
    ERRORS-TABNAME = T_FS_TAB.
    ERRORS-ERROR = 'SHOULD_NOT_BE_TEXT'.
    APPEND ERRORS.
  ENDIF.
ENDIF.

ENDFUNCTION.
