FUNCTION BC401_DISPLAY_DATA.
*"--------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IM_LIST) TYPE  TAW10_TYPD_CUST_LIST
*"--------------------------------------------------------------------

  cust_list = im_list.

  CALL SCREEN 100 STARTING AT   5  5
                  ENDING   AT 120 25.

ENDFUNCTION.
