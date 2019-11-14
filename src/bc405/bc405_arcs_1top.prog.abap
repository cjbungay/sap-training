*&---------------------------------------------------------------------*
*& Include xyz                                                         *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT xyz.
* Internal table
DATA: it_sflight TYPE TABLE OF sflight.
* Workarea for data fetch
DATA: wa_sflight LIKE LINE OF it_sflight.

* Reference for ALV instance
DATA: gr_alv TYPE REF TO cl_salv_table.
* Reference for error situations
DATA: gr_error TYPE REF TO cx_salv_error.

SELECT-OPTIONS:
  so_car FOR wa_sflight-carrid MEMORY ID car,
  so_con FOR wa_sflight-connid.
