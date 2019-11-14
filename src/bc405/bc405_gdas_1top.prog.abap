*&---------------------------------------------------------------------*
*& Include BC405_GDAS_1TOP
*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT   sapbc405_gdas_1 LINE-SIZE 100 NO STANDARD PAGE HEADING.

* Include for using icons
INCLUDE <icon>.

* Constants for writing position
CONSTANTS:  pos_c1 TYPE i VALUE  6,
            line_size TYPE i VALUE 100.

* Constant for CASE statement
CONSTANTS mark VALUE 'X'.

* Internal table like DDIC view DV_FLIGHTS
DATA: it_flights LIKE TABLE OF dv_flights,
      wa_flights LIKE dv_flights.

* Selections for connections
SELECTION-SCREEN BEGIN OF BLOCK conn WITH FRAME TITLE text-tl1.
SELECT-OPTIONS: so_car FOR wa_flights-carrid,
                so_con FOR wa_flights-connid.
SELECTION-SCREEN END OF BLOCK conn.

* Selections for flights
SELECTION-SCREEN BEGIN OF BLOCK flight WITH FRAME TITLE text-tl2.
SELECT-OPTIONS so_fdt FOR wa_flights-fldate NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK flight.

* Output parameter
SELECTION-SCREEN BEGIN OF BLOCK param WITH FRAME TITLE text-tl3.
SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
PARAMETERS: all RADIOBUTTON GROUP rbg1,
            national RADIOBUTTON GROUP rbg1,
            internat RADIOBUTTON GROUP rbg1 DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK radio.
PARAMETERS country LIKE wa_flights-countryfr.
SELECTION-SCREEN END OF BLOCK param.
