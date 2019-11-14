*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_GROUP_BY_SIMPLE
*&
*&---------------------------------------------------------------------*
*& This reports shows customers and their total number of bookings.
*& It is meant to in the whole table SBOOK how many bookings the
*& customers individually have (find the super customers).
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdas_4.

DATA: BEGIN OF wa_custom,
        id TYPE scustom-id,
        form TYPE scustom-form,
        name TYPE scustom-name,
        n_o_bookings TYPE i,
      END OF wa_custom,
      it_custom LIKE TABLE OF wa_custom.

DATA: nob TYPE i.

DATA: alv TYPE REF TO cl_salv_table.


SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-bl2.
* Required total number of bookings
SELECT-OPTIONS: so_nob FOR nob DEFAULT 20 OPTION gt.
SELECTION-SCREEN END OF BLOCK bl2.


SELECT
    id form name
    COUNT( * ) AS n_o_bookings
  FROM sbook
    INNER JOIN scustom
    ON customid = scustom~id
  INTO TABLE IT_CUSTOM
  GROUP BY id form name
  HAVING COUNT( * ) IN so_nob
  ORDER BY n_o_bookings DESCENDING.

cl_salv_table=>factory(
  IMPORTING
    r_salv_table   = alv
  CHANGING
    t_table        = it_custom
       ).

alv->display( ).
