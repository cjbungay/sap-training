FUNCTION UPDATE_SBOOK .
*"----------------------------------------------------------------------
*"*"Verbuchungsfunktionsbaustein:
*"
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(ITAB_SBOOK) TYPE  BC_SBOOK
*"       EXCEPTIONS
*"              UPDATE_FAILURE
*"----------------------------------------------------------------------

  UPDATE SBOOK FROM TABLE ITAB_SBOOK.
  IF SY-SUBRC <> 0.
    MESSAGE A048 RAISING UPDATE_FAILURE.
  ENDIF.

ENDFUNCTION.
