class CL_BC412_PICTURE_1 definition
  public
  final
  create public .

*"* public components of class CL_BC412_PICTURE_1
*"* do not include other source files here!!!
public section.

  constants C_TRUE type BC412_TEXT1 value 'X' .
  constants C_FALSE type BC412_TEXT1 value ' ' .

  events PICTURE_CLICK
    exporting
      value(MOUSE_POS_X) type I
      value(MOUSE_POS_Y) type I .

  methods CONSTRUCTOR
    importing
      !I_PARENT type ref to CL_GUI_CONTAINER
      value(I_URL) type BAPIURI-URI
      value(I_PICTURE_CLICK) type BC412_TEXT1 default 'X'
      value(I_APPL_EVENT_PC) type BC412_TEXT1 default 'X'
      value(I_STRETCH_TEXT) type GUI_TEXT default 'STRETCH'
      value(I_FIT_TEXT) type GUI_TEXT default 'FIT'
      value(I_NORMAL_TEXT) type GUI_TEXT default 'NORMAL'
      value(I_FIT_CENTER_TEXT) type GUI_TEXT default 'FIT_CENTER'
      value(I_NORMAL_CENTER_TEXT) type GUI_TEXT default 'NORMAL_CENTER'
    exceptions
      PICTURE_ERROR
      PICTURE_LOAD_ERROR .
  methods FREE
    exceptions
      PICTURE_ERROR .
  type-pools CNTL .
protected section.
*"* protected components of class CL_BC412_PICTURE_1
*"* do not include other source files here!!!

  data CONTEXT_MENU_REF type ref to CL_CTMENU .
  data PICTURE_REF type ref to CL_GUI_PICTURE .
  data URL type BAPIURI-URI .
  data IT_FUNCTION type BC412_FUNCTION_ITT .

  methods ON_PICTURE_CLICK
    for event PICTURE_CLICK of CL_GUI_PICTURE
    importing
      !SENDER
      !MOUSE_POS_X
      !MOUSE_POS_Y .
  methods ON_CONTEXT_MENU
    for event CONTEXT_MENU of CL_GUI_PICTURE
    importing
      !SENDER .
  methods ON_CONTEXT_MENU_SELECTED
    for event CONTEXT_MENU_SELECTED of CL_GUI_PICTURE
    importing
      !FCODE
      !SENDER .
private section.
*" private components of class CL_BC412_PICTURE_1
*" do not include other source files here!!!

ENDCLASS.



CLASS CL_BC412_PICTURE_1 IMPLEMENTATION.


METHOD constructor.
* local data
  DATA:
    l_events    TYPE cntl_simple_events,
    l_wa_events LIKE LINE OF l_events,
    wa_function LIKE LINE OF it_function.

* create picture object
  CREATE OBJECT picture_ref
    EXPORTING
*       LIFETIME   =
*       SHELLSTYLE =
      parent     = i_parent
    EXCEPTIONS
      error = 1.

  IF sy-subrc NE 0.
    RAISE picture_error.
  ENDIF.

* send picture to picture control
  CALL METHOD picture_ref->load_picture_from_url
    EXPORTING
      url    = i_url
*       RESULT =
    EXCEPTIONS
      error = 1.

  IF sy-subrc NE 0.
    RAISE picture_load_error.
  ENDIF.

* register events:
  IF i_picture_click = c_true.
*   picture_click
    l_wa_events-eventid    = cl_gui_picture=>eventid_picture_click.
    l_wa_events-appl_event = i_appl_event_pc.
    INSERT l_wa_events INTO TABLE l_events.
  ENDIF.
*   context_menu
  l_wa_events-eventid    = cl_gui_picture=>eventid_context_menu.
  l_wa_events-appl_event = ' '.
  INSERT l_wa_events INTO TABLE l_events.
*   context_menu_selected
  l_wa_events-eventid    =
                     cl_gui_picture=>eventid_context_menu_selected.
  l_wa_events-appl_event = ' '.
  INSERT l_wa_events INTO TABLE l_events.

  CALL METHOD picture_ref->set_registered_events
    EXPORTING
      events = l_events
    EXCEPTIONS
      cntl_error                = 1
      cntl_system_error         = 2
      illegal_event_combination = 3.
  IF sy-subrc NE 0.
*     to implement
  ENDIF.

  SET HANDLER on_picture_click         FOR picture_ref.
  SET HANDLER on_context_menu          FOR picture_ref.
  SET HANDLER on_context_menu_selected FOR picture_ref.
*   store url of picture
  url = i_url.
*   construct context menu functions in it_functions
  wa_function-fcode = 'STRETCH'.
  wa_function-text  =  i_stretch_text.
  INSERT wa_function INTO TABLE it_function.        " 1.

  wa_function-fcode = 'FIT'.
  wa_function-text  =  i_fit_text.
  INSERT wa_function INTO TABLE it_function.        " 2.

  wa_function-fcode = 'NORMAL'.
  wa_function-text  =  i_normal_text.
  INSERT wa_function INTO TABLE it_function.        " 3.

  wa_function-fcode = 'FIT_CENTER'.
  wa_function-text  =  i_fit_center_text.
  INSERT wa_function INTO TABLE it_function.         " 4.

  wa_function-fcode = 'NORMAL_CENTER'.
  wa_function-text  =  i_normal_center_text.
  INSERT wa_function INTO TABLE it_function.         " 5.

ENDMETHOD.


METHOD free.
  CALL METHOD picture_ref->free
    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2.

  IF sy-subrc NE 0.
    RAISE picture_error.
  ENDIF.
ENDMETHOD.


METHOD on_context_menu.
* local data
  DATA: wa_function LIKE LINE OF it_function.

* create context menu object
  CREATE OBJECT context_menu_ref.

* create dynamic context menu
  LOOP AT it_function INTO wa_function.
    CALL METHOD context_menu_ref->add_function
      EXPORTING
        fcode = wa_function-fcode
        text  = wa_function-text.
  ENDLOOP.

* display context menu
  CALL METHOD sender->display_context_menu
    EXPORTING
      context_menu = context_menu_ref
    EXCEPTIONS
      error = 1.

  FREE context_menu_ref.
ENDMETHOD.


METHOD on_context_menu_selected.
* local data
  DATA: l_display_mode TYPE i.

  CASE fcode.
    WHEN 'STRETCH'.
      l_display_mode = cl_gui_picture=>display_mode_stretch.
    WHEN 'FIT'.
      l_display_mode = cl_gui_picture=>display_mode_fit.
    WHEN 'NORMAL'.
      l_display_mode = cl_gui_picture=>display_mode_normal.
    WHEN 'FIT_CENTER'.
      l_display_mode = cl_gui_picture=>display_mode_fit_center.
    WHEN 'NORMAL_CENTER'.
      l_display_mode = cl_gui_picture=>display_mode_normal_center.
  ENDCASE.

  CALL METHOD sender->set_display_mode
    EXPORTING
      display_mode = l_display_mode
    EXCEPTIONS
      error = 1.

*    IF sy-subrc NE 0.
*      RAISE error.
*    ENDIF.

ENDMETHOD.


METHOD on_picture_click.
  RAISE EVENT picture_click
    EXPORTING
      mouse_pos_x = mouse_pos_x
      mouse_pos_y = mouse_pos_y.
ENDMETHOD.
ENDCLASS.
