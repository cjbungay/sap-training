*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_GROUP_BY_DISTCOL
*&
*&---------------------------------------------------------------------*
*& This report shows the total luggage weight per airline, together
*& with the number of bookings, the number of flights, and the number
*& of connections.
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdad_group_by_distcol.
DATA: BEGIN OF wa_sflight,
        carrid TYPE sflight-carrid,
        n_o_conn TYPE i,
        n_o_flights TYPE i,
        n_o_bookings TYPE i,
        sum_luggweight TYPE p DECIMALS 2, " sbook-luggweight,
        wunit TYPE sbook-wunit,
      END OF wa_sflight,
      it_sflight LIKE TABLE OF wa_sflight.
DATA: alv TYPE REF TO cl_salv_table,
      r_columns TYPE REF TO cl_salv_columns_table,
      r_column TYPE REF TO cl_salv_column_table.

DATA: wa_ddic_reference TYPE salv_s_ddic_reference.

DATA: wa_so TYPE sflight.
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-bl1.
SELECT-OPTIONS:
  so_car FOR wa_so-carrid MEMORY ID car,
  so_con FOR wa_so-connid MEMORY ID con,
  so_day FOR wa_so-fldate MEMORY ID day.
SELECTION-SCREEN END OF BLOCK bl1.
SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-bl2.
SELECT-OPTIONS:
  so_nof FOR wa_sflight-n_o_flights DEFAULT 30 OPTION ge,
  so_nob FOR wa_sflight-n_o_bookings DEFAULT 10000 OPTION ge.
SELECTION-SCREEN END OF BLOCK bl2.

START-OF-SELECTION.

  SELECT
      carrid
      COUNT( DISTINCT connid ) AS n_o_conn
      COUNT( DISTINCT fldate ) AS n_o_flights
      COUNT( * ) AS n_o_bookings
      SUM( luggweight ) AS sum_luggweight
      wunit
    INTO CORRESPONDING FIELDS OF TABLE it_sflight
    FROM sbook
    WHERE carrid IN so_car
      AND connid IN so_con
      AND fldate IN so_day
    GROUP BY
      carrid
      wunit
    HAVING COUNT( * ) IN so_nob
       AND COUNT( DISTINCT fldate ) IN so_nof
    ORDER BY
      wunit
      sum_luggweight DESCENDING.

  CHECK sy-subrc EQ 0.

* ALV handling
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_sflight
         ).

  r_columns = alv->get_columns( ).
  r_columns->set_optimize( ).

* Column SUM_LUGGWEIGHT
  r_column ?= r_columns->get_column( columnname = 'SUM_LUGGWEIGHT' ).
  r_column->set_quantity_column( value = 'WUNIT' ).

  wa_ddic_reference-field = 'LUGGWEIGHT'.
  wa_ddic_reference-table = 'SBOOK'.
  r_column->set_ddic_reference( value = wa_ddic_reference  ).

* Column N_O_CONN
  r_column ?= r_columns->get_column( columnname = 'N_O_CONN' ).
  r_column->set_short_text( value = 'Num. Conn.'(noc) ).

* Column N_O_FLIGHTS
  r_column ?= r_columns->get_column( columnname = 'N_O_FLIGHTS' ).
  r_column->set_short_text( value = 'Num. Flg.'(nof) ).

* Column N_O_BOOKINGS
  r_column ?= r_columns->get_column( columnname = 'N_O_BOOKINGS' ).
  r_column->set_short_text( value = 'Number Bks'(nob) ).

  alv->display( ).
