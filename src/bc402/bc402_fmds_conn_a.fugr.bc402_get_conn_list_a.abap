FUNCTION BC402_GET_CONN_LIST_A.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IP_START) TYPE  S_FROM_CIT
*"     VALUE(IP_DEST) TYPE  S_TO_CITY
*"  EXPORTING
*"     REFERENCE(EP_CONN_LIST) TYPE  BC402_T_CONN
*"  EXCEPTIONS
*"      NO_CONN
*"----------------------------------------------------------------------
ENDFUNCTION.
