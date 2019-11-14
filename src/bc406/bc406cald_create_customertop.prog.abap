*&---------------------------------------------------------------------*
*& Include BC406CALD_CREATE_CUSTOMERTOP                               *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc406cald_create_customer MESSAGE-ID bc406.

DATA:
  answer, flag.

DATA:
  ok_code LIKE sy-ucomm,
  save_ok LIKE ok_code.

TABLES:
  scustom,
  sbuspart.
