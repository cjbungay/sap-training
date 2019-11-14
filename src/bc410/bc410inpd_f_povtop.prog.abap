*&---------------------------------------------------------------------*
*& Include BC410D_TEMPLATETOP                                          *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM   sapbc410d_template1           .

TYPE-POOLS shlp.

DATA: ok_code LIKE sy-ucomm.

TABLES sdyn_conn00.
DATA: wa_conn LIKE sdyn_conn00.
DATA fieldname(30).

DATA  repid LIKE sy-repid..
