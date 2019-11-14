*----------------------------------------------------------------------*
*   INCLUDE BC406ILSD_A_MULTI_SEL_PREE01                               *
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM read_connections.
  SORT it_spfli BY carrid connid.

END-OF-SELECTION.

  PERFORM display_connections.

  time_toggle = 'Time Off'(g01).

  SET TITLEBAR 'BASE'.
  SET PF-STATUS 'BASE'.

  CLEAR wa_spfli-carrid.

AT LINE-SELECTION.

  CHECK NOT wa_spfli-carrid IS INITIAL.
  PERFORM read_flights.
  SORT it_sflight BY fldate.
  PERFORM display_flights.

  SET TITLEBAR 'FLIGHTS' WITH wa_spfli-carrid wa_spfli-connid.
  SET PF-STATUS 'FLIGHTS'.

  CLEAR wa_spfli-carrid.

TOP-OF-PAGE.

  FORMAT COLOR COL_HEADING.
  WRITE / 'Flight Connections'(t00).
  ULINE.
  WRITE AT: /(len_con) 'Flights'(t01),
             (len_cit) 'Departure'(t02),
             (len_cit) 'Arrival'(t03),
             (len_tim) 'Departs'(t04),
             (len_tim) 'Arrives'(t05).
  ULINE.

TOP-OF-PAGE DURING LINE-SELECTION.

  CASE sy-ucomm.

    WHEN 'SORT_CAR' OR 'SORT_CON' OR 'TIME_TOG'.
      FORMAT COLOR COL_HEADING.
      WRITE / 'Flight Connections'(t00).
      ULINE.
      WRITE AT: /(len_con) 'Flights'(t01),
                 (len_cit) 'Departure'(t02),
                 (len_cit) 'Arrival'(t03),
                 (len_tim) 'Departs'(t04),
                 (len_tim) 'Arrives'(t05).
      ULINE.

    WHEN 'SORT_OCC' OR 'PICK'.
      FORMAT COLOR COL_HEADING.
      WRITE / 'Flight Details'(t10).
      ULINE.
      WRITE AT: /(len_con) text-t01,
                 (len_dat) 'Date'(t11),
                 (len_pri) 'Price'(t12) CENTERED,
                 (len_sea) 'Maximum'(t13) RIGHT-JUSTIFIED,
                 (len_sea) 'Occupied'(t14) RIGHT-JUSTIFIED.

  ENDCASE.

AT USER-COMMAND.

  CASE sy-ucomm.
    WHEN 'SORT_CAR'.
      SORT it_spfli BY carrid.
      PERFORM display_connections.
      time_toggle = 'Time Off'(g01).
      SET PF-STATUS 'BASE' EXCLUDING 'SORT_CAR'.
    WHEN 'SORT_CON'.
      SORT it_spfli BY connid.
      PERFORM display_connections.
      time_toggle = 'Time Off'(g01).
      SET PF-STATUS 'BASE' EXCLUDING 'SORT_CON'.
    WHEN 'SORT_OCC'.
      SORT it_sflight BY seatsocc.
      PERFORM display_flights.
      SET PF-STATUS 'FLIGHTS' EXCLUDING 'SORT_OCC'.
    WHEN 'TIME_TOG'.
      IF time_toggle = text-g01.
        time_toggle = 'Zeiten einblenden'(g02).
        PERFORM display_connections_wo_time.
      ELSE.
        time_toggle = text-g01.
        PERFORM display_connections.
      ENDIF.
      SET PF-STATUS 'BASE'.
  ENDCASE.
