*&---------------------------------------------------------------------*
*& Report         SAPBC405_CALT_1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*


INCLUDE bc405_calt_1top                         .    " global Data

START-OF-SELECTION.
* retrieve data
  SELECT *
    FROM spfli
    INTO TABLE it_spfli
    WHERE carrid IN so_car
      AND connid IN so_con.

  CHECK sy-subrc EQ 0.
* create alv
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = r_alv
    CHANGING
      t_table        = it_spfli
         ).

* get the EVENTS object
  r_events = r_alv->get_event( ).

* get the SELECTIONS object
  r_selections = r_alv->get_selections( ).

* set the selection mode
  r_selections->set_selection_mode(
      value  = if_salv_c_selection_mode=>cell
         ).

* set customer defined GUI status
  r_alv->set_screen_status(
      report        = sy-cprog
      pfstatus      = 'UD_FULLSCREEN'
      set_functions = cl_salv_model_base=>c_functions_all
         ).
*** TO DO:
*     DEFINE AND IMPLEMENT YOUR HANDLER METHODS ***
*     REGISTRATE your methods (SET HANDLER) ***

* display it
  r_alv->display( ).
