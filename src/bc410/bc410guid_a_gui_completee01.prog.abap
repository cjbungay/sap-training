*----------------------------------------------------------------------*
*   INCLUDE BC410GUID_A_GUI_READYE01                                   *
*----------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM read_connections.
  SORT it_spfli BY carrid connid.

END-OF-SELECTION.

  PERFORM display_connections.

* Dynamischen Funktionstext setzen
* Set dynamical function
  time_toggle = 'Zeiten ausblenden'(g01).

* Titel setzen
* Set title
  SET TITLEBAR 'BASE'.

* Status setzen
* Set status
  SET PF-STATUS 'BASE'.

  CLEAR wa_spfli-carrid.

AT LINE-SELECTION.

  CHECK NOT wa_spfli-carrid IS INITIAL.
  PERFORM read_flights.
  SORT it_sflight BY fldate.
  PERFORM display_flights.

* Titel setzen
* Set title
  SET TITLEBAR 'FLIGHTS' WITH wa_spfli-carrid wa_spfli-connid.

* Status setzen
* Set status
  SET PF-STATUS 'FLIGHTS'.



  CLEAR wa_spfli-carrid.

TOP-OF-PAGE.

  FORMAT COLOR COL_HEADING.
  WRITE / 'Flugverbindungen'(t00).
  ULINE.
  WRITE AT: /(len_con) 'Flug'(t01),
             (len_cit) 'Abflugsort'(t02),
             (len_cit) 'Ankunftsort'(t03),
             (len_tim) 'Abflug'(t04),
             (len_tim) 'Ankunft'(t05).
  ULINE.

TOP-OF-PAGE DURING LINE-SELECTION.

  CASE sy-ucomm.

    WHEN 'SORT_CAR' OR 'SORT_CON' OR 'TIME_TOG'.
      FORMAT COLOR COL_HEADING.
      WRITE / 'Flugverbindungen'(t00).
      ULINE.
      WRITE AT: /(len_con) 'Flug'(t01),
                 (len_cit) 'Abflugsort'(t02),
                 (len_cit) 'Ankunftsort'(t03),
                 (len_tim) 'Abflug'(t04),
                 (len_tim) 'Ankunft'(t05).
      ULINE.

    WHEN 'SORT_OCC' OR 'PICK'.
      FORMAT COLOR COL_HEADING.
      WRITE / 'Flüge'(t10).
      ULINE.
      WRITE AT: /(len_con) text-t01,
                 (len_dat) 'Datum'(t11),
                 (len_pri) 'Preis'(t12) CENTERED,
                 (len_sea) 'maximal'(t13) RIGHT-JUSTIFIED,
                 (len_sea) 'besetzt'(t14) RIGHT-JUSTIFIED.

  ENDCASE.

AT USER-COMMAND.

*   time_toggle = sy-ucomm.
  CASE sy-ucomm.
    WHEN 'SORT_CAR'.
      SORT it_spfli BY carrid.
      PERFORM display_connections.
      SET PF-STATUS 'BASE' EXCLUDING 'SORT_CAR'.
    WHEN 'SORT_CON'.
      SORT it_spfli BY connid.
      PERFORM display_connections.
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


