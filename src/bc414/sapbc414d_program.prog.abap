*&---------------------------------------------------------------------*
*& Report  SAPBC414D_PROGRAM                                           *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC414D_PROGRAM             .
data: wa_sflight type sflight,
      counter    type i.

parameters: pa_carr type spfli-carrid.
select-options so_conn for wa_sflight-connid.

start-of-selection.
  if pa_carr is initial.
    skip 1.
    write: / text-001 color col_heading.
    write: / text-002 color col_normal.
    skip 3.
    write: /3 text-003 color col_key, 20 sy-uname color col_positive.
    write: /3 text-004 color col_key, 20 sy-datum color col_positive.
    write: /3 text-005 color col_key, 20 sy-uzeit color col_positive.
  else.
  format color col_heading.
    write: /3    text-010,
*           9    text-011,
            17   text-012,
            30   text-013,
*           40   text-014,
            45   text-015,
            55   text-016.
  format color col_normal.
    SELECT * FROM  sflight into wa_sflight
           WHERE  carrid  = PA_CARR
           AND    connid  in so_conn.
       WRITE: /3      wa_sflight-carrid,
               9      wa_sflight-connid,
               17     wa_sflight-fldate,
               30(10) wa_sflight-price currency wa_sflight-currency,
               40     wa_sflight-currency,
               45     wa_sflight-seatsmax,
               55     wa_sflight-seatsocc.
   ENDSELECT.

   counter = sy-dbcnt.
   export read_number from counter to memory ID 'BC414'.
endif.
