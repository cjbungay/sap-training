*&---------------------------------------------------------------------*
*& Report  SAPBC412_COND_DOCKING_1                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cond_docking_1    .
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
  my_container TYPE REF TO cl_gui_docking_container,

* auxiliary control field
  l_side       LIKE cl_gui_docking_container=>dock_at_left,

* url to picture
  l_url        TYPE t_url.


* local event handler class
*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       local class containing a static method used as event handler  *
*       for event PICTURE_CLICK of class CL_BC412_PICTURE_1           *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_picture_click FOR EVENT picture_click OF cl_bc412_picture_1
        IMPORTING mouse_pos_x mouse_pos_y.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       implementation of static event handler method:                *
*       a message is raised                                           *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_picture_click.
    MESSAGE i016(bc412) WITH mouse_pos_x mouse_pos_y.
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
*       exporting
*           title_text         = 'Picture 1      '(051)
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

* create container object
    CREATE OBJECT my_container         " docking container
      EXPORTING
*       parent                  =
*       REPID                   =
*       DYNNR                   =
*       SIDE                    =
        extension               = 100
        caption                 = 'This is my screen title'(050)
*       NO_AUTODEF_PROGID_DYNNR =
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.

    IF sy-subrc NE 0.
      MESSAGE a011(bc412).
    ENDIF.

    create object my_picture
      exporting
        i_parent             = my_container
        i_url                = l_url
*       I_PICTURE_CLICK      = 'X'
*       I_APPL_EVENT_PC      = 'X'
        I_STRETCH_TEXT       = text-011
        I_FIT_TEXT           = text-012
        I_NORMAL_TEXT        = text-013
        I_FIT_CENTER_TEXT    = text-014
        I_NORMAL_CENTER_TEXT = text-015
      EXCEPTIONS
        others             = 1.

    IF sy-subrc NE 0.
      MESSAGE a011(bc412).
    ENDIF.

    SET HANDLER lcl_event_handler=>on_picture_click FOR my_picture.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI title and GUI status for screen 100.
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DOCK_0100'.
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
    WHEN 'LEFT' OR 'RIGHT' OR 'TOP' OR 'BOTTOM'.
      CASE copy_fcode.
        WHEN 'LEFT'.
          l_side = cl_gui_docking_container=>dock_at_left.
        WHEN 'RIGHT'.
          l_side = cl_gui_docking_container=>dock_at_right.
        WHEN 'TOP'.
          l_side = cl_gui_docking_container=>dock_at_top.
        WHEN 'BOTTOM'.
          l_side = cl_gui_docking_container=>dock_at_bottom.
      ENDCASE.

      CALL METHOD my_container->dock_at
        EXPORTING
          side = l_side
        EXCEPTIONS
          cntl_error        = 1
          cntl_system_error = 2.

      IF sy-subrc NE 0.
*
      ENDIF.

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
  CALL METHOD: my_picture->free,
               my_container->free.
  FREE: my_picture,
        my_container.
ENDFORM.                               " FREE_CONTROL_RESSOURCES
