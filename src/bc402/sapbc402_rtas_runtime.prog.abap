*&---------------------------------------------------------------------*
*& Report  SAPBC402_RTAS_RUNTIME
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_rtas_runtime.

TYPES:
  BEGIN OF ty_s_booking,
    carrid      TYPE sbook-carrid,
    connid      TYPE sbook-connid,
    fldate      TYPE sbook-fldate,
    bookid      TYPE sbook-bookid,
    order_date  TYPE sbook-order_date,
  END OF ty_s_booking.

* alternatively a global structure type could be used here

PARAMETERS pa_carr TYPE sbook-carrid.

DATA: it_sbook TYPE TABLE OF ty_s_booking,
      wa_sbook TYPE ty_s_booking.


SELECT carrid connid fldate bookid order_date FROM sbook
       INTO TABLE it_sbook
       WHERE  carrid = pa_carr.


SORT it_sbook BY order_date.

LOOP AT it_sbook INTO wa_sbook.

  WRITE: /  wa_sbook-carrid,
         5  wa_sbook-connid,
        11  wa_sbook-fldate,
        23  wa_sbook-bookid,
        33  wa_sbook-order_date.

ENDLOOP.
