*&---------------------------------------------------------------------*
*& Include BC410D_TEMPLATETOP                                          *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM   sapbc410d_template1 MESSAGE-ID bc410          .

DATA: ok_code LIKE sy-ucomm.

DATA: wa_spfli TYPE spfli.
TABLES sdyn_conn.

CONTROLS my_tabstrip TYPE TABSTRIP.

DATA dynnr LIKE sy-dynnr.                                   "#EC NEEDED
