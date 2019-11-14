*&------------------------------------------------
*& Report  SAPBC405_LDBS_1
*&
*&------------------------------------------------
*&
*&
*&------------------------------------------------

INCLUDE bc405_ldbs_1top.

*&---------------------------------------------------------------------*
*&   Event INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
  carrid-sign = 'I'.
  carrid-option = 'BT'.
  carrid-low = 'AA'.
  carrid-high = 'LH'.
  APPEND carrid.

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
  WRITE: / sbook-bookid,
           sbook-customid,
           sbook-smoker,
           sbook-luggweight UNIT sbook-wunit,
           sbook-wunit.
