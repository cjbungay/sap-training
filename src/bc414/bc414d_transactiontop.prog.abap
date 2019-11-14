*&---------------------------------------------------------------------*
*& Include BC414D_TRANSACTIONTOP                                       *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  SAPBC414D_TRANSACTION         .

tables: spfli, sflight.

DATA: OK_CODE      type sy-ucomm,
      save_ok_code like ok_code.
