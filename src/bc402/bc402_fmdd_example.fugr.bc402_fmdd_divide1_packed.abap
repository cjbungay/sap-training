FUNCTION BC402_FMDD_DIVIDE1_PACKED .
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(I_NUMBER1) TYPE  DEC8_2 DEFAULT 1
*"     REFERENCE(I_NUMBER2) TYPE  DEC8_2
*"  EXPORTING
*"     VALUE(E_RESULT) TYPE  DEC8_2
*"  EXCEPTIONS
*"      ZERO_DEVIDE
*"----------------------------------------------------------------------

  IF i_number2 = 0.
    RAISE zero_devide.
  ELSE.
    e_result = i_number1 / i_number2.
  ENDIF.

ENDFUNCTION.
