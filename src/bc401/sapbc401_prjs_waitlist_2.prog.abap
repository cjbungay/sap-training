*&---------------------------------------------------------------------*
*& Report  SAPBC401_PRJS_WAITLIST_2                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*& This report is similar to solution 1, except some log functions     *
*& There are some more pushbuttons to show Log-Info                    *
*& The log functionality is done using INTERFACE technique !           *
*&---------------------------------------------------------------------*

REPORT  SAPBC401_PRJS_WAITLIST_2.

INCLUDE SAPBC401_PRJS_INC_2.

DATA    ok_code LIKE sy-ucomm.
TABLES: sdyn_conn, scustom.

DATA: r_buffer TYPE REF TO lcl_buffer,
      r_customer TYPE REF TO lcl_customer,
      r_cust     TYPE REF TO lcl_customer,
      r_waitlist TYPE REF TO lcl_waitlist,
      r_log      TYPE REF TO lcl_log,
      r_exc      TYPE REF TO cx_root.

DATA r_if_status TYPE REF TO if_status.

DATA: waitlist TYPE TABLE OF REF TO lcl_customer.

DATA: wa_cust      TYPE bc401_typd_cust,
      it_wait_list TYPE bc401_typd_cust_list.

DATA: n_o_lines TYPE i,
      wa_sflight TYPE sflight,
      text TYPE string.


LOAD-OF-PROGRAM.
*###################################################

*** Instantiate the Buffer which is a singleton !
  r_buffer = lcl_buffer=>get_buffer_ref( ).


  CREATE OBJECT r_log.
  SET HANDLER r_log->get_cust FOR ALL INSTANCES.

  sdyn_conn-carrid = 'LH'.
  sdyn_conn-connid = '0400'.
  sdyn_conn-fldate = '20040710'.
  scustom-id = '00003392'.


START-OF-SELECTION.
*###################################################

  CALL SCREEN 100.

  INCLUDE sapbc401_prjs_waitlist_o02.
  INCLUDE sapbc401_prjs_waitlist_i02.
