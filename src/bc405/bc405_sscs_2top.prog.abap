*&---------------------------------------------------------------------*
*& Include BC405_SSCS_1TOP                                             *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT bc405_sscs_1.

* Workarea for data fetch
DATA: wa_flight TYPE dv_flights.

* Constant for CASE statement
CONSTANTS mark VALUE 'X'.

* Selections for connections
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
SELECT-OPTIONS: so_car FOR wa_flight-carrid,
                so_con FOR wa_flight-connid.
SELECTION-SCREEN END OF SCREEN 1100.

* Selections for flights
SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
SELECT-OPTIONS so_fdt FOR wa_flight-fldate NO-EXTENSION.
SELECTION-SCREEN END OF SCREEN 1200.

* Output parameter
SELECTION-SCREEN BEGIN OF SCREEN 1300 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK param.
SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
PARAMETERS: all RADIOBUTTON GROUP rbg1,
            national RADIOBUTTON GROUP rbg1,
            internat RADIOBUTTON GROUP rbg1 DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK radio.
PARAMETERS: country LIKE wa_flight-countryfr.
SELECTION-SCREEN END OF BLOCK param.
SELECTION-SCREEN END OF SCREEN 1300.

SELECTION-SCREEN BEGIN OF TABBED BLOCK airlines FOR 8 LINES.
SELECTION-SCREEN TAB (20) tab1 USER-COMMAND conn
  DEFAULT SCREEN 1100.
SELECTION-SCREEN TAB (20) tab2 USER-COMMAND date
  DEFAULT SCREEN 1200.
SELECTION-SCREEN TAB (20) tab3 USER-COMMAND type
  DEFAULT SCREEN 1300.
SELECTION-SCREEN END OF BLOCK airlines .
