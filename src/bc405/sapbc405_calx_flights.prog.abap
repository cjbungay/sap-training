*&---------------------------------------------------------------------*
*& Report  SAPBC405_CALX_FLIGHTS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc405_calx_flights.
DATA: it_spfli TYPE TABLE OF spfli,
      wa_spfli TYPE spfli,
      it_sflight TYPE TABLE OF sflight.
DATA: r_alv TYPE REF TO cl_salv_table.


START-OF-SELECTION.
  IMPORT mem_it_spfli TO it_spfli
    FROM MEMORY ID 'BC405'.
  CHECK sy-subrc EQ 0.

  LOOP AT it_spfli INTO wa_spfli.
    SELECT        *
      APPENDING TABLE it_sflight
      FROM  sflight
      WHERE  carrid  = wa_spfli-carrid
      AND    connid  = wa_spfli-connid.
  ENDLOOP.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = r_alv
    CHANGING
      t_table        = it_sflight
         ).

  r_alv->display( ).
