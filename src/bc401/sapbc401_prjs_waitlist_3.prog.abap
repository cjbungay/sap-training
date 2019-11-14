*&---------------------------------------------------------------------*
*& Report  SAPBC401_PRJS_WAITLIST                                      *
*&---------------------------------------------------------------------*
*& This solution of the WAITINGLIST EXCERCISE works with public        *
*& READ-ONLY Attributes to get the coding smaller...and be quicker...  *
*&---------------------------------------------------------------------*

REPORT  SAPBC401_PRJS_WAITLIST_3.

INCLUDE SAPBC401_PRJS_WAITLIST_INC3.
*INCLUDE sapbc401_prjs_waitlist_inc.

DATA    ok_code LIKE sy-ucomm.
TABLES: sdyn_conn, scustom.

DATA: r_customer TYPE REF TO lcl_00_customer,
      r_cust     TYPE REF TO lcl_00_customer,
      r_waitlist TYPE REF TO cl_00_waitlist,
      r_log      TYPE REF TO cl_00_log,
      r_exc      TYPE REF TO cx_root.

DATA r_if_status TYPE REF TO if_taw10_status.

DATA: waitlist_buffer TYPE TABLE OF REF TO cl_00_waitlist,
      waitlist TYPE TABLE OF REF TO lcl_00_customer.

DATA: wa_cust      TYPE taw10_typd_cust,
      it_wait_list TYPE taw10_typd_cust_list.

DATA: n_o_lines TYPE i,
      wa_sflight TYPE sflight,
      text TYPE string.


LOAD-OF-PROGRAM.
*######################################
  CREATE OBJECT r_log.
  SET HANDLER r_log->get_cust FOR ALL INSTANCES.


START-OF-SELECTION.
*######################################
  CALL SCREEN 100.

INCLUDE SAPBC401_PRJS_INC_O03.
*  INCLUDE sapbc401_prjs_inc_o01.
INCLUDE SAPBC401_PRJS_INC_I03.
*  INCLUDE sapbc401_prjs_inc_i01.
