*&---------------------------------------------------------------------*
*& Report  SAPBC402_TABD_STORE_DUPL_COMPL                              *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Demonstration for exercise for internal tables                      *
*&                                                                     *
*& This program shows a complete algorith for the following problem    *
*& (exercises of BC402):                                               *
*&    The datastring to be split into different data sets for table    *
*&    SFLIGHT may contain several data sets per table key (carrid,     *
*&    connid, fldate).                                                 *
*&    Aims: a) Identify a duplicate and do only store the last         *
*&             data set to every key in IT_FLIGHTS, so the duplicate   *
*&             substitutes the current entry in table IT_FLIGHTS.      *
*&          B) All substituted data sets shall be stored in historical *
*&             order in IT_DOUBLES.                                    *
*&                                                                     *
*&    Implementation idea:                                             *
*&    for a): change the algorithm accordingly (see below)             *
*&    for b): use a nested table, in which you store for each          *
*&            key triplet (carrid, connid, fldate) all substituted     *
*&            data sets in an internal table                           *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc402_tabd_store_compl.
TYPE-POOLS: col.
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
  END OF st_flight_c,


*******************************************************************
*  implementation of b) structure types are indicated
*******************************************************************
*  BEGIN OF fkt_ty,                          " <-- BC402_S_FKT
*    price          TYPE sflight-price,
*    currency       TYPE sflight-currency,
*    planetype      TYPE sflight-planetype,
*    seatsmax       TYPE sflight-seatsmax,
*    seatsocc       TYPE sflight-seatsocc,
*  END OF fkt_ty,

*  BEGIN OF nest_ty,                         " <-- BC402_S_NEST
*    carrid         TYPE s_carr_id,
*    connid         TYPE s_conn_id,
*    fldate         TYPE s_date,
*    fkt            TYPE STANDARD TABLE OF fkt_ty
*                   WITH NON-UNIQUE DEFAULT KEY,
*  END OF nest_ty,

*  ts_doubles TYPE SORTED TABLE OF nest_ty   " <-- BC402_T_NEST
*             WITH NON-UNIQUE KEY carrid connid fldate,

  tt_flights TYPE SORTED TABLE OF bc402_s_flight
             WITH UNIQUE KEY fldate carrid connid.

DATA:
  datastring   TYPE string,
  set_string   TYPE string,

  wa_flight_c  TYPE st_flight_c,
  wa_flight    TYPE bc402_s_flight,

  it_flights   TYPE tt_flights,
  it_doubles   TYPE bc402_t_nest,      " ts_doubles,

  wa_doubles   LIKE LINE OF it_doubles,
  wa_fkt       LIKE LINE OF wa_doubles-fkt,

  it_alv1      TYPE bc402_t_flights_color,
  wa_alv1      LIKE LINE OF it_alv1.


FIELD-SYMBOLS:
  <wa_doubles> LIKE LINE OF it_doubles,
  <wa_flight>  LIKE LINE OF it_flights,
  <wa_fkt>     LIKE LINE OF <wa_doubles>-fkt.

CONSTANTS c_num TYPE i VALUE 30.

PARAMETERS:
  p_date TYPE s_date,
  p_list TYPE c AS CHECKBOX.

INITIALIZATION.
  p_date = sy-datum + 30.

AT SELECTION-SCREEN.
  IF p_date < sy-datum.
    MESSAGE e030(bc402).               " <-- 'invalid date'.
  ENDIF.

