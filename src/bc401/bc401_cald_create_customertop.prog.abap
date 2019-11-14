*&---------------------------------------------------------------------*
*& Include BC401_CALD_CREATE_CUSTOMERTOP                               *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc401_cald_create_customer MESSAGE-ID bc401.

DATA:
  answer, flag.

DATA:
  ok_code LIKE sy-ucomm,
  save_ok LIKE ok_code.

TABLES:
  scustom,
  sbuspart.
