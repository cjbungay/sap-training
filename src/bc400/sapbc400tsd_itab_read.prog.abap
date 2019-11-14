*&---------------------------------------------------------------------*
*& Report  SAPBC400ITD_ITAB_READ                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&   Reading single entry from internal table using READ TABLE         *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc400tsd_itab_read.

PARAMETERS: pa_car TYPE sbc400focc-carrid,
            pa_con TYPE sbc400focc-connid,
            pa_tabix LIKE sy-tabix.

DATA it_flightinfo TYPE sbc400_t_spfli.
DATA wa_flightinfo LIKE LINE OF it_flightinfo.


* Filling internal table via array fetch
SELECT * FROM spfli INTO TABLE it_flightinfo.

FORMAT COLOR COL_NORMAL.

* READ TABLE using explicitly specified key
READ TABLE it_flightinfo INTO wa_flightinfo
                         WITH TABLE KEY mandt  = sy-mandt
                                        carrid = pa_car
                                        connid = pa_con.
IF sy-subrc = 0.
  WRITE text-k01 COLOR COL_KEY.
  WRITE: / sy-tabix COLOR 3,
           wa_flightinfo-carrid,
           wa_flightinfo-connid,
        30 wa_flightinfo-countryfr,
           wa_flightinfo-cityfrom,
           wa_flightinfo-airpfrom,
           wa_flightinfo-deptime,
           wa_flightinfo-countryto,
           wa_flightinfo-cityto,
           wa_flightinfo-airpto,
           wa_flightinfo-arrtime.
  SKIP. ULINE.
ELSE.
  WRITE / text-001.
ENDIF.

* READ TABLE using key in workarea
MOVE: pa_car TO wa_flightinfo-carrid,
      pa_con TO wa_flightinfo-connid.

READ TABLE it_flightinfo INTO wa_flightinfo
                         FROM wa_flightinfo.
IF sy-subrc = 0.
  WRITE text-k02 COLOR COL_KEY.
  WRITE: / sy-tabix COLOR 3,
           wa_flightinfo-carrid,
           wa_flightinfo-connid,
        30 wa_flightinfo-countryfr,
           wa_flightinfo-cityfrom,
           wa_flightinfo-airpfrom,
           wa_flightinfo-deptime,
           wa_flightinfo-countryto,
           wa_flightinfo-cityto,
           wa_flightinfo-airpto,
           wa_flightinfo-arrtime.
  SKIP. ULINE.
ELSE.
  WRITE / text-001.
ENDIF.

* READ TABLE using index
READ TABLE it_flightinfo INTO wa_flightinfo
                         INDEX pa_tabix.
IF sy-subrc = 0.
  WRITE text-i01 COLOR COL_KEY.
  WRITE: / sy-tabix COLOR 3,
           wa_flightinfo-carrid,
           wa_flightinfo-connid,
        30 wa_flightinfo-countryfr,
           wa_flightinfo-cityfrom,
           wa_flightinfo-airpfrom,
           wa_flightinfo-deptime,
           wa_flightinfo-countryto,
           wa_flightinfo-cityto,
           wa_flightinfo-airpto,
           wa_flightinfo-arrtime.
  SKIP. ULINE.
ELSE.
  WRITE / text-001.
ENDIF.
