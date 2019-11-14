*&---------------------------------------------------------------------*
*& Include BC412_UDCS_EXERCISE_1TOP                                    *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc412_udct_exercise_1 MESSAGE-ID bc412
                                  NO STANDARD PAGE HEADING LINE-SIZE 80.

CONSTANTS c_sep(1) TYPE c VALUE ';'.

DATA:
* container:
  ref_cont_left  TYPE REF TO cl_gui_docking_container,
  ref_cont_right TYPE REF TO cl_gui_docking_container,

* content:
  ref_alv        TYPE REF TO cl_gui_alv_grid,
  ref_tree_model TYPE REF TO cl_simple_tree_model,

* node buffers for tree processing:
  it_nodes      TYPE treemsnota,
  undo_node_key TYPE tm_nodekey,

* for event registration:
  it_events TYPE cntl_simple_events,
  wa_event  LIKE LINE OF it_events,

* drag&drop-specific:
  wa_layout TYPE lvc_s_layo,

  ref_flav_src TYPE REF TO cl_dragdrop,
  ref_flav_trg TYPE REF TO cl_dragdrop,

  handle_src TYPE i,
  handle_trg TYPE i,



* application-data:
  it_scarr TYPE SORTED TABLE OF scarr
           WITH UNIQUE KEY carrid,
  it_spfli TYPE SORTED TABLE OF spfli
           WITH UNIQUE KEY carrid connid,
  it_sflight TYPE SORTED TABLE OF sflight
             WITH UNIQUE KEY carrid connid fldate,
  it_scustom TYPE STANDARD TABLE OF scustom
             WITH NON-UNIQUE KEY id,

  wa_scarr LIKE LINE OF it_scarr,
  wa_spfli LIKE LINE OF it_spfli,
  wa_sflight LIKE LINE OF it_sflight,
  wa_scustom LIKE LINE OF it_scustom,

* for itenarary list:
  wa_sbook TYPE sbook,
  arr_date TYPE sflight-fldate.



* subscreen content for screen 100:
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
SELECT-OPTIONS so_cust FOR wa_scustom-id.
SELECTION-SCREEN END OF SCREEN 1100.

* auxiliary for screen 100:
DATA:
  ok_code      TYPE sy-ucomm,
  copy_ok_code LIKE ok_code,
  l_answer     TYPE c,
  set_cust_old LIKE RANGE OF wa_scustom-id.
