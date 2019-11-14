*&---------------------------------------------------------------------*
*& Report  SAPBC401_PRJS_WAITLIST                                      *
*&---------------------------------------------------------------------*
*& This solution of the WAITINGLIST EXCERCISE works with public        *
*& READ-ONLY Attributes to get the coding smaller...and be quicker...  *
*&---------------------------------------------------------------------*

REPORT  SAPBC401_PRJS_WAITLIST.

INCLUDE sapbc401_prjs_waitlist_inc.

DATA    ok_code LIKE sy-ucomm.
TABLES: sdyn_conn, scustom.

DATA: r_customer TYPE REF TO lcl_00_customer,
      r_cust     TYPE REF TO lcl_00_customer,
      r_waitlist TYPE REF TO lcl_00_waitlist,
      r_exc      TYPE REF TO cx_root.

DATA: buffer_list TYPE TABLE OF REF TO lcl_00_waitlist,
      waitlist TYPE TABLE OF REF TO lcl_00_customer.

DATA: wa_cust      TYPE bc401_typd_cust,
      it_wait_list TYPE bc401_typd_cust_list.

DATA: n_o_lines TYPE i,
      wa_sflight TYPE sflight,
      text TYPE string.

LOAD-OF-PROGRAM.
*######################
  sdyn_conn-carrid = 'LH'.
  sdyn_conn-connid = '0400'.
  sdyn_conn-fldate = '20040710'.

  scustom-id = '00000001'.


START-OF-SELECTION.
*######################################
  CALL SCREEN 100.

  INCLUDE sapbc401_prjs_inc_o01.
  INCLUDE sapbc401_prjs_inc_i01.
