*&-----------------------------------------------
*& Report         SAPBC405_CALS_1
*&
*&-----------------------------------------------
*& Solution: Calling Programs
*&-----------------------------------------------

INCLUDE: bc405_cals_1top,
         bc405_cals_1k01.

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

* set handler
  SET HANDLER:
    lcl_handler=>on_double_click FOR r_events,
    lcl_handler=>on_added_function FOR r_events.

* display it
  r_alv->display( ).
