*&---------------------------------------------------------------------*
*& Report  SAPBC402_RTAD_RUNTIME
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_rtad_runtime.

PARAMETERS pa_carr TYPE sbook-carrid.

DATA: it_sbook TYPE TABLE OF sbook,
      wa_sbook TYPE sbook.


SELECT * FROM sbook
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
