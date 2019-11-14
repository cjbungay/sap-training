FUNCTION bc402_fmdd_wait_get_first.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  EXPORTING
*"     REFERENCE(EP_CUST) TYPE  BC402_TYPD_CUST
*"  EXCEPTIONS
*"      LIST_EMPTY
*"----------------------------------------------------------------------

  READ TABLE wait_list INTO ep_cust INDEX 1.
  IF sy-subrc = 0.
    DELETE wait_list INDEX 1.
  ELSE.
    MESSAGE e200(bc402) RAISING list_empty.
  ENDIF.

ENDFUNCTION.
