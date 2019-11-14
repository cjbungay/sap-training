*----------------------------------------------------------------------*
***INCLUDE  SAPBC406ILBS_SIMPLE_LIST.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  READ_FLIGHTS
*&---------------------------------------------------------------------*
FORM read_flights.

  SELECT * INTO TABLE it_flight FROM dv_flights
     WHERE carrid = pa_car
       AND connid IN so_con.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_FLIGHTS
*&---------------------------------------------------------------------*
FORM display_flights.

  LOOP AT it_flight INTO wa_flight.

    WRITE: / wa_flight-carrid,
             wa_flight-connid,
             wa_flight-fldate,
             wa_flight-price CURRENCY wa_flight-currency,
             wa_flight-currency,
             wa_flight-seatsmax,
             wa_flight-seatsocc.

  ENDLOOP.

ENDFORM.                               " DISPLAY_FLIGHTS
