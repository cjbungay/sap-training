***********************************************************************
* Solution of exercise: "ABAP statements helpful for                  *
* creating InfoSets"                                                  *
*                                                                     *
* Lösung zum Kapitel "ABAP-Anweisungen bei der                        *
* InfoSet-Erstellung"                                                 *
***********************************************************************

REPORT  SAPBC407_DATS_1.


* Data declarations
* Datendeklarationen
DATA:
  wa_sflight TYPE sflight.


* Selection-screen
* Selektionsbild
SELECT-OPTIONS:
  so_car FOR wa_sflight-carrid OBLIGATORY.


* Events
* Ereignisse
AT SELECTION-SCREEN.
  IF 'LH' IN so_car.
    MESSAGE w012(bc407) WITH 'LH'.
  ENDIF.

START-OF-SELECTION.
* Data retrieval
* Datenselektion
  SELECT *
    FROM sflight
    INTO wa_sflight
    WHERE carrid IN so_car.
    WRITE: / wa_sflight-carrid,
             wa_sflight-connid,
             wa_sflight-fldate,
             wa_sflight-planetype,
             wa_sflight-seatsmax,
             wa_sflight-seatsocc.
  ENDSELECT.
