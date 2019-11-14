*&---------------------------------------------------------------------*
*& Report  SAPBC430_FLIGHTS                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  Data selection using a database view from the hierarchical tables  *
*&                 scarr (alias a)                                     *
*&                 spfli (alias b)                                     *
*&                 sflight (alias c)                                   *
*&---------------------------------------------------------------------*

REPORT  sapbc430_flights.

TYPES: BEGIN OF line_type_flights,
        carrid LIKE scarr-carrid,
        carrname LIKE scarr-carrname,
        connid LIKE spfli-connid,
        cityfrom LIKE spfli-cityfrom,
        cityto   LIKE spfli-cityto,
        fldate LIKE sflight-fldate,
        seatsmax LIKE sflight-seatsmax,
        seatsocc LIKE sflight-seatsocc,
       END OF line_type_flights.

DATA: wa_flights TYPE line_type_flights,
      itab_flights TYPE TABLE OF line_type_flights.

SELECT-OPTIONS: so_cityf FOR wa_flights-cityfrom  NO INTERVALS
                NO-EXTENSION DEFAULT 'FRANKFURT',
                so_cityt FOR wa_flights-cityto  NO INTERVALS
                NO-EXTENSION DEFAULT 'NEW YORK'.

START-OF-SELECTION.
 SELECT carrid carrname connid cityfrom cityto fldate seatsmax seatsocc
   INTO TABLE itab_flights
    FROM sv_flights
     WHERE cityfrom IN so_cityf
     AND   cityto   IN so_cityt
     AND   seatsocc < sv_flights~seatsmax
    ORDER BY carrid connid fldate.

  PERFORM data_output.

*----------------------------------------------------------------------*
*   INCLUDE   BC405_GDAD_DB_VIEWF01                                    *
*----------------------------------------------------------------------*

FORM data_output.
  DATA pos TYPE i VALUE 40.
  LOOP AT itab_flights INTO wa_flights.
    ON CHANGE OF wa_flights-cityfrom.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE: / sy-vline, text-001, wa_flights-cityfrom,
               AT pos sy-vline,
             / sy-vline, text-002, wa_flights-cityto,
                  AT pos sy-vline.
    ENDON.

    ON CHANGE OF wa_flights-carrid.
      FORMAT COLOR COL_NORMAL INTENSIFIED ON.
      WRITE: / sy-vline, wa_flights-carrid, wa_flights-carrname,
               AT pos sy-vline.
    ENDON.
    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.
    WRITE: / sy-vline, wa_flights-connid, wa_flights-fldate,
             wa_flights-seatsmax, wa_flights-seatsocc, AT pos sy-vline.
  ENDLOOP.

ENDFORM.
