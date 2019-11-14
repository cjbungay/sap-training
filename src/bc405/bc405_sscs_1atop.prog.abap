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
SELECT-OPTIONS: so_car FOR wa_flight-carrid MEMORY ID car,
                so_con FOR wa_flight-connid.

* Selections for flights
SELECT-OPTIONS so_fdt FOR wa_flight-fldate NO-EXTENSION.

* Output parameter
SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
PARAMETERS: pa_all RADIOBUTTON GROUP rbg1,
            pa_nat RADIOBUTTON GROUP rbg1,
            pa_int RADIOBUTTON GROUP rbg1 DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK radio.
