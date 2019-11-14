FUNCTION BC402_FMDD_DIVIDE4_EXCP_CLASS .
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(I_NUMBER1) TYPE  NUMERIC
*"     REFERENCE(I_NUMBER2) TYPE  NUMERIC
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  NUMERIC
*"  RAISING
*"      CX_SY_CONVERSION_OVERFLOW
*"      CX_SY_ZERODIVIDE
*"----------------------------------------------------------------------

  DATA:
      l_num1 TYPE p LENGTH 8 DECIMALS 2,
      l_num2 TYPE p LENGTH 8 DECIMALS 2,
      l_res  TYPE p LENGTH 8 DECIMALS 2.

* move to local variables to ensure arithmetic and precision
  l_num1 = i_number1.
  l_num2 = i_number2.

* Do calculation.
  l_res = l_num1 / l_num2.

* move result to output
  e_result = l_res.

ENDFUNCTION.
