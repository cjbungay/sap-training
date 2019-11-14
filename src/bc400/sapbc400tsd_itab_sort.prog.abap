*&---------------------------------------------------------------------*
*& Report  SAPBC400ITD_ITAB_SORT                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   sort an internal table                                            *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc400tsd_itab_sort.

DATA it_flightinfo TYPE sbc400_t_spfli.
DATA wa_flightinfo LIKE LINE OF it_flightinfo.


* Filling internal table via array fetch
SELECT * FROM spfli INTO TABLE it_flightinfo.

* Sorting internal table
SORT it_flightinfo BY cityfrom ASCENDING
                      deptime  DESCENDING
                      carrid   ASCENDING AS TEXT.
* Output
LOOP AT it_flightinfo INTO wa_flightinfo.
  WRITE:  / wa_flightinfo-cityfrom,
            wa_flightinfo-deptime,
            wa_flightinfo-carrid,
            wa_flightinfo-connid,
            wa_flightinfo-cityto,
            wa_flightinfo-arrtime.
ENDLOOP.
