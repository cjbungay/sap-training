*&---------------------------------------------------------------------*
*& Report  SAPBC412_COND_DIALOGBOX_1                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cond_dialogbox_1    .
* type pools
TYPE-POOLS: cntl.
* data types
TYPES:
  t_url        TYPE bapiuri-uri.

* global data
DATA:
* user_commands on screens
  okcode       TYPE sy-ucomm,
  copy_fcode   TYPE sy-ucomm,

* object references
  my_picture   TYPE REF TO cl_bc412_picture_1,
  my_container TYPE REF TO cl_gui_dialogbox_container,

* url to picture
  l_url        TYPE t_url.


* local event handler class
*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       local class containing two static method used as event        *
*       handler  for                                                  *
*       - event PICTURE_CLICK of class CL_BC412_PICTURE_1             *
*       - event CLOSE of class CL_GUI_DIALOGBOX_CONTAINER             *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_picture_click FOR EVENT picture_click
                       OF cl_bc412_picture_1
          IMPORTING mouse_pos_x mouse_pos_y,
      on_close FOR EVENT close OF cl_gui_dialogbox_container
          IMPORTING sender.

ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       implementation of static event handler methods:               *
*       - PICTURE_CLICK: a message is raised                          *
*       - CLOSE:         a dialogbox is raised (Yes, No, Cancel)      *
*                        Yes:       close dialog_box_container        *
*                        No/Cancel: do nothing                        *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_picture_click.
    MESSAGE i016(bc412) WITH mouse_pos_x mouse_pos_y.
  ENDMETHOD.

  METHOD on_close.
*   local data
    DATA: l_answer.

    CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
         EXPORTING
              textline1 = text-016
              titel     = text-017
         IMPORTING
              answer    = l_answer.

    CASE l_answer.
      WHEN 'J'.
        CALL METHOD my_picture->free
          EXCEPTIONS
            picture_error = 1.

        CALL METHOD sender->free.
        FREE my_container.
      WHEN 'N'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

***********************************************************************
*                                                                     *
*    M A I N    P R O G R A M                                         *
*                                                                     *
***********************************************************************

START-OF-SELECTION.
* get url to picture
  CALL FUNCTION 'BC412_BDS_GET_PIC_URL_INTERACT'
       IMPORTING
            url                = l_url
       EXCEPTIONS
            selection_canceled = 1
            OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE i035(bc412) WITH 1.
    LEAVE PROGRAM.
  ENDIF.

* call container screen hosting the container are
  CALL SCREEN 100.

************************************************************************
*                                                                      *
*  E N D   O F   M A I N   P R O G R A M                               *
*                                                                      *
************************************************************************

************************************************************************
*                                                                      *
*  M O D U L E S   U S E D   B Y   S C R E E N   1 0 0                 *
*                                                                      *
************************************************************************

*&---------------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&---------------------------------------------------------------------*
*       Start control handling.
*         i)   create container objects
*         ii)  create picture objects and link to containers
*         iii) register event handler for PICTURE_CLICK
*----------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF my_container IS INITIAL.

*   create container object
    CREATE OBJECT my_container
     EXPORTING
        width                   = 150
        height                  = 150
        caption                 = 'This is my screen title'(050)
     EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   create picture object ank link to container
    CREATE OBJECT my_picture
      EXPORTING
        i_parent      = my_container
        i_url                 = l_url
*       i_picture_click       = 'X'
*       i_appl_event_pc       = 'X'
        i_stretch_text        = text-011
        i_fit_text            = text-012
        i_normal_text         = text-013
        i_fit_center_text     = text-014
        i_normal_center_text  = text-015
      EXCEPTIONS
        others    = 1.
    IF sy-subrc NE 0.
      MESSAGE a011(bc412).
    ENDIF.

*   register event handler (ABAP objects only!)
    SET HANDLER lcl_event_handler=>on_picture_click FOR my_picture.
    SET HANDLER lcl_event_handler=>on_close         FOR my_container.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI title and GUI status for screen 100.
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DIALOG_0100' EXCLUDING 'CREATE'.
  SET TITLEBAR 'TITLE_1'.
ENDMODULE.                             " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type 'E' for screen 100.
*----------------------------------------------------------------------*
MODULE exit_command_0100 INPUT.
  CASE okcode.
    WHEN 'CANCEL'.                     " Cancel screen processing
      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.                       " Exit program
      PERFORM free_control_ressources.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                             " EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  COPY_FCODE  INPUT
*&---------------------------------------------------------------------*
*       Save the current user command (in fcode) to copy_fcode to
*       prevent unintended field transport for the screen field fcode
*       for next screen processing (ENTER)
*----------------------------------------------------------------------*
MODULE copy_fcode INPUT.
  CALL METHOD cl_gui_cfw=>dispatch.    " needed for application events

  copy_fcode = okcode.
  CLEAR okcode.
ENDMODULE.                             " COPY_FCODE  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type ' ' for screen 100.
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE copy_fcode.
    WHEN 'BACK'.                       " Go back to program
      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT


************************************************************************
*                                                                      *
*  F O R M   R O U T I N E S                                           *
*                                                                      *
************************************************************************

*&---------------------------------------------------------------------*
*&      Form  FREE_CONTROL_RESSOURCES
*&---------------------------------------------------------------------*
*       free control ressources on the presentation server
*       free all reference variables (ABAP object) -> garbage collector
*----------------------------------------------------------------------*
*       no interface
*----------------------------------------------------------------------*
FORM free_control_ressources.
  IF NOT my_container IS INITIAL.
    CALL METHOD: my_picture->free,
                 my_container->free.
    CLEAR: my_picture,
           my_container.
  ENDIF.
ENDFORM.                               " FREE_CONTROL_RESSOURCES
