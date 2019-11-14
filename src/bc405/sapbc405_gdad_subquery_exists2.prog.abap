*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAS_4A
*&
*&---------------------------------------------------------------------*
*& This report shows clients of a flight and their total number of
*& bookings throughout table SBOOK.
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdad_subquery.
DATA: BEGIN OF wa_custom,
        id TYPE scustom-id,
        form TYPE scustom-form,
        name TYPE scustom-name,
        n_o_bookings TYPE i,
      END OF wa_custom,
      it_custom LIKE TABLE OF wa_custom.

DATA: wa_sbook TYPE sbook.
DATA: alv TYPE REF TO cl_salv_table.
DATA: nob TYPE i. " only to create select-option
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-bl1.
PARAMETERS:
pa_car LIKE wa_sbook-carrid MEMORY ID car,
pa_con LIKE wa_sbook-connid MEMORY ID con,
pa_day LIKE wa_sbook-fldate MEMORY ID day.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-bl2.
* Required total number of bookings
SELECT-OPTIONS: so_nob FOR nob DEFAULT 20 OPTION gt.
SELECTION-SCREEN END OF BLOCK bl2.

START-OF-SELECTION.

  SELECT
    id form name
    COUNT( * ) AS n_o_bookings
    INTO CORRESPONDING FIELDS OF TABLE it_custom
    FROM sbook AS b_out INNER JOIN scustom
    ON customid = scustom~id
    WHERE EXISTS
    ( SELECT * FROM sbook AS b_in
      WHERE b_in~carrid = pa_car
        AND b_in~connid = pa_con
        AND b_in~fldate = pa_day
        AND b_in~customid = b_out~customid )
    GROUP BY id form name
    HAVING COUNT( * ) IN so_nob
    ORDER BY n_o_bookings DESCENDING.

* create ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = alv
    CHANGING
      t_table        = it_custom
         ).

* display it
  alv->display( ).