START-OF-SELECTION.

  CALL FUNCTION 'BC402_CREATE_SEP_STRING'
       EXPORTING
            im_number     = c_num
            im_table_name = 'SFLIGHT'
            im_separator  = '#'
            im_unique     = ' '
       IMPORTING
            ex_string     = datastring
       EXCEPTIONS
            no_data       = 1
            OTHERS        = 2.

  IF sy-subrc <> 0.
    MESSAGE a038(bc402).
  ENDIF.

  WHILE NOT datastring IS INITIAL.
    SHIFT datastring BY 2 PLACES.
    SEARCH datastring FOR '##'.
    IF sy-subrc = 0.
      set_string = datastring(sy-fdpos).
      SHIFT datastring BY sy-fdpos PLACES.

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
*     INSERT wa_flight INTO TABLE it_flights.
************************************************************************
*     implementation of a)
************************************************************************
      READ TABLE it_flights FROM wa_flight ASSIGNING <wa_flight>.
      IF sy-subrc <> 0.                " insert new entry
        INSERT wa_flight INTO TABLE it_flights.
      ELSE.                   " modify existing entry -> duplicate
        MOVE-CORRESPONDING <wa_flight> TO : wa_doubles,
                                            wa_fkt.
        READ TABLE it_doubles FROM wa_doubles ASSIGNING <wa_doubles>.
        IF sy-subrc <> 0.
          INSERT wa_fkt     INTO TABLE wa_doubles-fkt.
          INSERT wa_doubles INTO TABLE it_doubles.
          CLEAR: wa_fkt, wa_doubles.
        ELSE.
          INSERT wa_fkt     INTO TABLE <wa_doubles>-fkt.
          CLEAR: wa_fkt.
        ENDIF.
        MODIFY TABLE it_flights FROM wa_flight.
      ENDIF.
************************************************************************
    ENDIF.
  ENDWHILE.

* ----------------------------------------------------------------------
* copy the last entry which is always in it_flights at the end of the
* internal table for each key in it_doubles (order in which the data
* has been extracted
* ----------------------------------------------------------------------
  IF NOT it_doubles IS INITIAL.
    LOOP AT it_doubles ASSIGNING <wa_doubles>.
      MOVE-CORRESPONDING <wa_doubles> TO wa_flight.
      READ TABLE it_flights FROM wa_flight ASSIGNING <wa_flight>.
      MOVE-CORRESPONDING <wa_flight> TO wa_fkt.
      INSERT wa_fkt INTO TABLE <wa_doubles>-fkt.
    ENDLOOP.
  ENDIF.


  IF p_list IS INITIAL.                " list output as ABAP spool list

    LOOP AT it_flights INTO wa_flight.
      IF wa_flight-fldate < sy-datum.
        FORMAT COLOR COL_NEGATIVE.
      ELSEIF wa_flight-fldate BETWEEN sy-datum AND p_date.
        FORMAT COLOR COL_TOTAL.
      ELSE.
        FORMAT COLOR COL_POSITIVE.
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

    IF NOT it_doubles IS INITIAL.
      SKIP 2.
    WRITE: / 'The following data sets occured more then one time:'(dob).
      SKIP.


      LOOP AT it_doubles ASSIGNING <wa_doubles>.
        WRITE: /
          <wa_doubles>-carrid,
          <wa_doubles>-connid,
          <wa_doubles>-fldate DD/MM/YYYY.
        LOOP AT <wa_doubles>-fkt ASSIGNING <wa_fkt>.
          WRITE: /8
            sy-tabix,
            <wa_fkt>-price CURRENCY <wa_fkt>-currency,
            <wa_fkt>-currency,
            <wa_fkt>-planetype,
            <wa_fkt>-seatsmax,
            <wa_fkt>-seatsocc.
        ENDLOOP.
      ENDLOOP.

    ENDIF.

  ELSE.                                " list output using ALV
*   map it_flights to it_alv1
    LOOP AT it_flights INTO wa_flight.
      MOVE-CORRESPONDING wa_flight TO wa_alv1.
      IF wa_flight-fldate < sy-datum.
        wa_alv1-color = col_negative.
      ELSEIF wa_flight-fldate BETWEEN sy-datum AND p_date.
        wa_alv1-color = col_total.
      ELSE.
        wa_alv1-color = col_positive.
      ENDIF.
      INSERT wa_alv1 INTO TABLE it_alv1.
    ENDLOOP.

    CALL FUNCTION 'BC402_ALV_DEMO_OUTPUT_EXT'
         EXPORTING
              it_list1 = it_alv1
              it_list2 = it_doubles.


  ENDIF.
