*&---------------------------------------------------------------------*
*& Report  SAPBC407_DATD_ITAB                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_datd_itab            .

* Defintion of an internal table
DATA: it_sflight TYPE TABLE OF sflight,
      wa_sflight LIKE LINE OF it_sflight.


* Filling internal table
SELECT * FROM sflight INTO TABLE it_sflight.


* Read the first line
READ TABLE it_sflight INTO wa_sflight INDEX 1.

WRITE: / wa_sflight-carrid,
         wa_sflight-connid,
         wa_sflight-fldate,
         wa_sflight-seatsmax,
         wa_sflight-seatsocc.
