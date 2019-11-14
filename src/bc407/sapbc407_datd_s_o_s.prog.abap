*&---------------------------------------------------------------------*
*& Report  SAPBC407_DATD_S_O_S                                         *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc407_datd_s_o_s.


* Data objects
DATA: wa_sflight TYPE sflight.

DATA: today TYPE sy-datum,
      next_week TYPE sy-datum.


* Selection screen
SELECT-OPTIONS: so_car FOR wa_sflight-carrid.


START-OF-SELECTION.
* Report information
  WRITE: /, 'This report evaluates sflight data'(001),
             'from today on for the next 4 weeks.'(002) .
  SKIP.

  today = sy-datum.
  next_week = today + 28.

* Data retrieval
  SELECT * FROM sflight
     INTO wa_sflight
     WHERE carrid IN so_car
       AND fldate BETWEEN today and next_week.

    WRITE: / wa_sflight-carrid,
             wa_sflight-connid,
             wa_sflight-fldate,
             wa_sflight-seatsmax,
             wa_sflight-seatsocc.
  ENDSELECT.
