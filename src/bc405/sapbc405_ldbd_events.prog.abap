*&---------------------------------------------------------------------*
*& Report  SAPBC405LDBD_C_LDB                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Demo: events for a logical database                               *
*&---------------------------------------------------------------------*

REPORT  sapbc405ldbd_c_ldb            .

NODES: spfli, sflight, sbook.

INITIALIZATION.
  MOVE 'DL' TO carrid-low.
  MOVE  'I' TO carrid-sign.
  MOVE 'EQ' TO carrid-option.
  APPEND carrid.

START-OF-SELECTION.
  FORMAT COLOR COL_TOTAL.
  WRITE:  / 'START-OF-SELECTION'.
  SKIP 1.

END-OF-SELECTION.
  FORMAT COLOR COL_TOTAL.
  WRITE:  / 'END-OF-SELECTION'.
  SKIP 1.

GET spfli.
  WRITE: /(9) 'GET SPFLI' COLOR COL_HEADING INTENSIFIED .
  FORMAT RESET.
  WRITE: 27   spfli-carrid,
              spfli-connid.

GET sflight.
  WRITE: /9(11) 'GET SFLIGHT' COLOR COL_GROUP INTENSIFIED OFF.
  FORMAT RESET.
  WRITE: 34 sflight-fldate.


GET sbook.
  WRITE: /19(9) 'GET SBOOK' COLOR COL_NORMAL INTENSIFIED  .
  FORMAT RESET.
  WRITE: 43 sbook-bookid .

GET sflight LATE.
  WRITE: /9(16) 'GET SFLIGHT LATE' COLOR COL_GROUP INTENSIFIED OFF.

GET spfli LATE.
  WRITE: /(14) 'GET SPFLI LATE' COLOR COL_HEADING INTENSIFIED.
