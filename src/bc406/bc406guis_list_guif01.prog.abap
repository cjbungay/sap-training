*----------------------------------------------------------------------*
***INCLUDE  SAPBC406GUIS_LIST_GUIF01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  READ_FLIGHTS
*&---------------------------------------------------------------------*
FORM read_flights.

* Checking the output parameters
  CASE selected.
    WHEN pa_all.
* Radiobutton PA_ALL is marked
      SELECT * FROM dv_flights INTO TABLE it_flight
        WHERE carrid = pa_car
          AND connid IN so_con
          AND fldate IN so_fdt.

    WHEN pa_nat.
* Radiobutton PA_NAT is marked
      SELECT * FROM dv_flights INTO TABLE it_flight
        WHERE carrid = pa_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto = dv_flights~countryfr
          AND countryto = country.

    WHEN pa_inter.
* Radiobutton PA_INTER is marked
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

    HIDE:    wa_flight-carrid,
             wa_flight-connid,
             wa_flight-fldate.

  ENDLOOP.
ENDFORM.                               " DISPLAY_FLIGHTS
*&---------------------------------------------------------------------*
*&      Form  READ_BOOKINGS
*&---------------------------------------------------------------------*
*       selects booking data of the given flight
*----------------------------------------------------------------------*
*      -->p_carrid flight carrier
*      -->p_connid connection id
*      -->p_fldate flight date
*      -->p_cancelled cancelled = 'X' / not cancelled = ' '
*      <--p_it_sbook table of the corresponding bookings
*----------------------------------------------------------------------*
FORM read_bookings USING    p_carrid    TYPE sbook-carrid
                            p_connid    TYPE sbook-connid
                            p_fldate    TYPE  sbook-fldate
                            p_cancelled TYPE sbook-cancelled
                   CHANGING p_it_sbook LIKE it_sbook.

  SELECT * INTO TABLE p_it_sbook FROM sbook
    WHERE carrid = p_carrid
      AND connid = p_connid
      AND fldate = p_fldate
      AND cancelled = p_cancelled.

ENDFORM.                               " READ_BOOKINGS
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_BOOKINGS
*&---------------------------------------------------------------------*
*       displays all bookings from table it_sbook
*       new page for every new flight
*----------------------------------------------------------------------*
FORM display_bookings.

  LOOP AT it_sbook INTO wa_sbook.

    WRITE: / wa_sbook-bookid,
             wa_sbook-customid,
             wa_sbook-custtype,
             wa_sbook-luggweight UNIT wa_sbook-wunit,
             wa_sbook-wunit,
             wa_sbook-class,
             wa_sbook-order_date,
             wa_sbook-cancelled.
  ENDLOOP.

ENDFORM.                               " DISPLAY_BOOKINGS
