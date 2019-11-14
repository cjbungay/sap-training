FUNCTION UPDATE_SBOOK_A.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(ITAB_SBOOK) TYPE  BC_SBOOK
*"       EXCEPTIONS
*"              UPDATE_FAILURE
*"----------------------------------------------------------------------

  UPDATE SBOOK FROM TABLE ITAB_SBOOK.
  CASE SY-SUBRC.
    WHEN 0.
      MESSAGE I034.
    WHEN OTHERS.
      MESSAGE E048 RAISING UPDATE_FAILURE.
  ENDCASE.

ENDFUNCTION.
