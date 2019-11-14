*&---------------------------------------------------------------------*
*& Report  SAPBC401_DTOT_SPLIT_STRING                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_dtot_split_string.

* Choose appropriate types for the definitions:
TYPES:
  BEGIN OF st_flight_c,
     mandt(3)   TYPE c,
*    carrid     TYPE
*    connid     TYPE
*    fldate     TYPE
*    price      TYPE
*    currency   TYPE
*    planetype  TYPE
*    seatsmax   TYPE
*    seatsocc   TYPE
*    paymentsum TYPE
*    seatsmax_b TYPE
*    seatsocc_b TYPE
*    seatsmax_f TYPE
*    seatsocc_f TYPE
  END OF st_flight_c,

  BEGIN OF st_flight,
     carrid(3)   TYPE c,
     connid(4)   TYPE n,
*    fldate      TYPE
*    price       TYPE
*    currency    TYPE
*    planetype   TYPE
*    seatsmax    TYPE
*    seatsocc    TYPE
  END OF st_flight.

DATA:
   datastring TYPE string,
*  set_string TYPE

   wa_flight_c TYPE st_flight_c,
   wa_flight   TYPE st_flight.



START-OF-SELECTION.

* With the help of the function module we simulate
* external data transfer

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

* Remove both of the leading separators of the string.
* Then copy the remainder up to the terminating separators into
* set_string

* ......




* Separate the content of set_string into the structure wa_flight_c

* ......


* The output will now be formated

* .......

  WRITE: /
     wa_flight-carrid,
     wa_flight-connid.
*    wa_flight-fldate,
*    wa_flight-price,
*    wa_flight-currency,
*    wa_flight-planetype,
*    wa_flight-seatsmax,
*    wa_flight-seatsocc.
