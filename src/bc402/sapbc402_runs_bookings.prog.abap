*&---------------------------------------------------------------------*
*& Report  SAPBC402_RUNS_BOOKINGS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_runs_bookings.

*----------------------------------------------------------------------*
TYPES:
    ty_t_sbook   TYPE STANDARD TABLE OF sbook
                      WITH NON-UNIQUE DEFAULT KEY.
*----------------------------------------------------------------------*
DATA:
    gt_sbook     TYPE ty_t_sbook,
    wa_sbook     LIKE LINE OF gt_sbook.
*----------------------------------------------------------------------*
PARAMETERS:
    pa_cust TYPE sbook-customid.

SELECT-OPTIONS:
    so_odate FOR wa_sbook-order_date.
*----------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT *
      FROM sbook
      INTO TABLE gt_sbook
      WHERE customid   =  pa_cust
      AND   order_date IN so_odate.

  IF sy-subrc <> 0.
    MESSAGE s038(bc402).
*   Zu dieser Selektion existieren keine Daten (Bitte Neueingabe)
  ENDIF.

*----------------------------------------------------------------------*
END-OF-SELECTION.

  LOOP AT gt_sbook INTO wa_sbook.

    WRITE: /
        wa_sbook-carrid,
        wa_sbook-connid,
        wa_sbook-fldate,
        wa_sbook-bookid,
        wa_sbook-customid,
        wa_sbook-luggweight UNIT wa_sbook-wunit,
        wa_sbook-wunit.

  ENDLOOP.
