*&---------------------------------------------------------------------*
*& Report  SAPBC412_CFWD_EVENTS_B                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Fifth demo program of a series of demo programs of course BC412     *
*& 'ABAP Dialog Programming using EnjoySAP-Controls'.                  *
*& The following control processing related steps are included in      *
*& this demo:                                                          *
*& 1.) definition of a screen area reserved for a container object     *
*& 2.) creation of a container object                                  *
*& 3.) creation of a HTML viewer object                                *
*& 4.) method calls for HTML viewer object                             *
*& 5.) event handling for events of HTML viewer objects:               *
*&     - NAVIGATE_COMPLETE                                             *
*&     - SAPEVENT                                                      *
*& The event NAVIGATE_COMPLETE can now be registered as application    *
*& event. This can be ruled via a checkbox on a selection screen.      *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cfwd_events_b MESSAGE-ID bc412.

DATA: " needed by the 'compiler' here, since the method
                                       " on_navigate_complete uses l_url
    l_url(80)      TYPE c.             " URL of HTML document

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       Local class containing the definition of event handler        *
*       methods for events of HTML viewer object:                     *
*       event                   event handler method                  *
*       ---------------------------------------------                 *
*       navigate_complete   --> on_navigate_complete                  *
*       sapevent            --> on_sapevent                           *
*                                                                     *
*       Both event handler methods are defined as static methods      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_navigate_complete
         FOR EVENT navigate_complete OF cl_gui_html_viewer
         IMPORTING url,
*     -----------------------------------------------------------------
      on_sapevent
         FOR EVENT sapevent          OF cl_gui_html_viewer
         IMPORTING action.

ENDCLASS.
*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       Implementation for all event handler methods.                 *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_navigate_complete.
    l_url = url.
    MESSAGE i020(bc412) WITH url.
  ENDMETHOD.
* ---------------------------------------------------------------------
  METHOD on_sapevent.
    MESSAGE i021(bc412) WITH action.
  ENDMETHOD.
ENDCLASS.

* type pools
TYPE-POOLS: cntl.

* data declarations
*   screen specific
DATA:
    ok_code      TYPE sy-ucomm,        " command field
    copy_ok_code LIKE ok_code,         " copy of ok_code
    l_answer     TYPE c,               " return flag (used in
                                       " standard user dialogs)

*   control specific
*   ** object references
    my_container   TYPE REF TO cl_gui_custom_container,
    my_html_viewer TYPE REF TO cl_gui_html_viewer,
*   ** auxiliary fields
*   l_url(80)      TYPE c,             " taken out, see above
    home_url       LIKE l_url,         " home URL (Web repository).
*   ** event handling
    it_events      TYPE cntl_simple_events, " internal (event) table
    wa_events      LIKE LINE OF it_events.  " work area

* selection screen definition
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_appl AS CHECKBOX.
SELECTION-SCREEN COMMENT 4(40) text-s01.
SELECTION-SCREEN END OF LINE.
* start of main program
START-OF-SELECTION.

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
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI for screen 0100
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_EXTENDED_0100'.
  SET TITLEBAR 'TITLE_NORM_0100'.

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
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type ' '.
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
* if an application event has been raised transfer control to CFW
  IF p_appl = 'X'.
    CALL METHOD cl_gui_cfw=>dispatch.
  ENDIF.

  copy_ok_code = ok_code.
  CLEAR ok_code.

  CASE copy_ok_code.
    WHEN 'BACK'.
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
    WHEN 'STOP'.
      CALL METHOD my_html_viewer->stop
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc NE 0.
        MESSAGE s012(bc412).
      ENDIF.
    WHEN 'GO_HOME'.
      CALL METHOD my_html_viewer->show_data
        EXPORTING
          url = home_url
        EXCEPTIONS
          OTHERS = 1.

      IF sy-subrc NE 0.
        MESSAGE a012(bc412).
      ENDIF.

    WHEN 'GOTO'.
      CALL METHOD my_html_viewer->show_url
        EXPORTING
          url = l_url
        EXCEPTIONS
          OTHERS = 1.

      IF sy-subrc NE 0.
        MESSAGE a012(bc412).
      ENDIF.


  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&---------------------------------------------------------------------*
*       Implementation of EnjoySAP control processing:
*       1)  create container object and link to screen area
*       2)  create HTML viewer object and link to container
*----------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF my_container IS INITIAL.          " prevent re-processing on ENTER
*     create container object and link to screen area
    CREATE OBJECT my_container
      EXPORTING
        container_name = 'CONTROL_AREA1'
      EXCEPTIONS
        others = 1.
    IF sy-subrc NE 0.
      MESSAGE a010.
    ENDIF.

*     create HTML viewer object and link to container
    CREATE OBJECT my_html_viewer
      EXPORTING
        parent = my_container
      EXCEPTIONS
        others = 1.
    IF sy-subrc NE 0.
      MESSAGE a018.
    ENDIF.

*     fetch url of HTML document from Web Repository
*        Note: document is loaded from web repository into data
*              provider and URL to copy in data provider is given back
    CALL METHOD my_html_viewer->load_html_document
      EXPORTING
        document_id  = 'BC412_TESTHTMLEVENTS'
      IMPORTING
        assigned_url = home_url
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.
      MESSAGE a012(bc412).
    ENDIF.

    l_url = home_url.

*     assign url of HTML document from Web Repository to HTML viewer
    CALL METHOD my_html_viewer->show_data
      EXPORTING
        url = l_url
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.
      MESSAGE a012(bc412).
    ENDIF.

*     event handling
*     ** set handler method for events of ABAP proxy object
    SET HANDLER lcl_event_handler=>on_navigate_complete
                FOR my_html_viewer.

    SET HANDLER lcl_event_handler=>on_sapevent
                FOR my_html_viewer.

*     ** register the events for the control framework
*         (customize automation controler)
    wa_events-eventid    = cl_gui_html_viewer=>m_id_navigate_complete.
    IF p_appl IS INITIAL.
      wa_events-appl_event =  ' '.
    ELSE.
      wa_events-appl_event =  'X'.
    ENDIF.
    INSERT wa_events INTO TABLE it_events.

    wa_events-eventid    = cl_gui_html_viewer=>m_id_sapevent.
    wa_events-appl_event = ' '.
    INSERT wa_events INTO TABLE it_events.

    CALL METHOD my_html_viewer->set_registered_events
      EXPORTING
        events = it_events
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.
      MESSAGE a012(bc412).
    ENDIF.

  ENDIF.                               " first_time


ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

************************************************************************
*   F O R M    R O U T I N E S
************************************************************************
*&---------------------------------------------------------------------*
*&      Form  free_control_ressources
*&---------------------------------------------------------------------*
*       Free all control related ressources.
*----------------------------------------------------------------------*
*       no interface
*----------------------------------------------------------------------*
FORM free_control_ressources.
  CALL METHOD my_html_viewer->free.
  CALL METHOD my_container->free.
  FREE: my_html_viewer, my_container.
ENDFORM.                               " free_control_ressources
