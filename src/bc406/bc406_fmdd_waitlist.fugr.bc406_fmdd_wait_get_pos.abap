FUNCTION BC406_FMDD_WAIT_GET_POS.
*"----------------------------------------------------------------------
*"*"Local interface:
*"       IMPORTING
*"             REFERENCE(IP_ID) TYPE  S_CUSTOMER
*"       EXPORTING
*"             REFERENCE(EP_POS) TYPE  SY-TABIX
*"       EXCEPTIONS
*"              NOT_IN_LIST
*"----------------------------------------------------------------------
  READ TABLE wait_list WITH KEY id = ip_id TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    ep_pos = sy-tabix.
  ELSE.
    MESSAGE e203(bc402) RAISING not_in_list.
  ENDIF.

ENDFUNCTION.
