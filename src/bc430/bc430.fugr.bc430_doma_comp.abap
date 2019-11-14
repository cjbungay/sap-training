FUNCTION BC430_DOMA_COMP.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(T_DOMA) LIKE  DD01L-DOMNAME
*"             VALUE(M_DOMA) LIKE  DD01L-DOMNAME
*"       TABLES
*"              ERRORS STRUCTURE  BC430_ERROR
*"       EXCEPTIONS
*"              T_DOMA_NOT_EXIST
*"              T_DOMA_NOT_ACTIVE
*"              M_DOMA_NOT_ACTIVE
*"              SYSTEM_INCONSISTENT
*"----------------------------------------------------------------------

* Datenbereiche
  DATA: DD01V_T LIKE DD01V,
        DD01V_M LIKE DD01V,
        DD07V_T LIKE DD07V OCCURS 20 WITH HEADER LINE,
        DD07V_M LIKE DD07V OCCURS 20 WITH HEADER LINE,
        GOTSTATE LIKE DCOBJIF-GOTSTATE.

* Datenbereiche für Zwischenergebnisse
  DATA: MATCH(1),
        VALUES_OK(1) TYPE C.

**********************************************************************
* Lese die Teilnehmerdomäne.                                         *
**********************************************************************

  CALL FUNCTION 'DDIF_DOMA_GET'
       EXPORTING
            NAME          = T_DOMA
            STATE         = 'M'
            LANGU         = ' '
       IMPORTING
            GOTSTATE      = GOTSTATE
            DD01V_WA      = DD01V_T
       TABLES
            DD07V_TAB     = DD07V_T
       EXCEPTIONS
            ILLEGAL_INPUT = 1
            OTHERS        = 2.

  IF SY-SUBRC <> 0.
    RAISE SYSTEM_INCONSISTENT.
  ENDIF.

  IF GOTSTATE = ' '.
    RAISE T_DOMA_NOT_EXIST.
  ENDIF.
  IF GOTSTATE NE 'A'.
    RAISE T_DOMA_NOT_ACTIVE.
  ENDIF.

***********************************************************************
* Lese die vordefinierte Domäne.                                      *
***********************************************************************

  CALL FUNCTION 'DDIF_DOMA_GET'
       EXPORTING
            NAME          = M_DOMA
            STATE         = 'M'
            LANGU         = ' '
       IMPORTING
            GOTSTATE      = GOTSTATE
            DD01V_WA      = DD01V_M
       TABLES
            DD07V_TAB     = DD07V_M
       EXCEPTIONS
            ILLEGAL_INPUT = 1
            OTHERS        = 2.

  IF SY-SUBRC <> 0.
    RAISE SYSTEM_INCONSISTENT.
  ENDIF.

  IF GOTSTATE NE 'A'.
    RAISE M_DOMA_NOT_ACTIVE.
  ENDIF.

***********************************************************************
* Vergleiche die Domänen                                              *
***********************************************************************

* Vergleiche den Datentyp
  IF DD01V_T-DATATYPE NE DD01V_M-DATATYPE.
    ERRORS-TABNAME = T_DOMA.
    ERRORS-ERROR = 'DATATYPE'.
    APPEND ERRORS.
  ENDIF.

* Vergleiche die Feldlänge
  IF DD01V_T-LENG NE DD01V_M-LENG.
    ERRORS-TABNAME = T_DOMA.
    ERRORS-ERROR = 'LENGTH'.
    APPEND ERRORS.
  ENDIF.

* Vergleiche die Anzahl der Dezimalstellen
  IF DD01V_T-DECIMALS NE DD01V_M-DECIMALS.
    ERRORS-TABNAME = T_DOMA.
    ERRORS-ERROR = 'DECIMALS'.
    APPEND ERRORS.
  ENDIF.

* Vergleiche die Festwerte
  VALUES_OK = 'Y'.

  LOOP AT DD07V_M.
    MATCH = 'N'.
    LOOP AT DD07V_T.
      IF DD07V_T-DOMVALUE_L = DD07V_M-DOMVALUE_L AND
         DD07V_T-DOMVALUE_H = DD07V_M-DOMVALUE_H.
        MATCH = 'Y'.
      ENDIF.
    ENDLOOP.
    IF MATCH = 'N'.
      VALUES_OK = 'N'.
    ENDIF.
  ENDLOOP.

  IF VALUES_OK = 'N'.
    ERRORS-TABNAME = T_DOMA.
    ERRORS-ERROR = 'VALUE'.
    APPEND ERRORS.
  ENDIF.

ENDFUNCTION.
