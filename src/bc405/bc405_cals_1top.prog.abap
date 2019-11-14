*&-----------------------------------------------
*& Include BC405_CALS_1TOP
*&
*&-----------------------------------------------

REPORT  sapbc405_cals_1.
DATA: wa_spfli TYPE spfli,
      it_spfli TYPE TABLE OF spfli.

DATA: r_alv TYPE REF TO cl_salv_table,
      r_events TYPE REF TO cl_salv_events_table,
      r_selections TYPE REF TO cl_salv_selections.


SELECT-OPTIONS: so_car FOR wa_spfli-carrid,
                so_con FOR wa_spfli-connid.
