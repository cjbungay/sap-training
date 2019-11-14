*&---------------------------------------------------------------------*
*& Report  SAPBC401_PRJt_WAITLIST                                      *
*&---------------------------------------------------------------------*
*&  Template : WAITLIST with object oriented programing                *
*&  A waitlist is used to buffer customers for specific flights.       *
*&  If there should be a seat left on a specific flight                *
*&  the registrated customer leaves the waitinglist and is booked      *
*&  on the flight.                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_prjt_waitlist.

INCLUDE sapbc401_prjt_inc.

DATA    ok_code LIKE sy-ucomm.
TABLES: sdyn_conn, scustom.

DATA: wa_sflight TYPE sflight.

LOAD-OF-PROGRAM.
*###################################################

*** some dynpro initializations ***************
  sdyn_conn-carrid = 'LH'.
  sdyn_conn-connid = '0400'.
  sdyn_conn-fldate = '20040710'.
  scustom-id = '00003392'.


START-OF-SELECTION.
*###################################################

  CALL SCREEN 100.

  INCLUDE sapbc401_prjt_waitlist_o01.
  INCLUDE sapbc401_prjt_waitlist_i01.
