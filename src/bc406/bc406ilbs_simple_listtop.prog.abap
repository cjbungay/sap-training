*----------------------------------------------------------------------*
*   INCLUDE      SAPBC406ILBS_SIMPLE_LIST                              *
*----------------------------------------------------------------------*
PROGRAM SAPBC406ILBS_SIMPLE_LIST MESSAGE-ID bc406.

* workarea and internal table for flights
* Arbeitsbereich und interne Tabelle für Flüge

DATA: wa_flight TYPE dv_flights,
      it_flight LIKE TABLE OF wa_flight.

* selection screen for choosing connections
* Selektionsbild zu Verbindungsauswahl

PARAMETERS pa_car LIKE wa_flight-carrid OBLIGATORY.
SELECT-OPTIONS so_con FOR wa_flight-connid.
