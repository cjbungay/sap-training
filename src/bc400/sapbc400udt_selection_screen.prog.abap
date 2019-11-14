*&---------------------------------------------------------------------*
*& Report  SAPBC400UDT_SELECTION_SCREEN                                *
*&---------------------------------------------------------------------*

REPORT  sapbc400udt_selection_screen  .

DATA wa_spfli TYPE spfli.

SELECT-OPTIONS so_carr FOR wa_spfli-carrid.
