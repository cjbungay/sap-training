*&------------------------------------------------
*& Report  SAPBC405_LDBS_2
*&
*&------------------------------------------------
*&
*&
*&------------------------------------------------

INCLUDE bc405_ldbs_2top.

*&------------------------------------------------
*&   Event INITIALIZATION
*&------------------------------------------------
INITIALIZATION.
  carrid-sign = 'I'.
  carrid-option = 'BT'.
  carrid-low = 'AA'.
  carrid-high = 'LH'.
  APPEND carrid.


*&------------------------------------------------
*&   Event AT SELECTION-SCREEN OUTPUT
*&------------------------------------------------
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name CS 'AIRP_TO'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


*&------------------------------------------------
*&   Event GET SPFLI
*&------------------------------------------------
GET spfli.
* Data output SPFLI
  WRITE:  / spfli-carrid,
            spfli-connid,
            spfli-cityfrom,
            spfli-airpfrom,
            spfli-cityto,
            spfli-airpto.

*&------------------------------------------------
*&   Event GET SFLIGHT
*&------------------------------------------------
GET sflight.
* Calculate free seats
  free_seats = sflight-seatsmax - sflight-seatsocc.

* Data output SFLIGHT
  WRITE: / sflight-fldate,
           sflight-price CURRENCY sflight-currency,
           sflight-currency,
           sflight-planetype,
           sflight-seatsmax,
           sflight-seatsocc,
           free_seats.

*&------------------------------------------------
*&   Event GET SBOOK
*&------------------------------------------------
GET sbook.

* Check select-option
  CHECK so_cust.

  WRITE: / sbook-bookid,
           sbook-customid,
           sbook-smoker,
           sbook-luggweight UNIT sbook-wunit,
           sbook-wunit,
           sbook-order_date.

*&------------------------------------------------
*&   Event GET SPFLI LATE
*&------------------------------------------------
GET spfli LATE.
  ULINE.
  NEW-PAGE.
*&------------------------------------------------
*&   Event GET SFLIGHT LATE
*&------------------------------------------------
GET sflight LATE.
  ULINE.
