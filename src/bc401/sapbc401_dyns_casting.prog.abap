*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYNS_CASTING                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc401_dyns_casting.

TYPE-POOLS col.

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
  END OF st_flight,

  BEGIN OF st_date,
    year(4)  TYPE n,
    month(2) TYPE n,
    day(2)   TYPE n,
  END OF st_date.


CONSTANTS c_number TYPE i VALUE 30.

DATA:
  datastring  TYPE string,
  set_string  TYPE string,

  wa_flight_c TYPE st_flight_c,
  wa_flight   TYPE st_flight.

DATA:
  it_sets TYPE STANDARD TABLE OF string
          WITH NON-UNIQUE DEFAULT KEY
          INITIAL SIZE c_number,

  it_flights TYPE SORTED TABLE OF st_flight
             WITH UNIQUE KEY fldate carrid connid
             INITIAL SIZE c_number,

  it_doubles TYPE SORTED TABLE OF st_flight
             WITH NON-UNIQUE KEY fldate carrid connid
             INITIAL SIZE c_number,


  it_col_flights TYPE bc401_t_flights_color,
  it_col_doubles LIKE it_col_flights,
  wa_col_flight LIKE LINE OF it_col_flights.


FIELD-SYMBOLS <fs_date> TYPE st_date.


PARAMETERS:
  pa_date LIKE sy-datum,
  pa_alv  AS CHECKBOX DEFAULT 'X'.


LOAD-OF-PROGRAM.
  pa_date = sy-datum.
  ASSIGN pa_date TO <fs_date> CASTING.

  <fs_date>-day = '01'.
  IF <fs_date>-month < 12.
    <fs_date>-month = <fs_date>-month + 1.
  ELSE.
    <fs_date>-month = '01'.
    <fs_date>-year = <fs_date>-year + 1.
  ENDIF.


AT SELECTION-SCREEN.
  IF pa_date < sy-datum.
    MESSAGE e085(bc401).               " date in the past
  ENDIF.


START-OF-SELECTION.

  CALL FUNCTION 'BC401_GET_SEP_STRING'
     EXPORTING
       im_number           = c_number
*      IM_TABLE_NAME       = 'SFLIGHT'
*      IM_SEPARATOR        = '#'
       im_unique           = space
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

  SPLIT datastring AT '##' INTO TABLE it_sets.


  LOOP AT it_sets INTO set_string.

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
          wa_flight_c-paymentsum.

    MOVE-CORRESPONDING wa_flight_c TO wa_flight.
    INSERT wa_flight INTO TABLE it_flights.
    IF sy-subrc <> 0.
      INSERT wa_flight INTO TABLE it_doubles.
    ENDIF.

  ENDLOOP.



* output:
*********
  IF pa_alv = 'X'.

    LOOP AT it_flights INTO wa_flight.
      MOVE-CORRESPONDING wa_flight TO wa_col_flight.
      IF wa_col_flight-fldate < sy-datum.
        wa_col_flight-color = col_negative.
      ELSEIF wa_col_flight-fldate < pa_date.
        wa_col_flight-color = col_total.
      ELSE.
        wa_col_flight-color = col_positive.
      ENDIF.
      INSERT wa_col_flight INTO TABLE it_col_flights.
    ENDLOOP.

    LOOP AT it_doubles INTO wa_flight.
      MOVE-CORRESPONDING wa_flight TO wa_col_flight.
      wa_col_flight-color = col_background.
      INSERT wa_col_flight INTO TABLE it_col_doubles.
    ENDLOOP.

    CALL FUNCTION 'BC401_ALV_LIST_OUTPUT'
      EXPORTING
        it_list1      = it_col_flights
        it_list2      = it_col_doubles
      EXCEPTIONS
        control_error = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE a702(bc401).
    ENDIF.

  ELSE.
    LOOP AT it_flights INTO wa_flight.
      IF wa_flight-fldate < sy-datum.
        FORMAT COLOR = col_negative.
      ELSEIF wa_flight-fldate < pa_date.
        FORMAT COLOR = col_total.
      ELSE.
        FORMAT COLOR = col_positive.
      ENDIF.

      WRITE: /
        wa_flight-carrid,
        wa_flight-connid,
        wa_flight-fldate DD/MM/YYYY,
        wa_flight-price CURRENCY wa_flight-currency,
        wa_flight-currency,
        wa_flight-planetype,
        wa_flight-seatsmax,
        wa_flight-seatsocc.
    ENDLOOP.

    FORMAT RESET.

    SKIP.
    WRITE: / 'doppelte Datensätze:'(dob) COLOR COL_HEADING.

    LOOP AT it_doubles INTO wa_flight.
      WRITE: /
        wa_flight-carrid,
        wa_flight-connid,
        wa_flight-fldate DD/MM/YYYY,
        wa_flight-price CURRENCY wa_flight-currency,
        wa_flight-currency,
        wa_flight-planetype,
        wa_flight-seatsmax,
        wa_flight-seatsocc.
    ENDLOOP.
  ENDIF.
