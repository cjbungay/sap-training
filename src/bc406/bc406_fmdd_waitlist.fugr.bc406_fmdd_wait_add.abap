FUNCTION BC406_FMDD_WAIT_ADD.
*"----------------------------------------------------------------------
*"*"Local interface:
*"       IMPORTING
*"             REFERENCE(IP_CUST) TYPE  BC402_TYPD_CUST
*"       EXCEPTIONS
*"              IN_LIST
*"----------------------------------------------------------------------

  READ TABLE wait_list FROM ip_cust TRANSPORTING NO FIELDS.
  IF sy-subrc <> 0.
    APPEND ip_cust TO wait_list.
  ELSE.
    MESSAGE e202(bc402) RAISING in_list.
  ENDIF.

ENDFUNCTION.
