*&---------------------------------------------------------------------*
*& Report  SAPBC405_CALD_BOOKINGS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc405_cald_bookings.
DATA: alv   TYPE REF TO cl_salv_table,
      cols  TYPE REF TO cl_salv_columns_table,
      col   TYPE REF TO cl_salv_column_table,
      sums  TYPE REF TO cl_salv_aggregations,
      sorts TYPE REF TO cl_salv_sorts.
DATA: BEGIN OF wa_sbook.
INCLUDE TYPE sbook.
DATA:   count TYPE i,
      END OF wa_sbook,
      it_sbook LIKE TABLE OF wa_sbook.

SELECT-OPTIONS: so_cid FOR wa_sbook-customid,
                so_car FOR wa_sbook-carrid.
PARAMETERS: pa_subt AS CHECKBOX. " subtotals per customer

START-OF-SELECTION.
  SELECT        * FROM  sbook
    INTO TABLE it_sbook
    WHERE  customid  IN so_cid
      AND  carrid    IN so_car.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_sbook
         ).

  cols = alv->get_columns( ).
* CUSTOMID pos #1
  cols->set_column_position(
      columnname = 'CUSTOMID'
      position   = 1
         ).
* count pos #2
  cols->set_column_position(
      columnname = 'COUNT'
      position   = 2
         ).
* declare count column
  cols->set_count_column( value = 'COUNT'  ).
* column MANDT
  col ?= cols->get_column( columnname = 'MANDT'  ).

  col->set_technical( ).
* column COUNT
  col ?= cols->get_column( columnname = 'COUNT'  ).

  col->set_short_text( value = 'Number'(nsh) ).
  col->set_medium_text( value = 'Number of Bookings'(nmd)  ).
  col->set_long_text( value = 'Number of Bookings'(nlg)  ).
* do sums
  sums = alv->get_aggregations( ).

  sums->add_aggregation(
    columnname  = 'LUGGWEIGHT'
       ).

*  sums->add_aggregation(
*    columnname  = 'FORCURAM'
*       ).
*
  sums->add_aggregation(
    columnname  = 'LOCCURAM'
       ).
* do sorts
  sorts = alv->get_sorts( ).
* sort by CUSTOMID with or without building subtotals
  sorts->add_sort(
      columnname = 'CUSTOMID'
*      subtotal   = if_salv_c_bool_sap=>true
      subtotal   = pa_subt
         ).

  sorts->add_sort(
      columnname = 'CARRID'
         ).

  sorts->add_sort(
      columnname = 'CONNID'
         ).

  sorts->add_sort(
      columnname = 'FLDATE'
         ).
* show subtotals compressed
  IF pa_subt EQ 'X'.
    sorts->set_compressed_subtotal(
        value  = 'CUSTOMID'
           ).
  ENDIF.

  alv->display( ).
