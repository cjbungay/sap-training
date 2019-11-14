*&---------------------------------------------------------------------*
*& Report  SAPBC480_EXCEPTION
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc480_exception.

DATA:
  result  TYPE p DECIMALS 2,
  text    TYPE string,
  r_error TYPE REF TO cx_root.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(60) text-c01.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(60) text-c02.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_int1 TYPE i DEFAULT 1,
  pa_int2 TYPE i DEFAULT 2.

START-OF-SELECTION.
  TRY.
      result = pa_int1 * pa_int2. WRITE / result.
      result = pa_int1 / pa_int2. WRITE / result.

    CATCH cx_sy_arithmetic_overflow INTO r_error.
      text = r_error->get_text( ).
      MESSAGE text TYPE 'I'.

    CATCH cx_root.
      MESSAGE 'Unclassified error'(e01) TYPE 'I'.

  ENDTRY.

  WRITE: / 'After the calculation'(cal).
