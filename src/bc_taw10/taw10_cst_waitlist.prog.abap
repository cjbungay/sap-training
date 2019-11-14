*&---------------------------------------------------------------------*
*& Report  TAW10_CST_WAITLIST                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  taw10_cst_waitlist                                       .

DATA    ok_code LIKE sy-ucomm.
DATA    wa_sflight TYPE sflight.

TABLES: sdyn_conn, scustom.



START-OF-SELECTION.


  CALL SCREEN 100.

  INCLUDE taw10_cst_waitlist_o01.
  INCLUDE taw10_cst_waitlist_i01.
