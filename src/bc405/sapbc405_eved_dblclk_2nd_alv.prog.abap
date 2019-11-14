*&---------------------------------------------------------------------*
*& Report  SAPBC405_EVED_DBLCLK_2ND_ALV
*&---------------------------------------------------------------------*
REPORT  SAPBC405_EVED_DBLCLK_2ND_ALV .
* work area for internal table
DATA: BEGIN OF wa_join,
        carrid TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        connid TYPE spfli-connid,
        cityfrom TYPE spfli-cityfrom,
        cityto TYPE spfli-cityto,
      END OF wa_join,
* internal table
      it_join LIKE TABLE OF wa_join.

DATA: it_sflight TYPE TABLE OF sflight.

DATA: r_alv TYPE REF TO cl_salv_table,
      r_events TYPE REF TO cl_salv_events_table,
      r_2nd_alv TYPE REF TO cl_salv_table.

INCLUDE bc405_eved_dblclk_2nd_alvk01.

START-OF-SELECTION.
* retrieve data
  SELECT        *
    INTO CORRESPONDING FIELDS OF TABLE it_join
    FROM  scarr INNER JOIN spfli
    ON scarr~carrid = spfli~carrid.
* create ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = r_alv
    CHANGING
      t_table        = it_join
         ).

* get the EVENTS object
  r_events = r_alv->get_event( ).
  SET HANDLER:
    lcl_handler=>on_double_click FOR r_events.
* display it!
  r_alv->display( ).
