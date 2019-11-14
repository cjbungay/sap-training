*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_EXAMPLE_A2                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Template for instructors: List with flight connections and        *
*&                             name of carrier                         *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_example_a2                          .

CONSTANTS: actvt_display TYPE activ_auth VALUE '03',
           actvt_change  TYPE activ_auth VALUE '02'.

DATA  wa_flightconnection TYPE sbc400_connectn.


START-OF-SELECTION.

  SELECT * FROM sbc400_connectn
           INTO wa_flightconnection.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
          ID 'CARRID' FIELD wa_flightconnection-carrid
          ID 'ACTVT'  FIELD actvt_display.

    IF sy-subrc = 0.
      WRITE: / wa_flightconnection-carrid COLOR COL_KEY,
               wa_flightconnection-carrname COLOR COL_TOTAL,
               wa_flightconnection-connid COLOR COL_KEY,
               wa_flightconnection-airpfrom  COLOR COL_NORMAL,
               wa_flightconnection-cityfrom  COLOR COL_NORMAL,
               wa_flightconnection-countryfr COLOR COL_NORMAL,
               wa_flightconnection-airpto COLOR COL_NORMAL,
               wa_flightconnection-cityto COLOR COL_NORMAL,
               wa_flightconnection-countryto COLOR COL_NORMAL.
    ENDIF.

*   HIDE: wa_flightconnection-carrid,
*         wa_flightconnection-connid,
*         wa_flightconnection-carrname.

  ENDSELECT.

  CLEAR wa_flightconnection.


AT LINE-SELECTION.

* Step 2: reading single row from database table spfli and moving data
*         to TABLES-structure

* Step 1: calling the screen

* CLEAR wa_flightconnection.
