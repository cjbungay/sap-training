*&---------------------------------------------------------------------*
*& Report  SAPBC401_TABD_TABLE_PROPS_3                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*& BC401 demonstration                                                 *
*& Scenario:                                                           *
*&   Determine all connection between airport A and airport B          *
*&   including - direct connections (one 'flight')                     *
*&             - indirect connections using two connecting             *
*&               'flights'.                                            *
*&   Only airport A is fixed. It can be input as a PARAMETER           *
*&   on the standard selection screen.                                 *
*&                                                                     *
*& Implementation idea:                                                *
*&   a) Read all connection into internal table IT_CONNECTION.         *
*&   b) Loop over all connections. Once you have a connection starting *
*&      at airport A:                                                  *
*&      1. Store it into the result table IT_RESULT.                   *
*&      2. LOOP over IT_CONNECTION to determine all connections        *
*&      starting at the target airport of the first loop!              *
*&   c) eliminate possible duplicates                                  *
*&   d) output the result table IT_RESULT                              *
*&                                                                     *
*& Objectives:                                                         *
*&   - proper use of table kinds and                                   *
*&   - proper use of table operation properties                        *
*&   - make use of performance optimizations of runtime                *
*&     system                                                          *
*&   1: use for IT_RESULT a table type with a unique key! So           *
*&           elimination of duplicates can be dropped!                 *
*&   2: use performance optimization of SORTED tables for              *
*&           IT_CONNECTIONS: the inner LOOP is a loop where the first  *
*&           key field of the table key is determined uniquely.        *
*&   3: Use copy-free loops via LOOP ... ASSIGNING                     *
*&                                                                     *
*&   ----------------------------------------------------------------- *

*&   ----------------------------------------------------------------- *
*&   Copy free LOOPs are used.                                         *
*&                                                                     *
*&   A SORTED table is used for IT_CONNECTIONS.                        *
*&   So IT_CONNECTIONS need not be sorted via SORT and the WHERE       *
*&   clause can be used performance optimized for the inner LOOP.      *
*&                                                                     *
*&   A HASHED table with UNIQUE key is used for IT_RESULT.             *
*&   So the elimination of duplictes is not necessary any more.        *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_tabd_table_props_3.

TYPES:
* line types
  BEGIN OF connection,
    carrid   TYPE s_carr_id,           " carrier id
    connid   TYPE s_conn_id,           " connection id
    cityfrom TYPE s_city,              " city of departure
    cityto   TYPE s_city,              " city of destination
    airpfrom TYPE s_airport,           " airport of departure
    airpto   TYPE s_airport,           " airport of destination
  END OF connection,

  BEGIN OF result,
    cityfrom TYPE s_city,              " city of departure
    citystop TYPE s_city,              " city of stopover
    cityto   TYPE s_city,              " city of destination
    carrid   TYPE s_carr_id,           " carrier id of 1st connection
    connid   TYPE s_conn_id,           " connection id of 1st connection
    carrid2  TYPE s_carr_id,           " carrier id of 2nd connection
    connid2  TYPE s_conn_id,           " connection id of 2nd connection
  END OF result,

* table types
  connections TYPE SORTED TABLE OF connection
     WITH NON-UNIQUE KEY cityfrom,

  results TYPE HASHED TABLE OF result
    WITH UNIQUE KEY carrid connid carrid2 connid2.


DATA:
  it_connection TYPE connections,      " connection data
  it_result     TYPE results,          " result table
  wa_result     LIKE LINE OF it_result," work area
  no_of_lines   TYPE sy-tabix.         " number of lines in it_result

data:
  airpfrom type spfli-airpfrom.

FIELD-SYMBOLS:
  <wa1_connection> TYPE connection,    " access line in it_connection
  <wa2_connection> TYPE connection,    " access line in it_connection
  <wa_result>      TYPE result.        " access line in it_result

PARAMETERS:
  p_airp TYPE spfli-airpfrom DEFAULT 'FRA'. " airport of departure





START-OF-SELECTION.

* read connection data
  SELECT carrid connid cityfrom cityto airpfrom airpto
    FROM spfli
    INTO CORRESPONDING FIELDS OF TABLE it_connection.

  IF sy-subrc NE 0.
    WRITE: / 'No data found'.
    EXIT.
  ENDIF.

* loop over all connections starting from departure airport
  LOOP AT it_connection ASSIGNING <wa1_connection>
    WHERE airpfrom = p_airp.

    CLEAR: wa_result-citystop,
           wa_result-carrid2,
           wa_result-connid2.

*   store direct connections (without stopover)
    MOVE-CORRESPONDING <wa1_connection> TO wa_result.
    INSERT wa_result INTO TABLE it_result.

*   determine all connections starting from destination airport
*   of first connection
    LOOP AT it_connection ASSIGNING <wa2_connection>
      WHERE airpfrom = <wa1_connection>-airpto.

*     store data of connecting connections
      wa_result-carrid2  = <wa2_connection>-carrid.
      wa_result-connid2  = <wa2_connection>-connid.
      wa_result-citystop = <wa2_connection>-cityfrom.
      wa_result-cityto   = <wa2_connection>-cityto.
      INSERT wa_result INTO TABLE it_result.

    ENDLOOP.
  ENDLOOP.

  DESCRIBE TABLE it_result LINES no_of_lines.
  IF no_of_lines = 0.
    WRITE: / 'No connections found'.
  ELSE.

    SORT it_result BY cityfrom cityto citystop.

    LOOP AT it_result ASSIGNING <wa_result>.
      WRITE: / <wa_result>-cityfrom,
               <wa_result>-citystop,
               <wa_result>-cityto,
               <wa_result>-carrid,
               <wa_result>-connid.
      IF NOT <wa_result>-carrid2 IS INITIAL.
        WRITE:   <wa_result>-carrid2,
                 <wa_result>-connid2.
      ENDIF.
    ENDLOOP.
  ENDIF.
