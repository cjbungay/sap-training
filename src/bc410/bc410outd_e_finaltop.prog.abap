*&---------------------------------------------------------------------*
*& Include BC410D_TEMPLATETOP                                          *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM   SAPBC410D_TEMPLATE1   message-id bc410        .

DATA: ok_code LIKE sy-ucomm.

DATA: wa_spfli TYPE spfli.
TABLES sdyn_conn.

data: icon1 like icons-text,icon2 like icons-text,
      icon_name like icon-name.
