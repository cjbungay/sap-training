*&---------------------------------------------------------------------*
*& Report  SAPBC412_CMUS_EXERCISE1                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Two pictures are displayed using a splitter container.              *
*& Functions for changing the picture display mode are offered in a    *
*& Context Menu.                                                       *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cmus_exercise1 MESSAGE-ID bc412.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       Definition of a local class containing event handler methods  *
*       for picture control objects                                   *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_picture_click
         FOR EVENT picture_click OF cl_gui_picture
         IMPORTING mouse_pos_x mouse_pos_y,
*     ------------------------------------------------------------------
      on_control_dblclick
         FOR EVENT control_dblclick OF cl_gui_picture
         IMPORTING mouse_pos_x mouse_pos_y,
*     ------------------------------------------------------------------
      on_context_menu
         FOR EVENT context_menu OF cl_gui_picture
         IMPORTING sender,
*     ------------------------------------------------------------------
      on_context_menu_selected
         FOR EVENT context_menu_selected OF cl_gui_picture
         IMPORTING fcode sender.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       Corresponding class implementation                            *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_picture_click.
    MESSAGE i016 WITH mouse_pos_x mouse_pos_y.
  ENDMETHOD.

  METHOD on_control_dblclick.
    MESSAGE i017 WITH mouse_pos_x mouse_pos_y.
  ENDMETHOD.

  METHOD on_context_menu.
    DATA:
      l_ref_menu TYPE REF TO cl_ctmenu,
      l_it_functions TYPE ui_functions,      " optional part
      l_wa_func LIKE LINE OF l_it_functions. " optional part

    CREATE OBJECT l_ref_menu.

*   assign functions to context menu:
    CALL METHOD l_ref_menu->load_gui_status
      EXPORTING
        program    = sy-cprog
        status     = 'CTXMENU'
*       DISABLE    =
        menu       = l_ref_menu
      EXCEPTIONS
        OTHERS     = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

*   disable actual display mode (optional part):
    CASE sender->display_mode.
      WHEN cl_gui_picture=>display_mode_normal.
        l_wa_func = 'NORMAL'.
      WHEN cl_gui_picture=>display_mode_normal_center.
        l_wa_func = 'NORMAL_CENTER'.
      WHEN cl_gui_picture=>display_mode_stretch.
        l_wa_func = 'STRETCH'.
      WHEN cl_gui_picture=>display_mode_fit.
        l_wa_func = 'FIT'.
      WHEN cl_gui_picture=>display_mode_fit_center.
        l_wa_func = 'FIT_CENTER'.
    ENDCASE.
    INSERT l_wa_func INTO TABLE l_it_functions.
    CALL METHOD l_ref_menu->disable_functions
      EXPORTING
        fcodes = l_it_functions.

*   assign context menu to picture control:
    CALL METHOD sender->display_context_menu
      EXPORTING
        context_menu = l_ref_menu
      EXCEPTIONS
        OTHERS     = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

  ENDMETHOD.

  METHOD on_context_menu_selected.
    CASE fcode.

      WHEN 'STRETCH'.           " picture operation: stretch to fit are
        CALL METHOD sender->set_display_mode
          EXPORTING
            display_mode = cl_gui_picture=>display_mode_stretch
          EXCEPTIONS
            OTHERS = 1.
        IF sy-subrc NE 0.
          MESSAGE s015.
        ENDIF.

      WHEN 'NORMAL'.            " picture operation: fit to normal size
        CALL METHOD sender->set_display_mode
          EXPORTING
            display_mode = cl_gui_picture=>display_mode_normal
          EXCEPTIONS
            OTHERS = 1.
        IF sy-subrc NE 0.
          MESSAGE s015.
        ENDIF.

    WHEN 'NORMAL_CENTER'.     " picture operation: center in normal size
        CALL METHOD sender->set_display_mode
          EXPORTING
            display_mode = cl_gui_picture=>display_mode_normal_center
          EXCEPTIONS
            OTHERS = 1.
        IF sy-subrc NE 0.
          MESSAGE s015.
        ENDIF.

    WHEN 'FIT'.                        " picture operation: zoom picture
        CALL METHOD sender->set_display_mode
          EXPORTING
            display_mode = cl_gui_picture=>display_mode_fit
          EXCEPTIONS
            OTHERS = 1.
        IF sy-subrc NE 0.
          MESSAGE s015.
        ENDIF.

      WHEN 'FIT_CENTER'.        " picture operation: zoom and center
        CALL METHOD sender->set_display_mode
          EXPORTING
            display_mode = cl_gui_picture=>display_mode_fit_center
          EXCEPTIONS
            OTHERS = 1.
        IF sy-subrc NE 0.
          MESSAGE s015.
        ENDIF.

    ENDCASE.
  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*


