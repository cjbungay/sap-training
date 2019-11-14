*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_SUBQUERY_MULTI
*&
*&---------------------------------------------------------------------*
*& This report shows bookings of the selected flights.
*& Only those bookings will be shown where the customer comes from a
*& nation from which altogether only a specified number of customers
*& participate in that flight.
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdad_subquery_multi.
DATA: BEGIN OF wa_sbook,
        carrid TYPE sbook-carrid,
        connid TYPE sbook-connid,
        fldate TYPE sbook-fldate,
        bookid TYPE sbook-bookid,
        country TYPE scustom-country,
        customid TYPE sbook-customid,
        name TYPE scustom-name,
      END OF wa_sbook.
DATA: it_sbook LIKE TABLE OF wa_sbook.
DATA: alv TYPE REF TO cl_salv_table.
DATA: nob TYPE i. " for select-option
SELECT-OPTIONS:
  so_car FOR wa_sbook-carrid MEMORY ID car,
  so_con FOR wa_sbook-connid MEMORY ID con,
  so_day FOR wa_sbook-fldate MEMORY ID day.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-bl1.
* number of bookings per country
SELECT-OPTIONS: so_nob FOR nob DEFAULT 10 OPTION le.
SELECTION-SCREEN END OF BLOCK bl1.

START-OF-SELECTION.

  SELECT
    carrid connid fldate bookid customid name country
    INTO CORRESPONDING FIELDS OF TABLE it_sbook
    FROM sbook AS b_out INNER JOIN scustom AS c_out
      ON b_out~customid = c_out~id
    WHERE b_out~carrid IN so_car
      AND b_out~connid IN so_con
      AND b_out~fldate IN so_day
      AND c_out~country IN

* check if customer comes from one of those selected countries
      ( SELECT
          DISTINCT c_mid~country
          FROM sbook AS b_mid INNER JOIN scustom AS c_mid
            ON b_mid~customid = c_mid~id
          WHERE b_mid~carrid = b_out~carrid
            AND b_mid~connid = b_out~connid
            AND b_mid~fldate = b_out~fldate
            AND EXISTS

* check if a certain country has a certain number of bookings
            ( SELECT COUNT( * )
                FROM sbook AS b_in INNER JOIN scustom AS c_in
                  ON b_in~customid = c_in~id
                WHERE b_in~carrid = b_mid~carrid
                  AND b_in~connid = b_mid~connid
                  AND b_in~fldate = b_mid~fldate
                  AND c_in~country = c_mid~country
                HAVING COUNT( * ) IN so_nob ) )

    ORDER BY carrid connid fldate country customid.

* create ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_sbook
         ).

* display it
  alv->display( ).
