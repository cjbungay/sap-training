*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_SUBQUERY
*&
*&---------------------------------------------------------------------*
*& This report shows bookings of the selected flights.
*& Only those bookings will be shown where the customer has altogether
*& a specified number of bookings in table SBOOK.
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
DATA: nob TYPE i. " only to create select-option
SELECT-OPTIONS:
  so_car FOR wa_sbook-carrid MEMORY ID car,
  so_con FOR wa_sbook-connid MEMORY ID con,
  so_day FOR wa_sbook-fldate MEMORY ID day.
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-bl1.
* Required total number of bookings
SELECT-OPTIONS: so_nob FOR nob DEFAULT 20 OPTION gt.
SELECTION-SCREEN END OF BLOCK bl1.

START-OF-SELECTION.

  SELECT
    carrid connid fldate bookid
    customid class luggweight wunit
    INTO CORRESPONDING FIELDS OF TABLE it_sbook
    FROM sbook AS b_out
    WHERE carrid IN so_car
      AND connid IN so_con
      AND fldate IN so_day
      AND EXISTS
* Does the client have the required total number of bookings?
      ( SELECT COUNT( DISTINCT bookid ) AS n_o_bookings
        FROM sbook AS b_in
        WHERE  b_in~customid = b_out~customid
        HAVING COUNT( DISTINCT bookid ) IN so_nob )
    ORDER BY carrid connid fldate bookid.

* create ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_sbook
         ).

* display it
  alv->display( ).
