*&---------------------------------------------------------------------*
*& Include BC410D_TEMPLATETOP                                          *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM   SAPBC410D_TEMPLATE1   message-id bc410        .

DATA: ok_code LIKE sy-ucomm.
DATA: wa_spfli TYPE spfli.
TABLES sdyn_conn.

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  clear ok_code.
  ENDMODULE.                           " clear_ok_code  OUTPUT
