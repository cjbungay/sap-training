FUNCTION BC402_FMDD_DIVIDE2_GENERIC .
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(I_NUMBER1) TYPE  NUMERIC
*"     REFERENCE(I_NUMBER2) TYPE  NUMERIC
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  NUMERIC
*"  EXCEPTIONS
*"      ZERO_DEVIDE
*"      OVERFLOW
*"----------------------------------------------------------------------

  DATA:
      l_num1 TYPE p LENGTH 8 DECIMALS 2,
      l_num2 TYPE p LENGTH 8 DECIMALS 2,
      l_res  TYPE p LENGTH 8 DECIMALS 2.

* move to local variables to ensure arithmetic and precision
  IF i_number1 GT  '9999999999999.99' OR
     i_number1 LT '-9999999999999.99' OR
     i_number2 GT  '9999999999999.99' OR
     i_number2 LT '-9999999999999.99'.

    RAISE overflow.
  ENDIF.

  l_num1 = i_number1.
  l_num2 = i_number2.

  IF l_num2 = 0.
    RAISE zero_devide.
  ELSE.
    l_res = l_num1 / l_num2.
  ENDIF.

* move result to output
  e_result = l_res.

ENDFUNCTION.
