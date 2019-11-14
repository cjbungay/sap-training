*----------------------------------------------------------------------*
*   INCLUDE ZBC412_PICTURE_CONTROL_1LCL                                *
*----------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       CLASS lcl_picture DEFINITION
*---------------------------------------------------------------------*
*       Class definition for a picture control + context menue        *
*       construction and handling. Class covers both functions.       *
*       Class handles display mode of picture control itself and      *
*       raises events PICTURE_CLICK and PICTURE_DBLCLICK if the       *
*       picture control object raises the corresponding events.       *
*       Severat texts (displayed in the context menue) have to be     *
*       transfered to the instance of this class via the constructor. *
*---------------------------------------------------------------------*
CLASS lcl_picture DEFINITION.
  PUBLIC SECTION.
    EVENTS:
      picture_click,
      picture_dblclick.

    METHODS:
      constructor
        IMPORTING
          i_parent              TYPE REF TO cl_gui_container
          i_url                 TYPE url_type
          i_stretch_text1       TYPE gui_text
          i_fit_text2           TYPE gui_text
          i_normal_text3        TYPE gui_text
          i_fit_center_text4    TYPE gui_text
          i_normal_center_text5 TYPE gui_text
        EXCEPTIONS
          picture_error
          picture_load_error,
*     ------------------------------------------------------------------
      free
        EXCEPTIONS
          picture_error.

  PRIVATE SECTION.
* private types
    TYPES: BEGIN OF function_type,
             fcode TYPE ui_func,
             text  TYPE gui_text,
           END OF function_type.
* private data
    DATA:
* object references
      my_picture        TYPE REF TO cl_gui_picture,
      my_picture_ctmenu TYPE REF TO cl_ctmenu,
* other
      url          TYPE url_type,
      it_function  TYPE STANDARD TABLE OF function_type,
      wa_function  LIKE LINE OF it_function.
* private methods
    METHODS:
      on_picture_click    FOR EVENT picture_click OF cl_gui_picture
        IMPORTING
          sender,
*     ------------------------------------------------------------------
      on_picture_dblclick FOR EVENT picture_dblclick OF
                                       cl_gui_picture
        IMPORTING
          sender,
*     ------------------------------------------------------------------
      on_context_menu     FOR EVENT context_menu OF cl_gui_picture
        IMPORTING
          sender,
*     ------------------------------------------------------------------
      on_context_menu_selected FOR EVENT context_menu_selected
                                      OF cl_gui_picture
        IMPORTING
          fcode
          sender.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_picture IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_picture IMPLEMENTATION.
  METHOD constructor.
* local data
    DATA:
      l_events    TYPE cntl_simple_events,
      l_wa_events LIKE LINE OF l_events.

* create picture object
    CREATE OBJECT my_picture
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
    CALL METHOD my_picture->load_picture_from_url
      EXPORTING
        url    = i_url
*       RESULT =
      EXCEPTIONS
        error = 1.

    IF sy-subrc NE 0.
      RAISE picture_load_error.
    ENDIF.

* register events:
*   picture_click
    l_wa_events-eventid    = cl_gui_picture=>eventid_picture_click.
    l_wa_events-appl_event = 'X'.
    INSERT l_wa_events INTO TABLE l_events.
*   picture_dblclick
    l_wa_events-eventid    = cl_gui_picture=>eventid_picture_dblclick.
    l_wa_events-appl_event = 'X'.
    INSERT l_wa_events INTO TABLE l_events.
*   context_menu
    l_wa_events-eventid    = cl_gui_picture=>eventid_context_menu.
    l_wa_events-appl_event = ' '.
    INSERT l_wa_events INTO TABLE l_events.
*   context_menu_selected
    l_wa_events-eventid    =
                       cl_gui_picture=>eventid_context_menu_selected.
    l_wa_events-appl_event = ' '.
    INSERT l_wa_events INTO TABLE l_events.

    CALL METHOD my_picture->set_registered_events
      EXPORTING
        events = l_events
      EXCEPTIONS
        cntl_error                = 1
        cntl_system_error         = 2
        illegal_event_combination = 3.
    IF sy-subrc NE 0.
*     to implement
    ENDIF.

    SET HANDLER me->on_picture_click         FOR my_picture.
    SET HANDLER me->on_picture_dblclick      FOR my_picture.
    SET HANDLER me->on_context_menu          FOR my_picture.
    SET HANDLER me->on_context_menu_selected FOR my_picture.
*   store url of picture
    url = i_url.
*   construct context menu functions in it_functions
    wa_function-fcode = 'STRETCH'.
    wa_function-text  =  i_stretch_text1.
    INSERT wa_function INTO TABLE it_function.        " 1.

    wa_function-fcode = 'FIT'.
    wa_function-text  =  i_fit_text2.
    INSERT wa_function INTO TABLE it_function.        " 2.

    wa_function-fcode = 'NORMAL'.
    wa_function-text  =  i_normal_text3.
    INSERT wa_function INTO TABLE it_function.        " 3.

    wa_function-fcode = 'FIT_CENTER'.
    wa_function-text  =  i_fit_center_text4.
    INSERT wa_function INTO TABLE it_function.         " 4.

    wa_function-fcode = 'NORMAL_CENTER'.
    wa_function-text  =  i_normal_center_text5.
    INSERT wa_function INTO TABLE it_function.         " 5.

  ENDMETHOD.
* ----------------------------------------------------------------------
  METHOD free.
    CALL METHOD my_picture->free
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2.

    IF sy-subrc NE 0.
      RAISE picture_error.
    ENDIF.

  ENDMETHOD.
* ----------------------------------------------------------------------
  METHOD on_picture_click.
    RAISE EVENT picture_click.
  ENDMETHOD.
* ----------------------------------------------------------------------
  METHOD on_picture_dblclick.
    RAISE EVENT picture_dblclick.
  ENDMETHOD.
* ----------------------------------------------------------------------
  METHOD on_context_menu.
*   create context menu object
    CREATE OBJECT my_picture_ctmenu.

*   create dynamic context menu
    LOOP AT it_function INTO wa_function.
      CALL METHOD my_picture_ctmenu->add_function
        EXPORTING
          fcode = wa_function-fcode
          text  = wa_function-text.
    ENDLOOP.

*   display context menu
    CALL METHOD sender->display_context_menu
      EXPORTING
        context_menu = my_picture_ctmenu
      EXCEPTIONS
        error = 1.

    FREE my_picture_ctmenu.
  ENDMETHOD.
* ----------------------------------------------------------------------
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
ENDCLASS.
