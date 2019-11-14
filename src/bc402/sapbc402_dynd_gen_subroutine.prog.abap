*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYND_GEN_SUBROUTINE
*&
*&---------------------------------------------------------------------*
*& Generates Subroutine pool and calls a form in that subroutine pool
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_dynd_gen_subroutine.


DATA:
    itab TYPE TABLE OF string,"char72,
    prog TYPE string.

*Fill internal Table
APPEND 'REPORT ztest.'    TO itab.                           "#EC NOTEXT
APPEND 'FORM show.'       TO itab.                           "#EC NOTEXT
APPEND 'WRITE ''Hello''.' TO itab.                           "#EC NOTEXT
*APPEND 'BREAK-POINT.'     TO itab.                           "#EC NOTEXT
APPEND 'ENDFORM.'         TO itab.                           "#EC NOTEXT


GENERATE SUBROUTINE POOL itab NAME prog.


PERFORM show
    IN PROGRAM (prog) IF FOUND.
