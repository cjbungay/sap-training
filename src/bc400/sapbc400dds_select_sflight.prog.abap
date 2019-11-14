*&---------------------------------------------------------------------*
*& Report  SAPBC400DDS_SELECT_SFLIGHT                                  *
*&---------------------------------------------------------------------*
*&   Solution for Exercise "Reading data from one database table"      *
*&---------------------------------------------------------------------*

REPORT  sapbc400dds_select_sflight.

PARAMETERS pa_car TYPE s_carr_id.

DATA  wa_flight TYPE sbc400focc.


* Select all flights belonging to carrier specified in PA_CAR :

SELECT carrid connid fldate seatsmax seatsocc
       FROM sflight
       INTO CORRESPONDING FIELDS OF wa_flight
       WHERE carrid = pa_car.

*  Calculate occupation of the current flight
   wa_flight-percentage = 100 * wa_flight-seatsocc / wa_flight-seatsmax.

*  Create list
   WRITE: / wa_flight-carrid,
            wa_flight-connid,
            wa_flight-fldate,
            wa_flight-seatsmax,
            wa_flight-seatsocc,
            wa_flight-percentage, '%'.

ENDSELECT.


IF sy-subrc NE 0.
  WRITE: 'No ', pa_car, 'flights found !'.
ENDIF.
