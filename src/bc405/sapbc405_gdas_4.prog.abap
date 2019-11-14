*&-----------------------------------------------
*&---------------------------------------------------------------------*
*& This report shows flights, but only of those connections that meet
*& certain aggregated conditions (like at last a certain total number of
*& occupied seats).
*& In the result one doesn't see the actual number of that condition.
*& The mere fact that one can see a flight says that it belongs to a
*& connection that meets the conditions.
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdas_4.

DATA: BEGIN OF wa_flight,
        carrid TYPE sflight-carrid,
        connid TYPE sflight-connid,
        fldate TYPE sflight-fldate,
        seatsmax TYPE sflight-seatsmax,
        seatsocc TYPE sflight-seatsocc,
      END OF wa_flight,
      it_flight LIKE TABLE OF wa_flight.

DATA: alv TYPE REF TO cl_salv_table.

SELECT-OPTIONS:
  so_max FOR wa_flight-seatsmax,
  so_occ FOR wa_flight-seatsocc.

START-OF-SELECTION.
  SELECT *
    FROM sflight AS f_out
    INTO CORRESPONDING FIELDS OF TABLE it_flight
    WHERE EXISTS

* check if flight belongs to one of those
*   required connections
    ( SELECT
          carrid " only one column allowed
                 " - must match GROUP BY column
        FROM sflight AS f_in
* compare with current flight from outer query
        WHERE carrid = f_out~carrid
          AND connid = f_out~connid
        GROUP BY
          carrid " any column from comparison
                 "   with outer query possible
* compare against aggregation conditions
        HAVING SUM( seatsmax ) IN so_max
           AND SUM( seatsocc ) IN so_occ ).

  CHECK sy-subrc EQ 0.

* ALV Handling
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_flight
         ).

  alv->display( ).
