*&---------------------------------------------------------------------*
*& Report  SAPBC407_AQAD_READ_SBOOK                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_aqad_read_sbook LINE-SIZE 100      .


* Data defintion
DATA: wa_sbook TYPE sbook.


* Selection screen
SELECT-OPTIONS: so_car FOR wa_sbook-carrid,
                so_con FOR wa_sbook-connid,
                so_fld FOR wa_sbook-fldate.


ULINE.

SELECT * FROM sbook INTO wa_sbook
  WHERE carrid IN so_car
   AND  connid IN so_con
   AND  fldate IN so_fld.

  FORMAT COLOR COL_KEY.
  WRITE:   sy-vline,
           wa_sbook-carrid,
           wa_sbook-connid,
           wa_sbook-fldate.
  FORMAT COLOR COL_NORMAL.
  WRITE:   wa_sbook-bookid,
           wa_sbook-bookid,
           wa_sbook-customid,
           wa_sbook-custtype,
           wa_sbook-smoker,
           AT 100 sy-vline.

ENDSELECT.
ULINE.
