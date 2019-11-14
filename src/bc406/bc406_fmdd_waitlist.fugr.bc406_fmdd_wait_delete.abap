FUNCTION BC406_FMDD_WAIT_DELETE.
*"----------------------------------------------------------------------
*"*"Local interface:
*"       IMPORTING
*"             REFERENCE(IP_ID) TYPE  S_CUSTOMER
*"       EXCEPTIONS
*"              NOT_IN_LIST
*"----------------------------------------------------------------------

  DELETE wait_list WHERE id = ip_id.
  IF sy-subrc <> 0.
    MESSAGE e203(bc402) RAISING not_in_list.
  ENDIF.

ENDFUNCTION.
