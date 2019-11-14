*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&   Event INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
* Initialize select-options for CARRID" OPTIONAL
  MOVE: 'AA' TO so_car-low,
        'QF' TO so_car-high,
        'BT' TO so_car-option,
        'I' TO so_car-sign.
  APPEND so_car.
  CLEAR so_car.

  MOVE: 'AZ' TO so_car-low,
        'EQ' TO so_car-option,
        'E' TO so_car-sign.
  APPEND so_car.

* Set texts for tabstrip pushbuttons
  tab1 = 'Connections'(tl1).
  tab2 = 'Date'(tl2).
  tab3 = 'Type of flight'(tl3).

* Set second tab page as initial tab
  airlines-activetab = 'DATE'.
  airlines-dynnr = '1200'.


*&---------------------------------------------------------------------*
*&   Event START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
* Checking the output parameters
  CASE mark.
    WHEN all.
* Radiobutton ALL is marked
      SELECT * FROM dv_flights INTO wa_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt.

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

    WHEN national.
* Radiobutton NATIONAL is marked
      SELECT * FROM dv_flights INTO wa_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto = dv_flights~countryfr
          AND countryto = country.

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


    WHEN internat.
* Radiobutton INTERNATIONAL is marked
      SELECT * FROM dv_flights INTO wa_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryto <> dv_flights~countryfr.

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
  ENDCASE.

*&---------------------------------------------------------------------*
*&   Event AT SELECTION-SCREEN ON BLOCK PARAM
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON BLOCK param.

* check country for national flights is not empty
  CHECK national = 'X' AND country = space.
  MESSAGE e003(bc405).
