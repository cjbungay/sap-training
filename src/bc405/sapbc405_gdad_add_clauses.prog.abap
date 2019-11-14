*&---------------------------------------------------------------------*
*& Report  SAPBC405_GDAD_OUTER_JOIN                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Add. clauses of the SELECT statement                               *
*&    GROUP BY, HAVING, ORDER BY                                       *
*&---------------------------------------------------------------------*

REPORT  sapbc405_gdad_outer_join.
* workarea for internal table
DATA: BEGIN OF wa_join,
        carrid TYPE spfli-carrid,
        connid TYPE spfli-connid,
        cityfrom TYPE spfli-cityfrom,
        cityto TYPE spfli-cityto,
        seatsmax TYPE sflight-seatsmax,
        seatsocc TYPE sflight-seatsocc,
        n_o_flights TYPE i,
      END OF wa_join,
* internal table
      it_join LIKE TABLE OF wa_join.

DATA: r_alv TYPE REF TO cl_salv_table,
      r_functions TYPE REF TO cl_salv_functions_list.

SELECT-OPTIONS:
  so_smax FOR wa_join-seatsmax,
  so_socc FOR wa_join-seatsocc.



START-OF-SELECTION.
* retrieve the join data
  SELECT
    spfli~carrid spfli~connid
    cityfrom cityto
    COUNT( * ) AS n_o_flights
    SUM( seatsmax ) AS seatsmax
    SUM( seatsocc ) AS seatsocc
    INTO CORRESPONDING FIELDS OF TABLE it_join
    FROM  spfli INNER JOIN sflight
    ON spfli~carrid = sflight~carrid
    AND spfli~connid = sflight~connid
    GROUP BY
      spfli~carrid spfli~connid
      cityfrom cityto
    HAVING SUM( seatsmax ) IN so_smax
        OR SUM( seatsocc ) IN so_socc
    ORDER BY seatsmax DESCENDING.

* create ALV
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = r_alv
    CHANGING
      t_table        = it_join
         ).

* add functionality:
* get the FUNCTIONS object
  r_functions = r_alv->get_functions( ).
* permit all
  r_functions->set_all( ).
* display it
  r_alv->display( ).
