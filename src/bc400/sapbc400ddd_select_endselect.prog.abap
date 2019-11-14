*&---------------------------------------------------------------------*
*& Report  SAPBC400DDD_SELECT_ENDSELECT                                *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  reading one database table via  SELECT ... ENDSELECT.              *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400ddd_select_endselect.

PARAMETERS pa_car TYPE s_carr_id.

DATA wa_sbc400focc TYPE sbc400focc.


SELECT carrid connid fldate seatsmax seatsocc
       FROM sflight
       INTO wa_sbc400focc
       WHERE carrid = pa_car.

  wa_sbc400focc-percentage = wa_sbc400focc-seatsocc * 100 /
                             wa_sbc400focc-seatsmax.

  WRITE: / wa_sbc400focc-carrid,
           wa_sbc400focc-connid,
           wa_sbc400focc-fldate,
           wa_sbc400focc-seatsmax,
           wa_sbc400focc-seatsocc,
           wa_sbc400focc-percentage, '%'.

ENDSELECT.
