*&---------------------------------------------------------------------*
*& Report         SAPBC400UDS_DETAIL_LIST                              *
*&---------------------------------------------------------------------*

REPORT  sapbc400uds_detail_list.

CONSTANTS actvt_display TYPE activ_auth VALUE '03'.

DATA: wa_flight TYPE sbc400focc,
      wa_sbook  TYPE sbook.

PARAMETERS pa_car TYPE s_carr_id.



START-OF-SELECTION.

  AUTHORITY-CHECK OBJECT 'S_CARRID'
    ID 'CARRID' FIELD pa_car
    ID 'ACTVT'  FIELD actvt_display.

  CASE sy-subrc.
    WHEN 0.
      SELECT carrid connid fldate seatsmax seatsocc FROM sflight
             INTO CORRESPONDING FIELDS OF wa_flight
             WHERE carrid = pa_car.
        wa_flight-percentage =
          100 * wa_flight-seatsocc / wa_flight-seatsmax.
        WRITE: / wa_flight-carrid,
                 wa_flight-connid,
                 wa_flight-fldate,
                 wa_flight-seatsocc,
                 wa_flight-seatsmax,
                 wa_flight-percentage,'%'.
*       Hide key values of the current line
        HIDE: wa_flight-carrid, wa_flight-connid, wa_flight-fldate.
      ENDSELECT.
      IF sy-subrc NE 0.
        WRITE: 'No ', pa_car, 'flights found !'.
      ENDIF.
    WHEN OTHERS.
      WRITE: / 'Authority-Check Error'(001).
  ENDCASE.

  CLEAR wa_flight.



AT LINE-SELECTION.

  IF sy-lsind = 1.
    WRITE: / wa_flight-carrid, wa_flight-connid, wa_flight-fldate.
    ULINE.
    SKIP.
    SELECT bookid customid custtype class order_date
           smoker cancelled
           FROM sbook INTO CORRESPONDING FIELDS OF wa_sbook
           WHERE carrid = wa_flight-carrid
            AND  connid = wa_flight-connid
            AND  fldate = wa_flight-fldate.
*     Creating detail list
      WRITE: / wa_sbook-bookid,
               wa_sbook-customid,
               wa_sbook-custtype,
               wa_sbook-class,
               wa_sbook-order_date,
               wa_sbook-smoker,
               wa_sbook-cancelled.
    ENDSELECT.
  ENDIF.

  CLEAR wa_flight.
