*&---------------------------------------------------------------------*
*& Report  SAPBC408DYNT
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408dynt.

* work area plus internal table for ALV data
DATA:
  wa_sbook             TYPE sbook,
  it_sbook             LIKE TABLE OF wa_sbook.


SELECT-OPTIONS:
  so_car FOR wa_sbook-carrid MEMORY ID car,
  so_con FOR wa_sbook-connid MEMORY ID con,
  so_dat FOR wa_sbook-fldate MEMORY ID dat.



************************************************************************
START-OF-SELECTION.
  SELECT * FROM sbook
    INTO TABLE it_sbook
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.
