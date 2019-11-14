*&---------------------------------------------------------------------*
*& Report  SAPBC400ITD_ITAB_LOOP                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Processing internal table with LOOP ... ENDLOOP                   *
*&---------------------------------------------------------------------*

REPORT sapbc400tsd_itab_loop.

PARAMETERS pa_car TYPE s_carr_id.

DATA: it_flightinfo TYPE sbc400_t_sbc400focc,
      wa_flightinfo LIKE LINE OF it_flightinfo.



SELECT carrid connid fldate seatsmax seatsocc
       FROM sflight
       INTO CORRESPONDING FIELDS OF wa_flightinfo
       WHERE carrid = pa_car.

  wa_flightinfo-percentage = wa_flightinfo-seatsocc * 100 /
                               wa_flightinfo-seatsmax.
* Filling internal table record by record
  APPEND wa_flightinfo TO it_flightinfo.
* (for sorted or hashed table use INSERT statement)

ENDSELECT.

CLEAR wa_flightinfo.

FORMAT COLOR COL_NORMAL.

LOOP AT it_flightinfo INTO wa_flightinfo.
  WRITE: / sy-tabix COLOR 3,
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
