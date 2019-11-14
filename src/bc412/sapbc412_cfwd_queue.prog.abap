*&---------------------------------------------------------------------*
*& Report  SAPBC412_CFWD_QUEUE                                         *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Demonstration in order to show automation queue functionality       *
*& Usage: 1. Run the program and click on any hyperlink at SAPs
*&           homepage                                                  *
*&        2. Choose the pushbutton New Window                          *
*&        3. A selection screen appears, that gives you the            *
*&           possibility to decide which PBO-module will be processed  *
*&                                                                     *
*&           The module RIGHT contain a move that maps                 *
*&           l_url1 to l_url2 and the corresponding flush.             *
*&           The module BEST uses the automation queue automatism,
*&           makes the flush unnecessary.                              *
*&           The module ERROR1 is the same as RIGHT but without the    *
*&           necessary flush.                                          *
*&           The module ERROR2 is the same as BEST but the method      *
*&           are encapsulated within a perform and uses a local field  *
*&           for data exchange (you will get a shortdump)              *
*&                                                                     *
*&        4. Show the behavior and then explain it using the           *
*&           ABAP-coding within the modules.                           *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cfwd_queue MESSAGE-ID bc412.

TYPES:
    t_url        TYPE bapiuri-uri.

SELECTION-SCREEN BEGIN OF SCREEN 1100.
SELECTION-SCREEN BEGIN OF BLOCK demo WITH FRAME TITLE text-s01.
PARAMETERS: right RADIOBUTTON GROUP rgb,
            best RADIOBUTTON GROUP rgb,
            error1 RADIOBUTTON GROUP rgb,
            error2 RADIOBUTTON GROUP rgb.
.
SELECTION-SCREEN END OF BLOCK demo.
SELECTION-SCREEN END OF SCREEN 1100.


DATA:
    ok_code      TYPE sy-ucomm,        " command field
    copy_ok_code LIKE ok_code,         " copy of ok_code
    l_answer     TYPE c,               " return flag (used in
                                       " standard user dialogs)

*   control specific: object references
    ref_container1 TYPE REF TO cl_gui_custom_container,
    ref_viewer1    TYPE REF TO cl_gui_html_viewer,
    ref_container2 TYPE REF TO cl_gui_custom_container,
    ref_viewer2    TYPE REF TO cl_gui_html_viewer,

*   control specific: auxiliary fields
    l_url1         TYPE t_url VALUE 'http://www.sap.com',
    l_url2         TYPE t_url.


* start of main program
START-OF-SELECTION.


  CALL SCREEN 100.

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
*----------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF ref_container1 IS INITIAL.         " prevent re-processing on ENTER
*     create container object and link to screen area
    CREATE OBJECT ref_container1
      EXPORTING
        container_name = 'CONTROL_AREA1'
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010.                    " cancel program processing
    ENDIF.

*     create viewer control and link to container object
    CREATE OBJECT ref_viewer1
      EXPORTING
        parent = ref_container1
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a018.                    " cancel programn processing
    ENDIF.

*     load startpage into viewer control
    CALL METHOD ref_viewer1->show_url
      EXPORTING
        url                    = l_url1.

    IF sy-subrc NE 0.
      MESSAGE a012.
    ENDIF.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type ' ':
*       - push buttons on the screen
*       - GUI functions
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  copy_ok_code = ok_code.
  CLEAR ok_code.

  CASE copy_ok_code.
    WHEN 'NEW'.
      CALL SELECTION-SCREEN 1100 STARTING AT 10 10.
      IF sy-subrc = 0.
        CALL SCREEN 200 STARTING AT 10 10.
      ENDIF.
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

  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI for screen 0100
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_NORM_0100'.
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


************************************************************************
*                                                                      *
*              F O R M    R O U T I N E S                              *
*                                                                      *
************************************************************************
*
*&---------------------------------------------------------------------*
*&      Form  free_control_ressources
*&---------------------------------------------------------------------*
*       Here you should implement: Free all control related ressources.
*----------------------------------------------------------------------*
*       no interface
*----------------------------------------------------------------------*
FORM free_control_ressources.
* to be implemented later
ENDFORM.                               " free_control_ressources
**&---------------------------------------------------------------------
*
**&      Module  right  OUTPUT
**&---------------------------------------------------------------------
*
**       text
**----------------------------------------------------------------------
MODULE right OUTPUT.

  CHECK NOT right IS INITIAL.

* get current URL from first HTML-Viewer Control
  CALL METHOD ref_viewer1->get_current_url
    IMPORTING
      url        = l_url1
    EXCEPTIONS
      OTHERS     = 2.
  IF sy-subrc <> 0.
    MESSAGE a012.
*   Fehler beim Methodenaufruf.
  ENDIF.

