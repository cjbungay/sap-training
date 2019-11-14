*----------------------------------------------------------------------*
*   INCLUDE      SAPBC406SSCS_SEL_SCREENTOP                            *
*----------------------------------------------------------------------*
PROGRAM sapbc406sscs_sel_screen MESSAGE-ID bc406.

* workarea and internal table for flights
* Arbeitsbereich und interne Tabelle für Flüge

DATA: wa_flight TYPE dv_flights,
      it_flight LIKE TABLE OF wa_flight.

* selection screen for choosing connections
* Selektionsbild zu Verbindungsauswahl

* Include for using icons
INCLUDE <icon>.

* Constant for CASE statement
CONSTANTS selected VALUE 'X'.

* Selections for connections
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
PARAMETERS pa_car LIKE wa_flight-carrid OBLIGATORY.
SELECT-OPTIONS: so_con FOR wa_flight-connid.
SELECTION-SCREEN END OF SCREEN 1100.

* Selections for flights
SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
SELECT-OPTIONS so_fdt FOR wa_flight-fldate NO-EXTENSION.
SELECTION-SCREEN END OF SCREEN 1200.

* Output parameter
SELECTION-SCREEN BEGIN OF SCREEN 1300 AS SUBSCREEN.
PARAMETERS: pa_all RADIOBUTTON GROUP rbg1,
            pa_nat RADIOBUTTON GROUP rbg1,
            pa_inter RADIOBUTTON GROUP rbg1 DEFAULT 'X'.
SELECTION-SCREEN END OF SCREEN 1300.

* Output parameter
SELECTION-SCREEN BEGIN OF SCREEN 1400.
PARAMETERS country LIKE wa_flight-countryfr OBLIGATORY.
SELECTION-SCREEN END OF SCREEN 1400.

SELECTION-SCREEN BEGIN OF TABBED BLOCK airlines FOR 5 LINES.
SELECTION-SCREEN TAB (20) tab1 USER-COMMAND conn DEFAULT SCREEN 1100.
SELECTION-SCREEN TAB (20) tab2 USER-COMMAND date DEFAULT SCREEN 1200.
SELECTION-SCREEN TAB (20) tab3 USER-COMMAND type DEFAULT SCREEN 1300.
SELECTION-SCREEN END OF BLOCK airlines.
