FUNCTION bc402_fmdd_wait_delete.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IP_ID) TYPE  S_CUSTOMER
*"  EXCEPTIONS
*"      NOT_IN_LIST
*"----------------------------------------------------------------------

  DELETE wait_list WHERE id = ip_id.
  IF sy-subrc <> 0.
    MESSAGE e203(bc402) RAISING not_in_list.
  ENDIF.

ENDFUNCTION.
