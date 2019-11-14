*&---------------------------------------------------------------------*
*& Report  SAPBC401_DTOS_SPLIT_STRING                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_dtos_split_string.


TYPES:
  BEGIN OF st_flight_c,
    mandt(3)       TYPE c,
    carrid(3)      TYPE c,
    connid(4)      TYPE n,
    fldate(8)      TYPE n,
    price(20)      TYPE c,
    currency(5)    TYPE c,
    planetype(10)  TYPE c,
    seatsmax(10)   TYPE n,
    seatsocc(10)   TYPE n,
    paymentsum(22) TYPE c,
    seatsmax_b(10) TYPE n,
    seatsocc_b(10) TYPE n,
    seatsmax_f(10) TYPE n,
    seatsocc_f(10) TYPE n,
  END OF st_flight_c,

  BEGIN OF st_flight,
    carrid(3)     TYPE c,
    connid(4)     TYPE n,
    fldate        TYPE d,
    price(9)      TYPE p DECIMALS 2,
    currency(5)   TYPE c,
    planetype(10) TYPE c,
    seatsmax      TYPE i,
    seatsocc      TYPE i,
  END OF st_flight.

DATA:
  datastring  TYPE string,
  set_string  TYPE string,

  wa_flight_c TYPE st_flight_c,
  wa_flight   TYPE st_flight.



START-OF-SELECTION.

  CALL FUNCTION 'BC401_GET_SEP_STRING'
* EXPORTING
*   IM_NUMBER           = '1'
*   IM_TABLE_NAME       = 'SFLIGHT'
*   IM_SEPARATOR        = '#'
*   IM_UNIQUE           = 'X'
  IMPORTING
    ex_string           = datastring
  EXCEPTIONS
    no_data             = 1
    OTHERS              = 2.

  IF sy-subrc <> 0.
    MESSAGE a038(bc401).
  ENDIF.


  SHIFT datastring BY 2 PLACES.
  FIND '##' IN datastring.
  IF sy-subrc <> 0.
    MESSAGE a702(bc401).
  ENDIF.
  SPLIT datastring AT '##' INTO set_string datastring.


  SPLIT set_string AT '#' INTO
        wa_flight_c-mandt
        wa_flight_c-carrid
        wa_flight_c-connid
        wa_flight_c-fldate
        wa_flight_c-price
        wa_flight_c-currency
        wa_flight_c-planetype
        wa_flight_c-seatsmax
        wa_flight_c-seatsocc
        wa_flight_c-paymentsum
        wa_flight_c-seatsmax_b
        wa_flight_c-seatsocc_b
        wa_flight_c-seatsmax_f
        wa_flight_c-seatsocc_f.


  MOVE-CORRESPONDING wa_flight_c TO wa_flight.

  WRITE: /
    wa_flight-carrid,
    wa_flight-connid,
    wa_flight-fldate DD/MM/YYYY,
    wa_flight-price CURRENCY wa_flight-currency,
    wa_flight-currency,
    wa_flight-planetype,
    wa_flight-seatsmax,
    wa_flight-seatsocc.
