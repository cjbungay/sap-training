FUNCTION bc402_fmdd_wait_add.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IP_CUST) TYPE  BC402_TYPD_CUST
*"  EXCEPTIONS
*"      IN_LIST
*"----------------------------------------------------------------------

  READ TABLE wait_list FROM ip_cust TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    APPEND ip_cust TO wait_list.
  ELSE.
    MESSAGE e202(bc402) RAISING in_list.
  ENDIF.

ENDFUNCTION.
