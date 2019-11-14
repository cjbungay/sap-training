*&---------------------------------------------------------------------*
*& Report  SAPBC400ITD_ITAB_LOOP_KEY                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Processing internal table with LOOP using key restriction          *
*&---------------------------------------------------------------------*

REPORT sapbc400tsd_itab_loop_key.

PARAMETERS: pa_car TYPE s_carr_id.

DATA: it_flightinfo TYPE sbc400_t_sbc400focc,
      wa_flightinfo LIKE LINE OF it_flightinfo.


SELECT carrid connid fldate seatsmax seatsocc
       FROM sflight
       INTO CORRESPONDING FIELDS OF wa_flightinfo.
*      WHERE carrid = ...

  wa_flightinfo-percentage = wa_flightinfo-seatsocc * 100 /
                               wa_flightinfo-seatsmax.
* Filling internal table record by record
  APPEND wa_flightinfo TO it_flightinfo.

ENDSELECT.

CLEAR wa_flightinfo.
FORMAT COLOR COL_NORMAL.

* Processing internal table with LOOP using key restriction
LOOP AT it_flightinfo INTO wa_flightinfo WHERE carrid = pa_car.
  WRITE: / sy-tabix,
           wa_flightinfo-carrid,
           wa_flightinfo-connid,
           wa_flightinfo-fldate,
           wa_flightinfo-seatsmax,
           wa_flightinfo-seatsocc,
        60 wa_flightinfo-percentage.
ENDLOOP.

IF sy-subrc NE 0.
  WRITE: / text-001.
ENDIF.

ULINE. SKIP.
FORMAT COLOR OFF.
WRITE text-002.

LOOP AT it_flightinfo INTO wa_flightinfo.
  WRITE: / sy-tabix,
           wa_flightinfo-carrid,
           wa_flightinfo-connid,
           wa_flightinfo-fldate,
           wa_flightinfo-seatsmax,
           wa_flightinfo-seatsocc,
        60 wa_flightinfo-percentage.
ENDLOOP.
