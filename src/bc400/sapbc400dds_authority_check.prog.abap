*&---------------------------------------------------------------------*
*& Report  SAPBC400DDS_AUTHORITY_CHECK                                 *
*&---------------------------------------------------------------------*

REPORT  sapbc400dds_authority_check.

CONSTANTS actvt_display TYPE activ_auth VALUE '03'.

DATA wa_flight TYPE sbc400focc.

PARAMETERS pa_car TYPE s_carr_id.


* Check if user is authorized to read data of the specified carrier

AUTHORITY-CHECK OBJECT 'S_CARRID'
   ID 'CARRID' FIELD pa_car
   ID 'ACTVT'  FIELD actvt_display.

CASE sy-subrc.

  WHEN 0.   " User is authorized

    SELECT carrid connid fldate seatsmax seatsocc
           FROM sflight
           INTO CORRESPONDING FIELDS OF wa_flight
           WHERE carrid = pa_car.

      wa_flight-percentage =
           100 * wa_flight-seatsocc / wa_flight-seatsmax.

      WRITE: / wa_flight-carrid COLOR COL_KEY,
               wa_flight-connid COLOR COL_KEY,
               wa_flight-fldate COLOR COL_KEY,
               wa_flight-seatsocc,
               wa_flight-seatsmax,
               wa_flight-percentage, '%'.

    ENDSELECT.

    IF sy-subrc NE 0.
      WRITE: 'No ', pa_car, 'flights found !'.
    ENDIF.

  WHEN OTHERS.   " User is not authorized

    WRITE: / 'Authority-Check Error'(001).

ENDCASE.
