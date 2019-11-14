*&---------------------------------------------------------------------*
*& Report  SAPBC400PBS_SUBROUTINE                                      *
*&---------------------------------------------------------------------*

REPORT  sapbc400pbs_subroutine.

CONSTANTS actvt_display TYPE activ_auth VALUE '03'.

DATA: it_flight TYPE sbc400_t_sbc400focc,
      wa_flight LIKE LINE OF it_flight.

PARAMETERS pa_car TYPE s_carr_id.

* Authority Check :
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
      PERFORM write_list USING it_flight.
    ELSE.
      WRITE: 'No ', pa_car, 'flights found !'.
    ENDIF.

  WHEN OTHERS.   " User is not authorized
    WRITE: / 'Authority-Check Error'(001).

ENDCASE.


*&---------------------------------------------------------------------*
*&      Form  WRITE_LIST
*&---------------------------------------------------------------------*
*              --> P_IT_FLIGHT
*----------------------------------------------------------------------*
FORM write_list USING p_it_flight TYPE sbc400_t_sbc400focc.

  DATA wa LIKE LINE OF p_it_flight.

  LOOP AT p_it_flight INTO wa.
    WRITE: / wa-carrid,
             wa-connid,
             wa-fldate,
             wa-seatsocc,
             wa-seatsmax,
             wa-percentage, '%'.
  ENDLOOP.

ENDFORM.                               " WRITE_LIST
