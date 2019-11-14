*----------------------------------------------------------------------*
***INCLUDE  SAPBC406SSCS_SEL_SCREENF01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  READ_FLIGHTS
*&---------------------------------------------------------------------*
FORM read_flights.

* Checking the output parameters
  CASE selected.
    WHEN pa_all.
* Radiobutton pa_all is marked
      SELECT * FROM dv_flights INTO TABLE it_flight
        WHERE carrid = pa_car
          AND connid IN so_con
          AND fldate IN so_fdt.

    WHEN pa_nat.
* Radiobutton pa_nat is marked
      SELECT * FROM dv_flights INTO TABLE it_flight
        WHERE carrid = pa_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto = dv_flights~countryfr
          AND countryto = country.

    WHEN pa_inter.
* Radiobutton pa_inter is marked
      SELECT * FROM dv_flights INTO TABLE it_flight
        WHERE carrid = pa_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto <> dv_flights~countryfr.

  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_FLIGHTS
*&---------------------------------------------------------------------*
FORM display_flights.

  LOOP AT it_flight INTO wa_flight.

* Mark international flights
    FORMAT COLOR COL_KEY INTENSIFIED ON.
    IF wa_flight-countryfr EQ wa_flight-countryto.
      WRITE: / icon_space AS ICON CENTERED.
    ELSE.
      WRITE: / icon_bw_gis AS ICON CENTERED.
    ENDIF.

    WRITE:   wa_flight-carrid,
             wa_flight-connid.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE:   wa_flight-fldate,
             wa_flight-price CURRENCY wa_flight-currency,
             wa_flight-currency,
             wa_flight-seatsmax,
             wa_flight-seatsocc.

  ENDLOOP.

ENDFORM.                               " DISPLAY_FLIGHTS
