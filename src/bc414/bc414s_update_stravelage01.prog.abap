*----------------------------------------------------------------------*
*   INCLUDE BC414S_UPDATE_STRAVELAGE01                                 *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&   Event START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
* Read data from STRAVELAG into internal table ITAB_STRAVELAG
  PERFORM read_data USING itab_stravelag.
* Write data from ITAB_STRAVELAG on list
  PERFORM write_data.

*&---------------------------------------------------------------------*
*&   Event TOP-OF-PAGE
*&---------------------------------------------------------------------*
TOP-OF-PAGE.
* Write page title and page heading
  PERFORM write_header.

*&---------------------------------------------------------------------*
*&   Event END-OF-SELECTION
*&---------------------------------------------------------------------*
END-OF-SELECTION.
* Set PF-Status and Title of list
  SET PF-STATUS 'LIST'.
  SET TITLEBAR 'LIST'.

*&---------------------------------------------------------------------*
*&   Event AT USER-COMMAND
*&---------------------------------------------------------------------*
AT USER-COMMAND.
  CLEAR: modify_list, flag, itab_travel.
* Collect data corresponding to marked lines into internal table
  PERFORM loop_at_list USING itab_travel.
* Call screen if any line on list was marked
  CHECK NOT itab_travel IS INITIAL.
  PERFORM call_screen.
* Modify list buffer if database table was modified -> submit report
  CHECK NOT modify_list IS INITIAL.
  SUBMIT (sy-cprog).
