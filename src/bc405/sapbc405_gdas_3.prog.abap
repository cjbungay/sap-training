*&-----------------------------------------------
*&
*&-----------------------------------------------

REPORT SAPBC405_GDAS_3.
DATA: BEGIN OF wa_sflight,
        carrid       TYPE sflight-carrid,
        seatsmax     TYPE sflight-seatsmax,
        seatsocc     TYPE sflight-seatsocc,
        seatsmax_avg TYPE sflight-seatsmax,
        seatsocc_avg TYPE sflight-seatsocc,
        n_o_conn     TYPE i,
        n_o_flights  TYPE i,
      END OF wa_sflight,
      it_sflight LIKE TABLE OF wa_sflight.
DATA: alv       TYPE REF TO cl_salv_table,
      r_columns TYPE REF TO cl_salv_columns_table,
      r_column  TYPE REF TO cl_salv_column_table.
SELECT-OPTIONS:
  so_car FOR wa_sflight-carrid.
SELECTION-SCREEN
  BEGIN OF BLOCK bl1 WITH FRAME TITLE text-bl1.
SELECT-OPTIONS:
  so_avgmx FOR wa_sflight-seatsmax,
  so_avgoc FOR wa_sflight-seatsocc.
SELECTION-SCREEN END OF BLOCK bl1.

START-OF-SELECTION.

  SELECT
      carrid
      COUNT( DISTINCT connid ) AS n_o_conn
      SUM( seatsmax ) AS seatsmax
      SUM( seatsocc ) AS seatsocc
      AVG( seatsmax ) AS seatsmax_avg
      AVG( seatsocc ) AS seatsocc_avg
      COUNT( * ) AS n_o_flights
    INTO CORRESPONDING FIELDS OF TABLE it_sflight
    FROM sflight
    WHERE carrid IN so_car
    GROUP BY carrid
    HAVING AVG( seatsmax ) IN so_avgmx
       AND AVG( seatsocc ) IN so_avgoc
    ORDER BY
      seatsmax_avg DESCENDING
      seatsocc_avg DESCENDING.

* create ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_sflight
         ).

* defining headers for ALV columns
  r_columns = alv->get_columns( ).

* number of connections
  r_column ?= r_columns->get_column(
                columnname = 'N_O_CONN' ).
  r_column->set_short_text(
    value = 'Connect.'(con) ).

* number of flights
  r_column ?= r_columns->get_column(
                columnname = 'N_O_FLIGHTS' ).
  r_column->set_short_text(
    value = 'Flights'(flg) ).

* average of seatsmax
  r_column ?= r_columns->get_column(
                columnname = 'SEATSMAX_AVG' ).
  r_column->set_short_text(
    value = 'Avg.Cap.'(avm) ).

* average of seatsocc
  r_column ?= r_columns->get_column(
                columnname = 'SEATSOCC_AVG' ).
  r_column->set_short_text(
    value = 'Avg.occ.'(avo) ).

* display it
  alv->display( ).
