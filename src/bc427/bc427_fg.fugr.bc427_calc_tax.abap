FUNCTION BC427_CALC_TAX.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IM_NETPRICE) TYPE  BC427_PRICE
*"  EXPORTING
*"     REFERENCE(EX_TAX) TYPE  BC427_PRICE
*"----------------------------------------------------------------------

  ex_tax  =  im_netprice * 19 / 100 .

ENDFUNCTION.
