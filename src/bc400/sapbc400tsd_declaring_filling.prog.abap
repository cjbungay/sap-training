*&---------------------------------------------------------------------*
*& Report SAPBC400ITD_DECLARING_FILLING                                *
*&---------------------------------------------------------------------*
*&   Declaring and filling internal tables                             *
*&---------------------------------------------------------------------*

REPORT sapbc400itd_declaring_filling.

DATA:  it_flightinfo TYPE sbc400_t_sbc400focc,
       wa_flightinfo LIKE LINE OF it_flightinfo.

PARAMETERS  pa_car TYPE s_carr_id.



SELECT carrid connid fldate seatsmax seatsocc
         FROM sflight
         INTO corresponding fields of wa_flightinfo
         WHERE carrid = pa_car.

  wa_flightinfo-percentage = wa_flightinfo-seatsocc * 100 /
                             wa_flightinfo-seatsmax.

* Filling internal table record by record
  APPEND wa_flightinfo TO it_flightinfo.

ENDSELECT.


LOOP AT it_flightinfo INTO wa_flightinfo.
  WRITE: / wa_flightinfo-carrid,
           wa_flightinfo-connid,
           wa_flightinfo-fldate,
           wa_flightinfo-seatsmax,
           wa_flightinfo-seatsocc,
           wa_flightinfo-percentage.
ENDLOOP.
