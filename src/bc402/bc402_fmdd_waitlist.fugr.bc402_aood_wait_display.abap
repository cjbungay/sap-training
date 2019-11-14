FUNCTION bc402_aood_wait_display.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IP_WAITLIST) TYPE  BC402_TYPD_CUST_LIST
*"  EXCEPTIONS
*"      LIST_EMPTY
*"----------------------------------------------------------------------

  IF ip_waitlist IS INITIAL.
    MESSAGE e200(bc402) RAISING list_empty.
  ELSE.
    wait_list_aoo = ip_waitlist.
    CALL SCREEN 200 STARTING AT   5  5
                    ENDING   AT 120 25.
  ENDIF.

ENDFUNCTION.
