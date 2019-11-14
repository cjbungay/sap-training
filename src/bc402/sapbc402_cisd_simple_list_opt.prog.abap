*&---------------------------------------------------------------------*
*& Report  SAPBC402_CISD_SIMPLE_LIST_OPT                               *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  Corrected and optimized version of SAPBC402_CISD_SIMPLE_LIST       *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc402_cisd_simple_list_opt.

DATA:
  wa_conn TYPE sdyn_conn,
  occ     TYPE sflight-seatsocc,
  avg_occ LIKE occ,
  carrid  TYPE spfli-carrid,

  it_carrid TYPE STANDARD TABLE OF spfli-carrid
            WITH NON-UNIQUE KEY table_line
            INITIAL SIZE 20.

PARAMETERS:
  pa_carr TYPE sdyn_conn-carrid DEFAULT 'LH'.



AT SELECTION-SCREEN.
  AUTHORITY-CHECK OBJECT 'S_CARRID'
           ID 'CARRID' FIELD pa_carr
           ID 'ACTVT' FIELD '03'.
* Return code handling added
  IF sy-subrc <> 0.
    MESSAGE e204(bc402) WITH pa_carr.
  ENDIF.



START-OF-SELECTION.

  FORMAT RESET.
  FORMAT COLOR COL_HEADING.
* Translation possible using text symbols
  WRITE: / 'Flight connections, selected by a JOIN-SELECT:'(cjs).
  FORMAT RESET.

* Select from a view that can be buffered
  SELECT * FROM bc402_cisd_fli
           INTO CORRESPONDING FIELDS OF wa_conn
           WHERE carrid = pa_carr.

    WRITE: / wa_conn-carrname,
             wa_conn-carrid,
             wa_conn-connid,
             wa_conn-cityfrom,
             wa_conn-cityto,
             wa_conn-deptime,
             wa_conn-arrtime.

  ENDSELECT.

  SKIP.
  FORMAT COLOR COL_HEADING.
  WRITE: / 'Average number of occupied seats of carrier'(aos),
           pa_carr, ':'.
  FORMAT RESET.

* Calculating the average value without using the AVG function
  SELECT seatsocc FROM sflight INTO occ
                  WHERE carrid = pa_carr.
    avg_occ = avg_occ + occ.
  ENDSELECT.

  IF sy-subrc = 0.
    avg_occ = avg_occ / sy-dbcnt.
  ENDIF.

  WRITE avg_occ.
  SKIP.
  FORMAT COLOR COL_HEADING.
  WRITE: / 'There are flights for the following carriers:'(car).
  FORMAT RESET.

* Implementing the DISTINCT function using internal table processing
  SELECT carrid FROM spfli INTO TABLE it_carrid.
  IF sy-subrc = 0.
    SORT it_carrid BY table_line.
    DELETE ADJACENT DUPLICATES FROM it_carrid.
    LOOP AT it_carrid INTO carrid.
      WRITE: / carrid.
    ENDLOOP.
  ENDIF.
