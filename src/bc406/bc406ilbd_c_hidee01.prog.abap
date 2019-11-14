*----------------------------------------------------------------------*
*   INCLUDE BC406ILBD_C_HIDEE01                                        *
*----------------------------------------------------------------------*


START-OF-SELECTION.

  PERFORM read_connections.
  SORT it_spfli BY carrid connid.

END-OF-SELECTION.

  PERFORM display_connections.

* Initialisieren eines Testfeldes
* Initialzing test field
  CLEAR wa_spfli-carrid.

AT LINE-SELECTION.

* Überprüfen des Testfeldes
* Checking the test field
  CHECK NOT wa_spfli-carrid IS INITIAL.
  PERFORM read_flights.
  SORT it_sflight BY fldate.
  PERFORM display_flights.

* Initialisieren des Testfeldes
* Initialzing the test field
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

  FORMAT COLOR COL_HEADING.
  WRITE / 'Flüge'(t10).
  ULINE.
  WRITE AT: /(len_con) text-t01,
             (len_dat) 'Datum'(t11),
             (len_pri) 'Preis'(t12) CENTERED,
             (len_sea) 'maximal'(t13) RIGHT-JUSTIFIED,
             (len_sea) 'besetzt'(t14) RIGHT-JUSTIFIED.
