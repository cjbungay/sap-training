*&---------------------------------------------------------------------*
*& Include BC410INPD_0_PROPERTIESTOP                                   *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc410inpd_0_properties     .

TABLES: sdyn_conn.

DATA: new_screen LIKE screen,
      ok_code like sy-ucomm,
      initialised.
