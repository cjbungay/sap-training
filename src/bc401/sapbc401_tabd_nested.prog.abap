*&---------------------------------------------------------------------*
*& Report  SAPBC401_TABD_NESTED                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*& lists all reachable cities and connections from there               *
*&                                                                     *
*&---------------------------------------------------------------------*

*All connections are buffered in one internal table.
*First, the connections are assigned to a field symbol.
*We are interested in the destination cities
*only. Each of them is stored in one line of the outer internal table.
*
*The inner table is filled with the cities that can be reached from
*there.


REPORT  sapbc401_tabd_nested .


TYPES:
  BEGIN OF t_conn,
    cityfrom TYPE spfli-cityfrom,
    cityto   TYPE spfli-cityto,
    carrid   TYPE spfli-carrid,
    connid   TYPE spfli-connid,
  END OF t_conn.


DATA:
  conn_list TYPE STANDARD TABLE OF t_conn,

  BEGIN OF wa_travel,
    dest      TYPE spfli-cityto,
    cofl_list LIKE conn_list,
  END OF wa_travel,

  travel_list LIKE SORTED TABLE OF wa_travel WITH UNIQUE KEY dest,

  startline LIKE sy-tabix.


FIELD-SYMBOLS:
  <fs_conn>     TYPE t_conn,
  <fs_conn_int> TYPE t_conn,
  <fs_travel>   LIKE wa_travel.


PARAMETERS pa_start TYPE spfli-cityfrom DEFAULT 'FRANKFURT'.




START-OF-SELECTION.

  SELECT carrid connid cityfrom cityto
         FROM spfli
         INTO CORRESPONDING FIELDS OF TABLE conn_list.
  SORT conn_list STABLE BY cityfrom cityto ASCENDING AS TEXT.

*** build up nested table
  LOOP AT conn_list ASSIGNING <fs_conn>
                    WHERE cityfrom = pa_start.

    CLEAR wa_travel.
    wa_travel-dest = <fs_conn>-cityto.

    READ TABLE conn_list
               WITH KEY cityfrom = wa_travel-dest
               TRANSPORTING NO FIELDS
               BINARY SEARCH.
    startline = sy-tabix.
    LOOP AT conn_list ASSIGNING <fs_conn_int>
                      FROM startline.
      IF <fs_conn_int>-cityfrom <> wa_travel-dest.
        EXIT.
      ENDIF.
      APPEND <fs_conn_int> TO wa_travel-cofl_list.
    ENDLOOP.

    SORT wa_travel-cofl_list BY cityto carrid ASCENDING AS TEXT.
    INSERT wa_travel INTO TABLE travel_list.
  ENDLOOP.



*** output

  LOOP AT travel_list ASSIGNING <fs_travel>.
    WRITE: / <fs_travel>-dest.

    LOOP AT <fs_travel>-cofl_list ASSIGNING <fs_conn_int>.
      AT NEW cityto.
        WRITE: /8 <fs_conn_int>-cityto.
      ENDAT.
      WRITE: /16 <fs_conn_int>-carrid, <fs_conn_int>-connid.
    ENDLOOP.

  ENDLOOP.
