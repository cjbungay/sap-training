*&---------------------------------------------------------------------*
*& Include BC414S_CREATE_FLIGHTTOP                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  SAPBC414S_CREATE_FLIGHT MESSAGE-ID BC414.

* workarea for transporting field values from/to screen
TABLES: SDYN_CONN.
* workarea for transporting fields values to database table
DATA: WA_SFLIGHT TYPE SFLIGHT.

* transporting ok_code from screen to ABAP Program
DATA: OK_CODE TYPE SY-UCOMM, SAVE_OK LIKE OK_CODE.
* flag indicating, that field values on second screen were changed
DATA: MARK_CHANGED.
