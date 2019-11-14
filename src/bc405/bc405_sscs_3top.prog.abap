*&------------------------------------------------
*& Include BC405_SSCS_3TOP
*&
*&------------------------------------------------

REPORT bc405_sscs_3.

* Workarea for data fetch
DATA: wa_flight TYPE dv_flights.

* Constant for CASE statement
CONSTANTS mark VALUE 'X'.

* Structure for pushbutton command
TABLES: sscrfields.
* flag to control hiding / showing
*   of detail select-options
DATA: switch TYPE n VALUE '1'.

* Selections for connections
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
SELECT-OPTIONS: so_car FOR wa_flight-carrid,
                so_con FOR wa_flight-connid.
SELECTION-SCREEN SKIP 2.
SELECTION-SCREEN PUSHBUTTON pos_low(20) push_det
  USER-COMMAND details.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK bl_det
  WITH FRAME TITLE text-tld.
SELECT-OPTIONS:
  so_start FOR wa_flight-cityfrom MODIF ID det,
  so_dest FOR wa_flight-cityto MODIF ID det.
SELECTION-SCREEN END OF BLOCK bl_det.
SELECTION-SCREEN END OF SCREEN 1100.

* Selections for flights
SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
SELECT-OPTIONS so_fdt FOR wa_flight-fldate NO-EXTENSION.
SELECTION-SCREEN END OF SCREEN 1200.

* Output parameter
SELECTION-SCREEN BEGIN OF SCREEN 1300 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK param WITH FRAME
  TITLE text-tl3.
SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
PARAMETERS:
  all RADIOBUTTON GROUP rbg1,
  national RADIOBUTTON GROUP rbg1,
  internat RADIOBUTTON GROUP rbg1 DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK radio.
PARAMETERS: country LIKE wa_flight-countryfr.
SELECTION-SCREEN END OF BLOCK param.
SELECTION-SCREEN END OF SCREEN 1300.

SELECTION-SCREEN BEGIN OF TABBED BLOCK airlines
  FOR 10 LINES.
SELECTION-SCREEN TAB (20) tab1 USER-COMMAND conn
  DEFAULT SCREEN 1100.
SELECTION-SCREEN TAB (20) tab2 USER-COMMAND date
  DEFAULT SCREEN 1200.
SELECTION-SCREEN TAB (20) tab3 USER-COMMAND type
  DEFAULT SCREEN 1300.
SELECTION-SCREEN END OF BLOCK airlines .
