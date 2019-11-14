FUNCTION BC402_FMDD_DIVIDE3_SYST_EXCP .
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
  TRY.
      l_num1 = i_number1.
      l_num2 = i_number2.

    CATCH cx_sy_conversion_overflow.
      RAISE overflow.

  ENDTRY.

* Do calculation.
  TRY.
      l_res = l_num1 / l_num2.

    CATCH cx_sy_zerodivide.
      RAISE zero_devide.
  ENDTRY.

* move result to output
  e_result = l_res.

ENDFUNCTION.
