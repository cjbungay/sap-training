*&---------------------------------------------------------------------*
*& Include BC414S_CREATE_CUSTOMERTOP                                   *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc414s_create_customer MESSAGE-ID bc414.

DATA: answer, flag.
DATA: ok_code LIKE sy-ucomm, save_ok LIKE ok_code.
TABLES: scustom.
