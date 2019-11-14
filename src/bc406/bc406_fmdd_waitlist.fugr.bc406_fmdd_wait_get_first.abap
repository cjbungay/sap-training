FUNCTION BC406_FMDD_WAIT_GET_FIRST.
*"----------------------------------------------------------------------
*"*"Local interface:
*"       EXPORTING
*"             REFERENCE(EP_CUST) TYPE  BC402_TYPD_CUST
*"       EXCEPTIONS
*"              LIST_EMPTY
*"----------------------------------------------------------------------

  READ TABLE wait_list INTO ep_cust INDEX 1.
  IF sy-subrc = 0.
    DELETE wait_list INDEX 1.
  ELSE.
    MESSAGE e200(bc402) RAISING list_empty.
  ENDIF.

ENDFUNCTION.
