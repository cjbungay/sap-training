*&---------------------------------------------------------------------*
*& Report  SAPBC412_CONS_EXERCISE1A                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Model solution for the optional part of the first exercise of unit  *
*& SAP CONTAINER CONTROLS. A SAP Docking Container Control is used and *
*& the user can select via a checkbox on the selection screen whether  *
*& the container is docked to the left (default) or right side of      *
*& screen 100.                                                         *
*&                                                                     *
*& All picture control related parts are unchanged.                    *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cons_exercise1a MESSAGE-ID bc412.
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
         IMPORTING mouse_pos_x mouse_pos_y.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       Corresponding class implementation                           *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_picture_click.
    MESSAGE i016 WITH mouse_pos_x mouse_pos_y.
  ENDMETHOD.

  METHOD on_control_dblclick.
    MESSAGE i017 WITH mouse_pos_x mouse_pos_y.
  ENDMETHOD.
ENDCLASS.

* type pools
TYPE-POOLS: cntl.
* data types
TYPES:
    t_url        TYPE bapiuri-uri.

* data declarations
*   screen specific
DATA:
    ok_code      TYPE sy-ucomm,        " command field
    copy_ok_code LIKE ok_code,         " copy of ok_code
    l_answer     TYPE c,               " return flag (used in
                                       " standard user dialogs)

*   control specific: object references
    ref_container TYPE REF TO cl_gui_docking_container,
    ref_picture   TYPE REF TO cl_gui_picture,

*   control specific: auxiliary fields
    l_url         TYPE t_url,          " URL of picture to be shown
    current_mode  LIKE cl_gui_picture=>display_mode,
    docking_side  LIKE cl_gui_docking_container=>dock_at_right,

*   event handling
    it_events     TYPE cntl_simple_events, " internal (event) table
    wa_events     LIKE LINE OF it_events.  " work area

* selection screen definition
PARAMETERS: p_side AS CHECKBOX.

* start of main program
START-OF-SELECTION.

  CALL FUNCTION 'BC412_BDS_GET_PIC_URL'" festch URL of first picture
*      EXPORTING                         " from BDS
*           NUMBER        = 1
       IMPORTING
            url           = l_url
       EXCEPTIONS
            OTHERS        = 1.

  IF sy-subrc <> 0.                    " no picture --> end of program
    MESSAGE i035(bc412) WITH 1.
    LEAVE PROGRAM.
  ENDIF.

  CALL SCREEN 100.                     " container screen for SAP-Enjoy
                                       " controls

* end of main program

************************************************************************
*                                                                      *
*              S C R E E N   M O D U L E S                             *
*                                                                      *
************************************************************************
*
*&---------------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&---------------------------------------------------------------------*
*       Implementation of EnjoySAP control processing:
*       1)  create container object and link to screen (left side)
*       2)  create picture object and link to container
*       3)  load picture into picture control
*       4)  event handling
*           a1) register event PICTURE_CLICK at CFW
*           a2) register event CONTROL_DBLCLICK at CFW
*           b1) register event handler method ON_PICTURE_CLICK
*               for the picture control object
*           b2) register event handler method ON_CONTROL_DBLCLICK
*               for the picture control object
*----------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF ref_container IS INITIAL.         " prevent re-processing on ENTER
*     create container object and link to screen
    IF p_side IS INITIAL.
      docking_side = cl_gui_docking_container=>dock_at_left.
    ELSE.                              " dock to right side selected
      docking_side = cl_gui_docking_container=>dock_at_right.
    ENDIF.


    CREATE OBJECT ref_container
      EXPORTING
        side = docking_side
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010.                    " cancel program processing
    ENDIF.

*     create picture control and link to container object
    CREATE OBJECT ref_picture
      EXPORTING
        parent = ref_container
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a011.                    " cancel program processing
    ENDIF.

*     load picture into picture control
    CALL METHOD ref_picture->load_picture_from_url
      EXPORTING
        url    = l_url
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.
      MESSAGE a012.
    ENDIF.


*     event handling
*     1. register events for control framework
    wa_events-eventid    = cl_gui_picture=>eventid_picture_click.
    wa_events-appl_event = ' '.
    INSERT wa_events INTO TABLE it_events.

    wa_events-eventid    = cl_gui_picture=>eventid_control_dblclick.
    wa_events-appl_event = ' '.
    INSERT wa_events INTO TABLE it_events.


    CALL METHOD ref_picture->set_registered_events
      EXPORTING
        events = it_events
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.
      MESSAGE a012.
    ENDIF.
*     2. set event handler for ABAP object instance: ref_picture
    SET HANDLER lcl_event_handler=>on_picture_click    FOR ref_picture.
    SET HANDLER lcl_event_handler=>on_control_dblclick FOR ref_picture.

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

    WHEN 'STRETCH'.           " picture operation: stretch to fit are
      CALL METHOD ref_picture->set_display_mode
        EXPORTING
          display_mode = cl_gui_picture=>display_mode_stretch
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc NE 0.
        MESSAGE s015.
      ENDIF.
    WHEN 'NORMAL'.            " picture operation: fit to normal size
      CALL METHOD ref_picture->set_display_mode
        EXPORTING
          display_mode = cl_gui_picture=>display_mode_normal
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc NE 0.
        MESSAGE s015.
      ENDIF.

    WHEN 'NORMAL_CENTER'.     " picture operation: center in normal size
      CALL METHOD ref_picture->set_display_mode
        EXPORTING
          display_mode = cl_gui_picture=>display_mode_normal_center
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc NE 0.
        MESSAGE s015.
      ENDIF.

    WHEN 'FIT'.                        " picture operation: zoom picture
      CALL METHOD ref_picture->set_display_mode
        EXPORTING
          display_mode = cl_gui_picture=>display_mode_fit
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc NE 0.
        MESSAGE s015.
      ENDIF.

    WHEN 'FIT_CENTER'.        " picture operation: zoom and center
      CALL METHOD ref_picture->set_display_mode
        EXPORTING
          display_mode = cl_gui_picture=>display_mode_fit_center
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc NE 0.
        MESSAGE s015.
      ENDIF.

    WHEN 'MODE_INFO'.
      current_mode = ref_picture->display_mode.
      MESSAGE i025 WITH current_mode.

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

************************************************************************
*                                                                      *
*              F O R M    R O U T I N E S                              *
*                                                                      *
************************************************************************
*
*&---------------------------------------------------------------------*
*&      Form  free_control_ressources
*&---------------------------------------------------------------------*
*       Free all control related ressources.
*----------------------------------------------------------------------*
*       no interface
*----------------------------------------------------------------------*
FORM free_control_ressources.
  CALL METHOD ref_picture->free.
  CALL METHOD ref_container->free.
  FREE: ref_picture, ref_container.
ENDFORM.                               " free_control_ressources
