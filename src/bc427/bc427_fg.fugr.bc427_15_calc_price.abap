FUNCTION BC427_15_CALC_PRICE.
*"--------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IM_NETPRICE) TYPE  BC427_PRICE
*"  EXPORTING
*"     REFERENCE(EX_FULLPRICE) TYPE  BC427_PRICE
*"--------------------------------------------------------------------

  ex_fullprice  =  im_netprice * 119 / 100 .

ENDFUNCTION.
