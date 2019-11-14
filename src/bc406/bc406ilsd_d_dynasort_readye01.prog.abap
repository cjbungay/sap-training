*----------------------------------------------------------------------*
*   INCLUDE BC406ILSD_D_DYNASORT_READYE01                             *
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

*  CHECK NOT wa_spfli-carrid IS INITIAL.

  REFRESH it_sflight.
  DO.
    READ LINE sy-index FIELD VALUE mark.
    IF sy-subrc <> 0. EXIT. ENDIF.
    CHECK NOT mark IS INITIAL.
    PERFORM read_flights.
    APPEND LINES OF it_sflight_read TO it_sflight.
    MODIFY CURRENT LINE FIELD VALUE mark FROM space.
  ENDDO.


  SORT it_sflight BY carrid connid fldate.
  PERFORM display_flights.

  SET TITLEBAR 'FLIGHTS'.
  SET PF-STATUS 'FLIGHTS'.

  CLEAR wa_spfli-carrid.

TOP-OF-PAGE.

  FORMAT COLOR COL_HEADING.
  WRITE /3 'Flight Connections'(t00).
  ULINE.
  WRITE AT: /3(len_con) 'Flight'(t01),
             (len_cit) 'Departure'(t02),
             (len_cit) 'Arrival'(t03),
             (len_tim) 'Departs'(t04),
             (len_tim) 'Arrives'(t05).
  ULINE.

TOP-OF-PAGE DURING LINE-SELECTION.

  CASE sy-ucomm.

    WHEN 'SORT_CAR' OR 'SORT_CON' OR 'TIME_TOG'.
      FORMAT COLOR COL_HEADING.
      WRITE /3 'Flight Connections'(t00).
      ULINE.
      WRITE AT: /3(len_con) 'Flight'(t01),
                 (len_cit) 'Departure'(t02),
                 (len_cit) 'Arrival'(t03),
                 (len_tim) 'Departs'(t04),
                 (len_tim) 'Arrives'(t05).
      ULINE.

    WHEN 'SRTD' OR 'SRTU' OR 'PICK'.
      FORMAT COLOR COL_HEADING.
      WRITE /3 'Flight Details'(t10).
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
    WHEN 'SRTU'.
      PERFORM get_sortfield USING sortfield.
      SORT it_sflight BY carrid connid (sortfield).
      PERFORM display_flights.
      SET PF-STATUS 'FLIGHTS'..
    WHEN 'SRTD'.
      PERFORM get_sortfield USING sortfield.
      SORT it_sflight BY carrid connid (sortfield) DESCENDING.
      PERFORM display_flights.
      SET PF-STATUS 'FLIGHTS'..
    WHEN 'TIME_TOG'.
      IF time_toggle = text-g01.
        time_toggle = 'Time On'(g02).
        PERFORM display_connections_wo_time.
      ELSE.
        time_toggle = text-g01.
        PERFORM display_connections.
      ENDIF.
      SET PF-STATUS 'BASE'.
  ENDCASE.

* Ausgabe geänderter Listen auf der gleichen Listenstufe
* list output of changed lists on the same list level
  sy-lsind = sy-lsind - 1.
