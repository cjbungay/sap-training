*&---------------------------------------------------------------------*
*& Report         SAPBC400DDS_SELECT_SFLIGHT_TAB                       *
*&---------------------------------------------------------------------*

REPORT  sapbc400dds_select_sflight_tab .

DATA: it_flight TYPE sbc400_t_sbc400focc,
      wa_flight LIKE LINE OF it_flight.

PARAMETERS pa_car TYPE s_carr_id.


* Select all flights belonging to carrier specified in PA_CAR :

SELECT carrid connid fldate seatsmax seatsocc FROM sflight
       INTO CORRESPONDING FIELDS OF wa_flight
       WHERE carrid = pa_car.

*  Calculate occupation of flight
   wa_flight-percentage = 100 * wa_flight-seatsocc / wa_flight-seatsmax.

*  Insert flight into internal table
   INSERT wa_flight INTO TABLE it_flight.

*  (If you are using standard tables, "APPEND wa_flight TO it_flight."
*   would be the same as the above INSERT-statement.)

ENDSELECT.


IF sy-subrc = 0.

* Sort internal table
  SORT it_flight BY percentage.

* Create list
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
