*&---------------------------------------------------------------------*
*& Include MBC410ADIAS_DYNPROTOP                                       *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapmbc410adias_dynpro.
* screen structure
TABLES: sdyn_conn,
        saplane.

DATA:
* workarea for database read
  wa_sflight TYPE sflight,
* function code at PAI
  ok_code    LIKE sy-ucomm,
* radio buttons
  view       VALUE 'X',
  maintain_flights,
  maintain_bookings,
* subscreen number
  dynnr      TYPE sy-dynnr.

CONTROLS:
  my_tabstrip TYPE TABSTRIP.
