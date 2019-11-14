REPORT  sapbc400pbd_form_using_struct.

PARAMETERS: pa_carr TYPE sbc400focc2-carrid,
            pa_conn TYPE sbc400focc2-connid,
            pa_date TYPE sbc400focc2-fldate.

DATA wa_flight TYPE sbc400focc2.



SELECT SINGLE carrid connid fldate seatsmax seatsocc
              FROM sflight
              INTO CORRESPONDING FIELDS OF wa_flight
              WHERE   carrid = pa_carr
               AND    connid = pa_conn
               AND    fldate = pa_date.

IF sy-subrc = 0.
  wa_flight-percentage = wa_flight-seatsocc * 100 / wa_flight-seatsmax.
  WRITE text-001 COLOR COL_HEADING.
  PERFORM display1 USING wa_flight.
  WRITE text-002 COLOR COL_HEADING.
  PERFORM display2 USING  wa_flight.
ENDIF.


*---------------------------------------------------------------------*
*       FORM DISPLAY1                                                 *
*---------------------------------------------------------------------*
FORM display1 USING value(is_flight) TYPE sbc400focc.
  WRITE : / is_flight-carrid,
            is_flight-connid,
            is_flight-fldate,
            is_flight-seatsmax,
            is_flight-seatsocc,
            is_flight-percentage.
  ULINE.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM DISPLAY2                                                 *
*---------------------------------------------------------------------*
FORM display2 USING value(is_flight).
* Type of the interface parameter not specified
*   -> Fields of the structure cannot be used
  WRITE : / is_flight.
ENDFORM.
