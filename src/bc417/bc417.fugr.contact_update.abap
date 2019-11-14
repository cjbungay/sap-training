FUNCTION CONTACT_UPDATE.
*"----------------------------------------------------------------------
*"*"Update function module:
*"
*"*"Local interface:
*"  IMPORTING
*"     VALUE(CONTACT_INFO) TYPE  SKNVK
*"----------------------------------------------------------------------
UPDATE sknvk FROM contact_info.
  IF SY-SUBRC <> 0.
    MESSAGE A006(BC417).
  ENDIF.


ENDFUNCTION.
