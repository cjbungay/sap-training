FUNCTION bc402_fmdd_wait_display.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  EXCEPTIONS
*"      LIST_EMPTY
*"----------------------------------------------------------------------

  IF wait_list IS INITIAL.
    MESSAGE e200(bc402) RAISING list_empty.
  ELSE.
    CALL SCREEN 100 STARTING AT   5  5
                    ENDING   AT 120 25.
  ENDIF.

ENDFUNCTION.
