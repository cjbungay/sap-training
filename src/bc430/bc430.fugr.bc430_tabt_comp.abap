FUNCTION BC430_TABT_COMP.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(T_TAB) LIKE  DD03L-TABNAME
*"     VALUE(M_TAB) LIKE  DD03L-TABNAME
*"  TABLES
*"      ERRORS STRUCTURE  BC430_ERROR
*"  EXCEPTIONS
*"      T_TSET_NOT_ACTIVE
*"      M_TSET_NOT_ACTIVE
*"      SYSTEM_INCONSISTENT
*"----------------------------------------------------------------------

DATA: DD09L_M LIKE DD09L OCCURS 20 WITH HEADER LINE.
DATA: DD09L_T LIKE DD09L OCCURS 20 WITH HEADER LINE.
DATA: GOTSTATE LIKE DCOBJIF-GOTSTATE.

***********************************************************************
* Lese die techn. Einstellungen der Teilnehmertabelle                 *
***********************************************************************

CALL FUNCTION 'DDIF_TABT_GET'
     EXPORTING
          NAME          = T_TAB
          STATE         = 'A'
     IMPORTING
          GOTSTATE      = GOTSTATE
          DD09L_WA      = DD09L_T
     EXCEPTIONS
          ILLEGAL_INPUT = 1
          OTHERS        = 2.

IF SY-SUBRC <> 0.
  RAISE SYSTEM_INCONSISTENT.
ENDIF.

IF GOTSTATE NE 'A'.
  RAISE T_TSET_NOT_ACTIVE.
ENDIF.

***********************************************************************
* Lese die techn. Einstellungen der Vorlagentabelle                   *
***********************************************************************

CALL FUNCTION 'DDIF_TABT_GET'
     EXPORTING
          NAME          = M_TAB
          STATE         = 'A'
     IMPORTING
          GOTSTATE      = GOTSTATE
          DD09L_WA      = DD09L_M
     EXCEPTIONS
          ILLEGAL_INPUT = 1
          OTHERS        = 2.

IF SY-SUBRC <> 0.
  RAISE SYSTEM_INCONSISTENT.
ENDIF.

IF GOTSTATE NE 'A'.
  RAISE M_TSET_NOT_ACTIVE.
ENDIF.

***********************************************************************
* Vergleiche die technischen Einstellungen und schreibe Fehler in     *
* die Tabelle ERRORS.                                                 *
***********************************************************************

* Vergleiche Größenkategorie
IF DD09L_T-TABKAT NE DD09L_M-TABKAT.
  ERRORS-TABNAME = DD09L_T-TABNAME.
  ERRORS-ERROR = 'SIZE_CATEGORY'.
  ERRORS-HINT = DD09L_M-TABKAT.
  APPEND ERRORS.
ENDIF.

* Vergleiche Datenart
IF DD09L_T-TABART NE DD09L_M-TABART.
  ERRORS-TABNAME = DD09L_T-TABNAME.
  ERRORS-ERROR = 'DATA_CLASS'.
  ERRORS-HINT = DD09L_M-TABART.
  APPEND ERRORS.
ENDIF.

* Vergleiche Protokollierungskennzeichen
IF DD09L_T-PROTOKOLL NE DD09L_M-PROTOKOLL.
  ERRORS-TABNAME = DD09L_T-TABNAME.
  ERRORS-ERROR = 'PROTOCOL'.
  ERRORS-HINT = DD09L_M-PROTOKOLL.
  APPEND ERRORS.
ENDIF.

* Vergleiche Pufferungseinstellungen
IF DD09L_T-BUFALLOW NE DD09L_M-BUFALLOW.
  ERRORS-TABNAME = DD09L_T-TABNAME.
  ERRORS-ERROR = 'BUFF_ALLOW'.
  ERRORS-HINT = DD09L_M-BUFALLOW.
  APPEND ERRORS.
ELSE.
  IF DD09L_T-PUFFERUNG NE DD09L_M-PUFFERUNG.
    ERRORS-TABNAME = DD09L_T-TABNAME.
    ERRORS-ERROR = 'BUFF_TYPE'.
    ERRORS-HINT = DD09L_M-PUFFERUNG.
    APPEND ERRORS.
  ELSE.
    IF DD09L_T-SCHFELDANZ NE DD09L_M-SCHFELDANZ
       AND DD09L_M-PUFFERUNG = 'G'.
         ERRORS-TABNAME = DD09L_T-TABNAME.
         ERRORS-ERROR = 'KEY_FIELDS'.
         ERRORS-HINT = DD09L_M-SCHFELDANZ.
         APPEND ERRORS.
    ENDIF.
  ENDIF.
ENDIF.

ENDFUNCTION.
