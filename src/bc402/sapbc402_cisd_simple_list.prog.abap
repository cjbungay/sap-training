*&---------------------------------------------------------------------*
*& Report  SAPBC402_CISD_SIMPLE_LIST                                   *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  This program contains some bad programming techniques              *
*&  that should be found by the CODE INSPECTOR .                       *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc402_cisd_simple_list_opt.

DATA:
  wa_conn TYPE sdyn_conn,
  avg_occ TYPE sflight-seatsocc,
  carrid  TYPE spfli-carrid.

PARAMETERS:
  pa_carr TYPE sdyn_conn-carrid DEFAULT 'LH'.



AT SELECTION-SCREEN.
* What is missing here?
  AUTHORITY-CHECK OBJECT 'S_CARRID'
           ID 'CARRID' FIELD pa_carr
           ID 'ACTVT' FIELD '03'.



START-OF-SELECTION.

  FORMAT RESET.
  FORMAT COLOR COL_HEADING.
* What about translation ?
  WRITE: / 'Flight connections, selected by a JOIN-SELECT:'.
  FORMAT RESET.

* What has to be kept in mind when using an ABAP-Join ?
  SELECT * FROM spfli INNER JOIN scarr
           ON spfli~carrid = scarr~carrid
           INTO CORRESPONDING FIELDS OF WA_CONN
           WHERE spfli~carrid = pa_carr.

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
  WRITE: / 'Average number of occupied seats of carrier',
           pa_carr, ':'.
  FORMAT RESET.

* What has to be kept in mind when using aggregate functions ?
  SELECT AVG( seatsocc ) FROM sflight
                         INTO avg_occ
                         WHERE carrid = pa_carr
                         GROUP BY carrid.
    WRITE avg_occ.
  ENDSELECT.

  SKIP.
  FORMAT COLOR COL_HEADING.
  WRITE: / 'There are flights for the following carriers:'.
  FORMAT RESET.

* Obsolete statements
  SUMMARY.                                               "#EC *

* What has to be kept in mind when using the DISTINCT function ?
  SELECT DISTINCT carrid FROM spfli
                         INTO carrid.
    WRITE: / carrid.
  ENDSELECT.
