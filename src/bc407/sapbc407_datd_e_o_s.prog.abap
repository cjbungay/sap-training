*&---------------------------------------------------------------------*
*& Report  SAPBC407_DATD_E_O_S                                         *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_datd_e_o_s              .


* Data Objects
DATA: wa_sflight TYPE sflight.

DATA: today TYPE sy-datum,
      next_week TYPE sy-datum.


* Selection Screen
SELECT-OPTIONS: so_car FOR wa_sflight-carrid.


START-OF-SELECTION.
  today = sy-datum.
  next_week = today + 7.

* Data retrieval
  SELECT * FROM sflight INTO wa_sflight
     WHERE carrid IN so_car
       AND fldate BETWEEN today and next_week.

    WRITE: / wa_sflight-carrid,
             wa_sflight-connid,
             wa_sflight-fldate,
             wa_sflight-seatsmax,
             wa_sflight-seatsocc.
  ENDSELECT.


END-OF-SELECTION.
  SKIP.
  WRITE: 'To get detailled information'(001),
         'start report SAPBC407_DATD_LDB'(002).
  CLEAR: today, next_week.
