*&---------------------------------------------------------------------*
*&  Include           SAPBC405_INTSE01
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  SELECT
      * FROM  dv_flights
      INTO wa_flight.

    WRITE: / wa_flight-carrid,
             wa_flight-connid,
             wa_flight-fldate,
             wa_flight-countryfr,
             wa_flight-cityfrom,
             wa_flight-airpfrom,
             wa_flight-countryto,
             wa_flight-cityto,
             wa_flight-airpto,
             wa_flight-seatsmax,
             wa_flight-seatsocc.

  ENDSELECT.