TYPE-POOLS: cntl.

TYPES:
    t_url        TYPE bapiuri-uri.


DATA:
    ok_code      TYPE sy-ucomm,
    copy_ok_code LIKE ok_code,
    l_answer     TYPE c,


*   control specific: object references
    ref_container  TYPE REF TO cl_gui_custom_container,
    ref_splitter   TYPE REF TO cl_gui_splitter_container,
    ref_pic_left   TYPE REF TO cl_gui_picture,
    ref_pic_right  TYPE REF TO cl_gui_picture,

*   object references to splitter control areas
    cell_1_1       TYPE REF TO cl_gui_container,
    cell_1_2       TYPE REF TO cl_gui_container,

*   control specific: auxiliary fields
    l_url1        TYPE t_url,
    l_url2        TYPE t_url,

    current_mode  LIKE cl_gui_picture=>display_mode,

*   event registration
    it_events     TYPE cntl_simple_events,
    wa_events     LIKE LINE OF it_events.





START-OF-SELECTION.

  CALL FUNCTION 'BC412_BDS_GET_PIC_URL'" fetch URL of first picture
*      EXPORTING                         " from BDS
*           NUMBER        = 1
       IMPORTING
            url           = l_url1
       EXCEPTIONS
            OTHERS        = 1.

  IF sy-subrc <> 0.                    " no picture --> end of program
    MESSAGE i035(bc412) WITH 1.
    LEAVE PROGRAM.
  ENDIF.

  CALL FUNCTION 'BC412_BDS_GET_PIC_URL'" fetch URL of second picture
       EXPORTING                       " from BDS
            number        = 2
       IMPORTING
            url           = l_url2
       EXCEPTIONS
            OTHERS        = 1.

  IF sy-subrc <> 0.                    " no picture --> end of program
    MESSAGE i035(bc412) WITH 2.
    LEAVE PROGRAM.
  ENDIF.

  CALL SCREEN 100.



************************************************************************
*                                                                      *
*              S C R E E N   M O D U L E S                             *
*                                                                      *
************************************************************************
*
*&---------------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&---------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF ref_container IS INITIAL.         " prevent re-processing on ENTER
*   create custom container object and link to screen area
    CREATE OBJECT ref_container
      EXPORTING
        container_name = 'CONTROL_AREA1'
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010.                    " cancel program processing
    ENDIF.

*   create splitter container object and link to custom control
    CREATE OBJECT ref_splitter
      EXPORTING
        parent  = ref_container
        rows    = 1
        columns = 2
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010.                    " cancel program processing
    ENDIF.

*   fetch pointer to splitter control areas
*   left cell
    CALL METHOD ref_splitter->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = cell_1_1.

*   right cell
    CALL METHOD ref_splitter->get_container
      EXPORTING
        row       = 1
        column    = 2
      RECEIVING
        container = cell_1_2.

*   create picture control objects and link to cell pointer
*   picture control object 1 (left cell)
    CREATE OBJECT ref_pic_left
      EXPORTING
        parent = cell_1_1
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a011.                    " cancel program processing
    ENDIF.

*   picture control object 2 (right cell)
    CREATE OBJECT ref_pic_right
      EXPORTING
        parent = cell_1_2
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a011.                    " cancel program processing
    ENDIF.

*   load pictures into picture control objects
*   left cell
    CALL METHOD ref_pic_left->load_picture_from_url
      EXPORTING
        url    = l_url1
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
      MESSAGE a012.
    ENDIF.

*   right cell
    CALL METHOD ref_pic_right->load_picture_from_url
      EXPORTING
        url    = l_url2
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
      MESSAGE a012.
    ENDIF.


