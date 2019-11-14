*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT sapbc405_gdas_2.
DATA: BEGIN OF wa_sflight,
        carrid      TYPE sflight-carrid,
        connid      TYPE sflight-connid,
        seatsmax    TYPE sflight-seatsmax,
        seatsocc    TYPE sflight-seatsocc,
        n_o_flights TYPE i,
      END OF wa_sflight,
      it_sflight LIKE TABLE OF wa_sflight.
DATA: alv TYPE REF TO cl_salv_table.
SELECT-OPTIONS: so_car FOR wa_sflight-carrid.

START-OF-SELECTION.

  SELECT
      carrid connid
      SUM( seatsmax )
      SUM( seatsocc )
      COUNT( * )
    INTO TABLE it_sflight
    FROM sflight
    WHERE carrid IN so_car
    GROUP BY carrid connid.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_sflight
         ).

  alv->display( ).
