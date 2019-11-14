*&---------------------------------------------------------------------*
*& Report  SAPBC412_CFWD_CALL_METHOD_B                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Third demo program of a series of demo programs of course BC412     *
*& 'ABAP Dialog Programming using EnjoySAP-Controls'.                  *
*& The following control processing related steps are included in      *
*& this demo:                                                          *
*& 1.) definition of a screen area reserved for a container object     *
*& 2.) creation of a container object                                  *
*& 3.) creation of a HTML viewer object
*& 4.) method calls for HTML viewer object
*&
*& Special focus is set on 'flush' problems:
*& Navigate to URL and get current URL from control in same queue.
*&----------------------------------------------------------------------
*& H O W   T O   U S E   T H I S   P R O G R A M :
*& - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*& 1.  start the program
*& 2.  switch to debug mode (on screen 100): Enter '/h' in the command
*&     field and press ENTER
*& 3.  press the pushbutton in the application toolbar (GOTO)
*& 4.  run into USER_COMMAND_0100 using single step mode
*& 5.  in USR_COMMAND_0100 watch the value of field CURR_URL
*& 6.  execute the different method calls using the function
*&     'execute F6' until you reach the second block of comment lines
*&     stating that you may leave the debug mode now
*& 7.  the field CURR_URL shows the 'old' URL since both call have been
*&     transfered to the same queue
*& 8.  restart the program
*& 9.  on screen 100: switch to debug mode again ('/h')
*&     and mark now the check box 'FLUSH after first method call'
*& 10. repeat steps 3 to 6 and obey the hint that is given in the
*& 11. comment lines (rest a little time after the first flush)
*& 12. after the second flush the field CURR_URL containes the URL of
*&     the current displayed HTML page in your HTML viewer
*&---------------------------------------------------------------------*

REPORT  sapbc412_cfwd_call_method_b MESSAGE-ID bc412.

DATA:
    ok_code      TYPE sy-ucomm,        " command field
    copy_ok_code LIKE ok_code,         " copy of ok_code
    l_answer     TYPE c,               " return flag (used in
                                       " standard user dialogs)
    flush_flag   TYPE c,               " flag: FLUSH after first
                                       " CALL METHOD

*   control specific
*   ** object references
    my_container   TYPE REF TO cl_gui_custom_container,
    my_html_viewer TYPE REF TO cl_gui_html_viewer,
*   ** auxiliary fields
    l_url(80)      TYPE c,             " URL of HTML document
    home_url       LIKE l_url,         " home URL (Web repository)
    curr_url       LIKE l_url.         " URL of current page


START-OF-SELECTION.

  CALL SCREEN 100.


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
  copy_ok_code = ok_code.
  CLEAR ok_code.

  CASE copy_ok_code.
    WHEN 'BACK'.
      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.
    WHEN 'GOTO'.
************************************************************************
*     W A T C H   H E R E   I N   D E B U G   M O D E                  *
*     P A Y   A T T E N T I O N    T O   F I E L D   curr_url          *
************************************************************************
      CALL METHOD my_html_viewer->show_url
        EXPORTING
          url = l_url
        EXCEPTIONS
          OTHERS = 1.

      IF sy-subrc NE 0.
        MESSAGE s012(bc412).
      ENDIF.

      IF flush_flag = 'X'.
        CALL METHOD cl_gui_cfw=>flush.
************************************************************************
*       I F    T H I S    flush    I S   E X E C U T E D               *
*       R E S T    A    L I T T L E   T I M E   H E R E   T O    L E T *
*       T H E  B R O W S E R    C O M P L E T E    N A V I G A T I O N *
************************************************************************
      ENDIF.

      CALL METHOD my_html_viewer->get_current_url
        IMPORTING
          url = curr_url
        EXCEPTIONS
          OTHERS = 1.

      CALL METHOD cl_gui_cfw=>flush.

************************************************************************
*   Y O U   C A N   L E A V E    D E B U G    M O D E   H E R E
************************************************************************
      IF sy-subrc NE 0.
        MESSAGE s012(bc412).
      ELSE.
        MESSAGE i019(bc412) WITH curr_url.
      ENDIF.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&---------------------------------------------------------------------*
*       Implementation of EnjoySAP control processing:
*       1)  create container object and link to screen area
*       2)  create HTML viewer object and link to container
*       3)  load HTML page from Web Repository
*       4)  send HTML page to HTML viewer
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

    CALL METHOD my_html_viewer->show_data
      EXPORTING
        url = home_url
      EXCEPTIONS
        OTHERS = 1.

    IF sy-subrc NE 0.
      MESSAGE a012(bc412).
    ENDIF.

************************************************************************
*   set special values for for this demo                               *
*      l_url   = 'http://www.sap.com'                                  *
************************************************************************
    l_url   = 'http://www.sap.com'.

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
