*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_SUBQUERY_SINGLE
*&
*&---------------------------------------------------------------------*
*& This report shows bookings of the selected flights.
*& Only those bookings will be shown where the luggage weight is higher
*& than the average luggage weight of a booking of that same flight.
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdad_subquery.
DATA: BEGIN OF wa_sbook,
        carrid TYPE sbook-carrid,
        connid TYPE sbook-connid,
        fldate TYPE sbook-fldate,
        bookid TYPE sbook-bookid,
        customid TYPE scustom-id,
        class TYPE sbook-class,
        luggweight TYPE sbook-luggweight,
        wunit TYPE sbook-wunit,
      END OF wa_sbook,
      it_sbook LIKE TABLE OF wa_sbook.
DATA: alv TYPE REF TO cl_salv_table.
SELECT-OPTIONS:
  so_car FOR wa_sbook-carrid MEMORY ID car,
  so_con FOR wa_sbook-connid MEMORY ID con,
  so_day FOR wa_sbook-fldate MEMORY ID day.

START-OF-SELECTION.

  SELECT
    carrid connid fldate bookid
    customid class luggweight wunit
    INTO CORRESPONDING FIELDS OF TABLE it_sbook
    FROM sbook AS b_out
    WHERE carrid IN so_car
      AND connid IN so_con
      AND fldate IN so_day
      AND luggweight >

* retrieve the average luggage weight of a booking of that flight
      ( SELECT AVG( luggweight )
        FROM sbook AS b_in
        WHERE  b_in~carrid = b_out~carrid
          AND  b_in~connid = b_out~connid
          AND  b_in~fldate = b_out~fldate )
    ORDER BY carrid connid fldate luggweight DESCENDING.


* create ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_sbook
         ).

* display it
  alv->display( ).
