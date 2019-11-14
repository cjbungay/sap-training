*&---------------------------------------------------------------------*
*& Report  SAPBC402_DTSS_DATA_SET                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*& solution of exercise 1: ABAP Statements and String processing       *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc402_dtss_data_set.

*----------------------------------------------------------------------*
TYPES:
  BEGIN OF ty_s_flight_c,
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
  END OF ty_s_flight_c,

  BEGIN OF ty_s_flight,
    carrid(3)     TYPE c,
    connid(4)     TYPE n,
    fldate        TYPE d,
    price(9)      TYPE p DECIMALS 2,
    currency(5)   TYPE c,
    planetype(10) TYPE c,
    seatsmax      TYPE i,
    seatsocc      TYPE i,
  END OF ty_s_flight.

*----------------------------------------------------------------------*
DATA:
  gv_datastring   TYPE string,
  gv_set_string   TYPE string,
  gs_flight_c     TYPE ty_s_flight_c,
  gs_flight       TYPE ty_s_flight.

*----------------------------------------------------------------------*
START-OF-SELECTION.

  CALL FUNCTION 'BC402_CREATE_SEP_STRING'
*      EXPORTING
*            im_number     = '1'
*            im_table_name = 'SFLIGHT'
*            im_separator  = '#'
*            im_unique     = 'X'
       IMPORTING
            ex_string     = gv_datastring
       EXCEPTIONS
            no_data       = 1
            OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE a038(bc402).
  ENDIF.

* test:
*  WRITE datastring.
***

  SHIFT gv_datastring BY 2 PLACES.
  SEARCH gv_datastring FOR '##'.
  IF sy-subrc = 0.
    gv_set_string = gv_datastring(sy-fdpos).
  ENDIF.

* test:
*  WRITE: / set_string.
***

  SPLIT gv_set_string AT '#' INTO
        gs_flight_c-mandt
        gs_flight_c-carrid
        gs_flight_c-connid
        gs_flight_c-fldate
        gs_flight_c-price
        gs_flight_c-currency
        gs_flight_c-planetype
        gs_flight_c-seatsmax
        gs_flight_c-seatsocc
        gs_flight_c-paymentsum
        gs_flight_c-seatsmax_b
        gs_flight_c-seatsocc_b
        gs_flight_c-seatsmax_f
        gs_flight_c-seatsocc_f.
* test:
*  WRITE: /
*    gs_flight_c-mandt,
*    gs_flight_c-carrid,
*    gs_flight_c-connid,
*    gs_flight_c-fldate,
*    gs_flight_c-price,
*    gs_flight_c-currency,
*    gs_flight_c-planetype,
*    gs_flight_c-seatsmax,
*    gs_flight_c-seatsocc,
*    gs_flight_c-paymentsum,
*    gs_flight_c-seatsmax_b,
*    gs_flight_c-seatsocc_b,
*    gs_flight_c-seatsmax_f,
*    gs_flight_c-seatsocc_f.
***

  MOVE-CORRESPONDING gs_flight_c TO gs_flight.

  WRITE: /
    gs_flight-carrid,
    gs_flight-connid,
    gs_flight-fldate DD/MM/YYYY,
    gs_flight-price CURRENCY gs_flight-currency,
    gs_flight-currency,
    gs_flight-planetype,
    gs_flight-seatsmax,
    gs_flight-seatsocc.
