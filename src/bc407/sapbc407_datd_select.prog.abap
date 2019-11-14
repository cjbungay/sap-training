*&---------------------------------------------------------------------*
*& Report  SAPBC407_DATD_SELECT                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_datd_select.


* Data objects
DATA: wa_sflight TYPE sflight.


* Selection screen
SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_fld FOR wa_sflight-fldate.


* Data retrieval
SELECT * FROM sflight INTO wa_sflight
 WHERE carrid IN so_car
 AND   fldate IN so_fld.

  WRITE: /  wa_sflight-carrid,
            wa_sflight-connid,
            wa_sflight-fldate,
            wa_sflight-seatsmax,
            wa_sflight-seatsocc,
            wa_sflight-planetype.

ENDSELECT.
