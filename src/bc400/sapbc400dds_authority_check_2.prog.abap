*&---------------------------------------------------------------------*
*& Report  SAPBC400DDS_AUTHORITY_CHECK_2                               *
*&---------------------------------------------------------------------*

REPORT  sapbc400dds_authority_check_2.

CONSTANTS actvt_display TYPE activ_auth VALUE '03'.

DATA: it_flight TYPE sbc400_t_sbc400focc,
      wa_flight LIKE LINE OF it_flight.

PARAMETERS pa_car TYPE s_carr_id.


* Check if user is authorized to read data of the specified carrier ?

AUTHORITY-CHECK OBJECT 'S_CARRID'
  ID 'CARRID' FIELD pa_car
  ID 'ACTVT'  FIELD actvt_display.

CASE sy-subrc.

  WHEN 0.   " User is authorized

    SELECT carrid connid fldate seatsmax seatsocc FROM sflight
           INTO CORRESPONDING FIELDS OF wa_flight
           WHERE carrid = pa_car.

      wa_flight-percentage =
             100 * wa_flight-seatsocc / wa_flight-seatsmax.

      APPEND wa_flight TO it_flight.

    ENDSELECT.

    IF sy-subrc = 0.
      SORT it_flight BY percentage.
      LOOP AT it_flight INTO wa_flight.
        WRITE: / wa_flight-carrid COLOR COL_KEY,
                 wa_flight-connid COLOR COL_KEY,
                 wa_flight-fldate COLOR COL_KEY,
                 wa_flight-seatsocc,
                 wa_flight-seatsmax,
                 wa_flight-percentage, '%'.
      ENDLOOP.
    ELSE.
      WRITE: 'No ', pa_car, 'flights found !'.
    ENDIF.

  WHEN OTHERS.   " User is not authorized

    WRITE: / 'Authority-Check Error'(001).

ENDCASE.
