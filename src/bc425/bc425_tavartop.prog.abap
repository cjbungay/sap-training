*&---------------------------------------------------------------------*
*& Include BC425_TAVARTOP
*&---------------------------------------------------------------------*

PROGRAM sapbc_global_transaction_model.

** CHANGE 01 to your (group number (##)

DATA agencynum LIKE bapisbdtin-agencynum VALUE '101'.

**


** Screen fields

DATA:  ok_code LIKE sy-ucomm,
       save_ok LIKE ok_code.

TABLES sdyn_conn.

CONSTANTS checked VALUE 'X'.
DATA  cities_initial VALUE checked.

DATA list_screen LIKE sy-dynnr.

* 100 - Input

DATA: rb_aa,
      rb_lh,
      rb_any VALUE checked.

* 200 - List via Table Control

CONTROLS: my_tc TYPE TABLEVIEW USING SCREEN 0200.

* 210 - List via Step Loop with automatic paging by ITS

DATA: line_first  LIKE sy-stepl,
      line_itab   LIKE line_first.

* 300 - Details

* 400 - Logon and Book

DATA: customernumber LIKE  bapiscdeta-id,
      password       LIKE  bapiuid-password.        "#EC NEEDED

** Internal tables and matching work area

DATA:  itab TYPE TABLE OF bapisflist,
       wa   TYPE bapisflist,
       my_flightdata TYPE bapisfdeta.
