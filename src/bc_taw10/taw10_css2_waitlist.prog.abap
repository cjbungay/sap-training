*&---------------------------------------------------------------------*
*& Report  TAW10_CSS2_WAITLIST                                         *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  taw10_css2_waitlist                                       .


DATA    ok_code LIKE sy-ucomm.
TABLES: sdyn_conn, scustom.

DATA: r_customer TYPE REF TO cl_taw10_customer,
      r_cust     TYPE REF TO cl_taw10_customer,
      r_waitlist TYPE REF TO cl_taw10_waitlist,
      r_log      TYPE REF TO cl_taw10_log,
      r_exc      TYPE REF TO cx_root.

DATA r_if_status TYPE REF TO if_taw10_status.

DATA: waitlist_buffer TYPE TABLE OF REF TO cl_taw10_waitlist,
      waitlist TYPE TABLE OF REF TO cl_taw10_customer.

DATA: wa_cust      TYPE taw10_typd_cust,
      it_wait_list TYPE taw10_typd_cust_list.

DATA: n_o_lines TYPE i,
      wa_sflight TYPE sflight,
      text TYPE string.



LOAD-OF-PROGRAM.
  CREATE OBJECT r_log.
  SET HANDLER r_log->get_cust FOR ALL INSTANCES.


START-OF-SELECTION.


  CALL SCREEN 100.

  INCLUDE taw10_css2_waitlist_o01.
  INCLUDE taw10_css2_waitlist_i01.
