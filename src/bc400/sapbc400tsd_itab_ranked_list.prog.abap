*&---------------------------------------------------------------------*
*& Report  SAPBC400ITS_ITAB_RANKED_LIST                                *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&   Ranked List                                                       *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc400tsd_itab_ranked_list.

PARAMETERS pa_carr TYPE s_carr_id DEFAULT 'LH'.

DATA it_flightinfo TYPE sbc400_t_sbc400focc.
DATA wa_flightinfo TYPE sbc400focc.


* Filling internal table
SELECT carrid connid fldate seatsmax seatsocc
       INTO CORRESPONDING FIELDS OF wa_flightinfo
       FROM sflight
       WHERE carrid = pa_carr.

  wa_flightinfo-percentage = 100 * wa_flightinfo-seatsocc
                               / wa_flightinfo-seatsmax.
  APPEND wa_flightinfo TO it_flightinfo.

ENDSELECT.

* Sorting internal table
SORT it_flightinfo BY percentage DESCENDING.

* Output
LOOP AT it_flightinfo INTO wa_flightinfo
                      FROM 1 TO 5.
  WRITE: / wa_flightinfo-carrid,
           wa_flightinfo-connid,
           wa_flightinfo-fldate,
           wa_flightinfo-seatsmax,
           wa_flightinfo-seatsocc,
        55 wa_flightinfo-percentage,
           '%'.
ENDLOOP.
