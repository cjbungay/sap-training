*&---------------------------------------------------------------------*
*& Report  SAPBC408OTH_DISPLAY_BOOKINGS                                *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc405oth_display_bookings                                .

* needed for key information of selected flights
DATA: BEGIN OF wa_sel_flights,
        mandt  TYPE sflight-mandt,
        carrid TYPE sflight-carrid,
        connid TYPE sflight-connid,
        fldate TYPE sflight-fldate,
      END OF wa_sel_flights,

      it_sel_flights LIKE TABLE OF wa_sel_flights.

DATA: it_sbook TYPE TABLE OF sbook,
      wa_sbook TYPE sbook.
DATA: int_sw TYPE i.

START-OF-SELECTION.

  IMPORT it_sel_flights FROM MEMORY ID 'BC405'.

  SELECT *
    FROM sbook
    INTO TABLE it_sbook
    FOR ALL ENTRIES IN it_sel_flights
      WHERE  carrid = it_sel_flights-carrid
        AND  connid = it_sel_flights-connid
        AND  fldate = it_sel_flights-fldate.

  SORT it_sbook.

  LOOP AT it_sbook INTO wa_sbook.
    AT NEW fldate.
      NEW-PAGE.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      WRITE: / wa_sbook-carrid,
               wa_sbook-connid,
               wa_sbook-fldate.
      ULINE.
      int_sw = 1.
    ENDAT.

    IF int_sw = 1.
      FORMAT INTENSIFIED ON.
      int_sw = 0.
    ELSE.
      FORMAT INTENSIFIED OFF.
      int_sw = 1.
    ENDIF.
    FORMAT COLOR COL_NORMAL.
    WRITE: / wa_sbook-bookid,
             wa_sbook-customid,
             wa_sbook-custtype,
             wa_sbook-smoker,
             wa_sbook-luggweight unit wa_sbook-wunit,
             wa_sbook-wunit,
             wa_sbook-class,
             wa_sbook-forcuram CURRENCY wa_sbook-forcurkey,
             wa_sbook-forcurkey,
             wa_sbook-cancelled.
  ENDLOOP.
