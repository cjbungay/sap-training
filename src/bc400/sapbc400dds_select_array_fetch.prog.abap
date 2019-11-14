*&---------------------------------------------------------------------*
*& Report         SAPBC400DDS_SELECT_ARRAY_FETCH                       *
*&---------------------------------------------------------------------*

REPORT  sapbc400dds_select_array_fetch.

DATA: it_flight TYPE sbc400_t_sbc400focc,
      wa_flight LIKE LINE OF it_flight.

PARAMETERS pa_car TYPE s_carr_id.


*-----------------------------------------------------------------------
*  - Use Array Fetch to fill internal table                            *
*  - Loop at internal table to set the percentage value of each row    *
*  - Sort and list internal table                                      *
*-----------------------------------------------------------------------

SELECT carrid connid fldate seatsmax seatsocc
       FROM sflight
       INTO CORRESPONDING FIELDS OF TABLE it_flight
       WHERE carrid = pa_car.

IF sy-subrc = 0.

  LOOP AT it_flight INTO wa_flight.
   wa_flight-percentage = 100 * wa_flight-seatsocc / wa_flight-seatsmax.
   MODIFY it_flight FROM wa_flight
     INDEX sy-tabix  TRANSPORTING percentage.
  ENDLOOP.

  SORT it_flight BY percentage.

  LOOP AT it_flight INTO wa_flight.
    WRITE: / wa_flight-carrid,
             wa_flight-connid,
             wa_flight-fldate,
             wa_flight-seatsocc,
             wa_flight-seatsmax,
             wa_flight-percentage, '%'.
  ENDLOOP.

ELSE.

  WRITE: 'No ', pa_car, 'flights found !'.

ENDIF.
