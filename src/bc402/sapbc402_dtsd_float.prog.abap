*&---------------------------------------------------------------------*
*& Report  SAPBC402_STMD_FLOAT                                         *
*&                                                                     *
*&---------------------------------------------------------------------*
*& a floating point multiplication,                                    *
*& not exact from a "business application" point of view             *
*&---------------------------------------------------------------------*

REPORT  sapbc402_stmd_float.

DATA:
  float TYPE f,
  pack  TYPE p DECIMALS 2.


START-OF-SELECTION.

  float = 73050 * '0.0727'.        " result: 5.3107349999999997E+03



  pack  = float.

  WRITE pack.                      " result: 5310.73 instead of 5310.74!
