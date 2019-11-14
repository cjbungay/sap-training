*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_GROUP_BY_SIMPLE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdad_group_by_simple.
DATA: BEGIN OF wa_sflight,
        carrid TYPE sflight-carrid,
        connid TYPE sflight-connid,
        fldate TYPE sflight-fldate,
        luggweight TYPE sbook-luggweight,
        wunit TYPE sbook-wunit,
        n_o_bookings TYPE i,
      END OF wa_sflight,
      it_sflight LIKE TABLE OF wa_sflight.
DATA: alv TYPE REF TO cl_salv_table,
      r_columns TYPE REF TO cl_salv_columns_table,
      r_column TYPE REF TO cl_salv_column_table.

SELECT-OPTIONS:
  so_car FOR wa_sflight-carrid MEMORY ID car,
  so_con FOR wa_sflight-connid MEMORY ID con,
  so_day FOR wa_sflight-fldate MEMORY ID day.

START-OF-SELECTION.

  SELECT
      carrid connid fldate
      SUM( luggweight ) AS sum_luggweight
      wunit
      COUNT( * )
    INTO TABLE it_sflight
    FROM sbook
    WHERE carrid IN so_car
      AND connid IN so_con
      AND fldate IN so_day
    GROUP BY carrid connid fldate wunit
    ORDER BY
      wunit
      sum_luggweight DESCENDING.

* ALV handling
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_sflight
         ).

  r_columns = alv->get_columns( ).
  r_columns->set_optimize( ).

* Column DISTANCE
  r_column ?= r_columns->get_column( columnname = 'LUGGWEIGHT' ).
  r_column->set_quantity_column( value = 'WUNIT' ).

* Column N_O_BOOKINGS
  r_column ?= r_columns->get_column( columnname = 'N_O_BOOKINGS' ).
  r_column->set_short_text( value = 'Number Bks'(nob) ).

  alv->display( ).
