*&---------------------------------------------------------------------*
*& Report  SAPBC401_PRJS_WAITLIST_1                                    *
*&---------------------------------------------------------------------*
*&  Solution : WAITLIST with object oriented programing                *
*&  A waitlist is used to buffer customers for specific flights.       *
*&  If there should be a seat left on a specific flight                *
*&  the registrated customer leaves the waitinglist and is booked      *
*&  on the flight.                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_prjs_waitlist_1.

INCLUDE sapbc401_prjs_inc_1.

DATA    ok_code LIKE sy-ucomm.
TABLES: sdyn_conn, scustom.

TYPES: ty_wait_list TYPE STANDARD TABLE OF REF TO lcl_waitlist.

DATA: r_buffer TYPE REF TO lcl_buffer,
      r_customer TYPE REF TO lcl_customer,
      r_waitlist TYPE REF TO lcl_waitlist,
      r_exc      TYPE REF TO cx_root.

DATA: wa_sflight TYPE sflight.

LOAD-OF-PROGRAM.
*###################################################

*** Instantiate the Buffer which is a singleton !
  r_buffer = lcl_buffer=>get_buffer_ref( ).

*** some dynpro initializations ***************
  sdyn_conn-carrid = 'LH'.
  sdyn_conn-connid = '0400'.
  sdyn_conn-fldate = '20040710'.
  scustom-id = '00003392'.


START-OF-SELECTION.
*###################################################

  CALL SCREEN 100.

  INCLUDE sapbc401_prjs_waitlist_o01.
  INCLUDE sapbc401_prjs_waitlist_i01.