* flush for synchronize
  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      cntl_system_error = 1
      cntl_error        = 2
      OTHERS            = 3
          .
  IF sy-subrc <> 0.
    MESSAGE a075.
*   Interner Fehler

  ENDIF.

*  ABAP-move that makes the flush necessary
  l_url2 = l_url1.

* set url for the second viewer
  CALL METHOD ref_viewer2->show_url
    EXPORTING
      url                    = l_url2
    EXCEPTIONS
      OTHERS                 = 5.

  IF sy-subrc <> 0.
    MESSAGE a012.
*   Fehler beim Methodenaufruf.
  ENDIF.

  CLEAR l_url1.

ENDMODULE.                 " right  OUTPUT

**&---------------------------------------------------------------------
*
**&      Module  error1  OUTPUT
**&---------------------------------------------------------------------
*
**       text
**----------------------------------------------------------------------
MODULE error1 OUTPUT.

  CHECK NOT error1 IS INITIAL.

* get current URL from first HTML-Viewer Control
  CALL METHOD ref_viewer1->get_current_url
    IMPORTING
      url        = l_url1
    EXCEPTIONS
      OTHERS     = 2.
  IF sy-subrc <> 0.
    MESSAGE a012.
*   Fehler beim Methodenaufruf.
  ENDIF.

* !!! ABAP-move
  l_url2 = l_url1.

* set url for the second viewer
  CALL METHOD ref_viewer2->show_url
    EXPORTING
      url                    = l_url2
    EXCEPTIONS
      OTHERS                 = 5.

  IF sy-subrc <> 0.
    MESSAGE a012.
*   Fehler beim Methodenaufruf.
  ENDIF.

  CLEAR l_url1.

ENDMODULE.                 " error1  OUTPUT
**&---------------------------------------------------------------------
*
**&      Module  error2  OUTPUT
**&---------------------------------------------------------------------
*
**       text
**----------------------------------------------------------------------
MODULE error2 OUTPUT.

  CHECK NOT error2 IS INITIAL.

  PERFORM error2.

  CLEAR l_url1.

ENDMODULE.                 " error2  OUTPUT

**&---------------------------------------------------------------------
*
**&      Module  best  OUTPUT
**&---------------------------------------------------------------------
*
**       text
**----------------------------------------------------------------------
MODULE best OUTPUT.

  CHECK NOT best IS INITIAL.

* get current URL from first HTML-Viewer Control
  CALL METHOD ref_viewer1->get_current_url
    IMPORTING
      url        = l_url1
    EXCEPTIONS
      OTHERS     = 2.
  IF sy-subrc <> 0.
    MESSAGE a012.
*   Fehler beim Methodenaufruf.
  ENDIF.

* no flush necessary becouse of automation queue automatism

* set url for the second viewer
  CALL METHOD ref_viewer2->show_url
    EXPORTING
      url                    = l_url1
    EXCEPTIONS
      OTHERS                 = 5.

  IF sy-subrc <> 0.
    MESSAGE a012.
*   Fehler beim Methodenaufruf.
  ENDIF.

  CLEAR l_url1.

ENDMODULE.                 " right  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  init_control_processing_200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_control_processing_200 OUTPUT.
  IF ref_container2 IS INITIAL.         " prevent re-processing on ENTER
*     create container object and link to screen area
    CREATE OBJECT ref_container2
      EXPORTING
        container_name = 'CONTROL_AREA2'
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010.                    " cancel program processing
    ENDIF.

*     create picture control and link to container object
    CREATE OBJECT ref_viewer2
      EXPORTING
        parent = ref_container2
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a018.                    " cancel programn processing
    ENDIF.

  ENDIF.

ENDMODULE.                 " init_control_processing_200  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  status_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS_NORM_0200'.
  SET TITLEBAR 'TITLE_NORM_0200'.

ENDMODULE.                 " status_0200  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  error2
*&---------------------------------------------------------------------*
*       exchange the URL via local variable
*----------------------------------------------------------------------*
*       no interface
*----------------------------------------------------------------------*
FORM error2.
  DATA local_url TYPE t_url.
* get current URL from first HTML-Viewer Control
* the system tries to fill local_url at the very end of PAI
  CALL METHOD ref_viewer1->get_current_url
    IMPORTING
      url        = local_url
    EXCEPTIONS
      OTHERS     = 2.
  IF sy-subrc <> 0.
    MESSAGE a012.
*   Fehler beim Methodenaufruf.
  ENDIF.

  IF sy-subrc <> 0.
    MESSAGE a075.
*   Interner Fehler

  ENDIF.


* set url for the second viewer
  CALL METHOD ref_viewer2->show_url
    EXPORTING
      url                    = local_url
    EXCEPTIONS
      OTHERS                 = 5.

  IF sy-subrc <> 0.
    MESSAGE a012.
*   Fehler beim Methodenaufruf.
  ENDIF.

ENDFORM.                                                    " error2
