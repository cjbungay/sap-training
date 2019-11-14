*&---------------------------------------------------------------------*
*& Include MBC410ADIAS_DYNPROTOP                                       *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapmbc410adias_dynpro.
* screen structure
TABLES: sdyn_conn,
        saplane.
TABLES: sdyn_book.

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
DATA:
* internal table for bookings table control
  it_sdyn_book TYPE TABLE OF sdyn_book,
  wa_sdyn_book LIKE LINE OF it_sdyn_book.
DATA  not_cancelled VALUE space.
CONTROLS:
  my_tabstrip      TYPE TABSTRIP,
  my_table_control TYPE TABLEVIEW USING SCREEN '0130'.
