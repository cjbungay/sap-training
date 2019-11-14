*----------------------------------------------------------------------*
*   INCLUDE BC402_TABD_PROP_COM_LCL2                                   *
*----------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       CLASS lcl_class_2 DEFINITION
*---------------------------------------------------------------------*
*       Local class representing implementation of program            *
*       SAPBC402_TABD_TABLE_PROPS_1                                   *
*---------------------------------------------------------------------*
CLASS lcl_class_2 DEFINITION.
  PUBLIC SECTION.
* data types
    TYPES:
* line types
      BEGIN OF connection,
        carrid   TYPE s_carr_id,       " carrier id
        connid   TYPE s_conn_id,       " connection id
        cityfrom TYPE s_city,          " city of departure
        cityto   TYPE s_city,          " city of destination
        airpfrom TYPE s_airport,       " airport of departure
        airpto   TYPE s_airport,       " airport of destination
      END OF connection,

      BEGIN OF result,
        cityfrom TYPE s_city,          " city of departure
        citystop TYPE s_city,          " city of stopover
        cityto   TYPE s_city,          " city of destination
        carrid   TYPE s_carr_id,       " carrid of 1st connection
        connid   TYPE s_conn_id,       " connid of 1st connection
        carrid2  TYPE s_carr_id,       " carrid of 2nd connection
        connid2  TYPE s_conn_id,       " connid of 2nd connection
      END OF result,

* table types
      connections TYPE STANDARD TABLE OF connection
         WITH NON-UNIQUE DEFAULT KEY,  " KEY cityfrom,

      results TYPE HASHED TABLE OF result
        WITH UNIQUE KEY carrid connid carrid2 connid2.

* data objects
    DATA:
      it_connection  TYPE connections. " connection data

* constants
    CONSTANTS:
      p_airp TYPE spfli-airpfrom VALUE 'FRA'. " airport of departure


    METHODS:
      constructor,
*   ----------------------------------------------------------------
      execute
        EXPORTING value(runtime) TYPE i.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_class_2 IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_class_2 IMPLEMENTATION.
  METHOD constructor.
* read connection data
    SELECT carrid connid cityfrom cityto airpfrom airpto
      FROM spfli
      INTO CORRESPONDING FIELDS OF TABLE it_connection.

    IF sy-subrc NE 0.
      WRITE: / text-005.   " <-- EN: 'No data found'.
      EXIT.
    ENDIF.

  ENDMETHOD.
* ------------------------------------------------------------------
  METHOD execute.
    DATA:
      it_result      TYPE results,     " result table
      wa_result      LIKE LINE OF it_result, " work area
      no_of_lines    TYPE sy-tabix,    " number of lines in it_result
      index          TYPE sy-tabix,

      rt_start       TYPE i,
      rt_stop        TYPE i,

      wa1_connection TYPE connection,  " access line in it_connection
      wa2_connection TYPE connection.  " access line in it_connection

    GET RUN TIME FIELD rt_start.

    SORT it_connection BY airpfrom.

* loop over all connections starting from departure airport
    LOOP AT it_connection INTO wa1_connection
      WHERE airpfrom = p_airp.

      CLEAR: wa_result-citystop,
             wa_result-carrid2,
             wa_result-connid2.

*   store direct connections (without stopover)
      MOVE-CORRESPONDING wa1_connection TO wa_result.
      INSERT wa_result INTO TABLE it_result.

*   determine all connections starting from destination airport
*   of first connection
      READ TABLE it_connection
         WITH KEY airpfrom = wa1_connection-airpto
         BINARY SEARCH TRANSPORTING NO FIELDS.
      index = sy-tabix.

      LOOP AT it_connection INTO wa2_connection FROM index.
*     exit loop if first non-matching airport is accessed
        IF wa2_connection-airpfrom <> wa1_connection-airpto.
          EXIT.
        ENDIF.

*     store data of connecting connections
        wa_result-carrid2  = wa2_connection-carrid.
        wa_result-connid2  = wa2_connection-connid.
        wa_result-citystop = wa2_connection-cityfrom.
        wa_result-cityto   = wa2_connection-cityto.
        INSERT wa_result INTO TABLE it_result.

      ENDLOOP.
    ENDLOOP.

    GET RUN TIME FIELD rt_stop.

    runtime = rt_stop - rt_start.

  ENDMETHOD.
ENDCLASS.
