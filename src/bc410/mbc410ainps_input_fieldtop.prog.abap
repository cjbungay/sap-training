*&---------------------------------------------------------------------*
*& Include MBC410ADIAS_DYNPROTOP                                       *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapmbc410adias_dynpro.
* screen structure
TABLES: sdyn_conn.

DATA:
* workarea for database read
  wa_sflight TYPE sflight,
* function code at PAI
  ok_code    LIKE sy-ucomm.
