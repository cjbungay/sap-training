*----------------------------------------------------------------------*
*   INCLUDE   BC405_GDAD_FOR_ALL_ENTRIESTOP                            *
*----------------------------------------------------------------------*
REPORT  sapbc405gdad_e_for_all_entries .

TYPES:  BEGIN OF line_type_spfli,
          carrid LIKE spfli-carrid,
          connid LIKE spfli-connid,
          cityfrom LIKE spfli-cityfrom,
          airpfrom LIKE spfli-airpfrom,
          cityto LIKE spfli-cityto,
          airpto LIKE spfli-airpto,
          deptime LIKE spfli-deptime,
          arrtime LIKE spfli-arrtime,
        END OF line_type_spfli,

        BEGIN OF line_type_sflight,
          carrid LIKE sflight-carrid,
          connid LIKE sflight-connid,
          fldate LIKE sflight-fldate,
          seatsmax LIKE sflight-seatsmax,
          seatsocc LIKE sflight-seatsocc,
        END OF line_type_sflight.

DATA: itab_lines TYPE i,
      wa_spfli TYPE line_type_spfli,
      wa_sflight TYPE line_type_sflight,

      itab_spfli TYPE TABLE OF line_type_spfli,
      itab_sflight TYPE TABLE OF line_type_sflight.


SELECT-OPTIONS: so_cityf FOR wa_spfli-cityfrom NO INTERVALS
                NO-EXTENSION DEFAULT 'FRANKFURT',
                so_cityt FOR wa_spfli-cityto NO INTERVALS
                NO-EXTENSION DEFAULT 'NEW YORK'.