*   event handling
*   1. register events for control framework
    wa_events-eventid    = cl_gui_picture=>eventid_picture_click.
    wa_events-appl_event = ' '.
    INSERT wa_events INTO TABLE it_events.

    wa_events-eventid    = cl_gui_picture=>eventid_control_dblclick.
    wa_events-appl_event = ' '.
    INSERT wa_events INTO TABLE it_events.

    wa_events-eventid = cl_gui_picture=>eventid_context_menu.
    wa_events-appl_event = ' '.
    INSERT wa_events INTO TABLE it_events.

    wa_events-eventid = cl_gui_picture=>eventid_context_menu_selected.
    wa_events-appl_event = ' '.
    INSERT wa_events INTO TABLE it_events.

*   send envent table for picture in left cell to cfw
    CALL METHOD ref_pic_left->set_registered_events
      EXPORTING
        events = it_events
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.
      MESSAGE a012.
    ENDIF.

*   send envent table for picture in right cell to cfw
    CALL METHOD ref_pic_right->set_registered_events
      EXPORTING
        events = it_events
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.
      MESSAGE a012.
    ENDIF.

*   2. set event handler for ABAP object instance:
*   ref_pic_left (left cell)
    SET HANDLER lcl_event_handler=>on_picture_click    FOR ref_pic_left.
    SET HANDLER lcl_event_handler=>on_control_dblclick FOR ref_pic_left.
    SET HANDLER lcl_event_handler=>on_context_menu
        FOR ref_pic_left.
    SET HANDLER lcl_event_handler=>on_context_menu_selected
        FOR ref_pic_left.

*   ref_pic_right (right cell)
    SET HANDLER lcl_event_handler=>on_picture_click
        FOR ref_pic_right.
    SET HANDLER lcl_event_handler=>on_control_dblclick
        FOR ref_pic_right.
    SET HANDLER lcl_event_handler=>on_context_menu
        FOR ref_pic_right.
    SET HANDLER lcl_event_handler=>on_context_menu_selected
        FOR ref_pic_right.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type ' ':
*       - push buttons on screen 100
*       - GUI functions
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  copy_ok_code = ok_code.
  CLEAR ok_code.

  CASE copy_ok_code.
    WHEN 'BACK'.                       " back to program, leave screen
      CLEAR l_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
*               DEFAULTOPTION  = 'Y'
                textline1      = text-004
                textline2      = text-005
                titel          = text-007
                cancel_display = ' '
           IMPORTING
                answer         = l_answer.

      CASE l_answer.
        WHEN 'J'.
          PERFORM free_control_ressources.
          LEAVE TO SCREEN 0.
        WHEN 'N'.
          SET SCREEN sy-dynnr.
      ENDCASE.

  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI for screen 0100
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_NORM_0100'.
  SET TITLEBAR  'TITLE_NORM_0100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type 'E'.
*----------------------------------------------------------------------*
MODULE exit_command_0100 INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.        " cancel current screen processing
      CLEAR l_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
*               DEFAULTOPTION  = 'Y'
                textline1      = text-004
                textline2      = text-005
                titel          = text-006
                cancel_display = ' '
           IMPORTING
                answer         = l_answer.
      CASE l_answer.
        WHEN 'J'.
          PERFORM free_control_ressources.
          LEAVE TO SCREEN 0.
        WHEN 'N'.
          CLEAR ok_code.
          SET SCREEN sy-dynnr.
      ENDCASE.

    WHEN 'EXIT'.                       " leave program
      CLEAR l_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
*               DEFAULTOPTION  = 'Y'
                textline1      = text-001
                textline2      = text-002
                titel          = text-003
                cancel_display = 'X'
           IMPORTING
                answer         = l_answer.
      CASE l_answer.
        WHEN 'J' OR 'N'.               " no data to update
          PERFORM free_control_ressources.
          LEAVE PROGRAM.
        WHEN 'A'.
          CLEAR ok_code.
          SET SCREEN sy-dynnr.
      ENDCASE.
  ENDCASE.
ENDMODULE.                             " EXIT_COMMAND_0100  INPUT


*&---------------------------------------------------------------------*
*&      Form  free_control_ressources
*&---------------------------------------------------------------------*
*       Free all control related ressources.
*----------------------------------------------------------------------*
FORM free_control_ressources.
  CALL METHOD ref_pic_left->free.
  CALL METHOD ref_pic_right->free.
  CALL METHOD ref_splitter->free.
  CALL METHOD ref_container->free.
  FREE: ref_pic_left,
        ref_pic_right,
        cell_1_1,
        cell_1_2,
        ref_splitter,
        ref_container.
ENDFORM.                               " free_control_ressources
