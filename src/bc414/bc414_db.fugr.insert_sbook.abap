FUNCTION INSERT_SBOOK.
*"----------------------------------------------------------------------
*"*"Verbuchungsfunktionsbaustein:
*"
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(WA_SBOOK) LIKE  SBOOK STRUCTURE  SBOOK
*"       EXCEPTIONS
*"              INSERT_FAILURE
*"----------------------------------------------------------------------

  INSERT INTO SBOOK VALUES WA_SBOOK.
  IF SY-SUBRC <> 0.
    MESSAGE A048 RAISING INSERT_FAILURE.
  ENDIF.

ENDFUNCTION.
