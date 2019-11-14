*&---------------------------------------------------------------------*
*& Report  SAPBC412_COND_EASY_SPLITTER_1                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cond_easy_splitter_1      .
* type pools
TYPE-POOLS: cntl.
* data types
TYPES:
  t_url        TYPE bapiuri-uri.

* global data
DATA:
* user_commands on screens
  okcode                 TYPE sy-ucomm,
  copy_fcode             TYPE sy-ucomm,

* auxiliary fields
  l_orient               TYPE i,

* URLs
  l_url1                 TYPE t_url,
  l_url2                 TYPE t_url,

* object references
  ref_custom_container   TYPE REF TO cl_gui_custom_container,
  ref_easy_splitter      TYPE REF TO cl_gui_easy_splitter_container,
  ref_cell_1             TYPE REF TO cl_gui_container,
  ref_cell_2             TYPE REF TO cl_gui_container,
  ref_picture_1          TYPE REF TO cl_bc412_picture_1,
  ref_picture_2          TYPE REF TO cl_bc412_picture_1.

* constants: radio button group implementation
CONSTANTS:
  c_marked TYPE c VALUE 'X'.

* definition of the standard selection screen
SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE text-s01.
* radio button group
PARAMETERS:
  p_horizo TYPE c DEFAULT 'X' RADIOBUTTON GROUP rad,
  p_vertic TYPE c             RADIOBUTTON GROUP rad.
SELECTION-SCREEN END OF BLOCK block1.


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
*    S E L E L E C T I O N   S C R E E N   P A I                      *
*                                                                     *
***********************************************************************
AT SELECTION-SCREEN.                   " analyze selection screen input
  CASE c_marked.
    WHEN p_horizo.
      l_orient = cl_gui_easy_splitter_container=>orientation_horizontal.
    WHEN p_vertic.
      l_orient = cl_gui_easy_splitter_container=>orientation_vertical.
  ENDCASE.

***********************************************************************
*                                                                     *
*    M A I N    P R O G R A M                                         *
*                                                                     *
***********************************************************************
START-OF-SELECTION.
* get url's to pictures
  CALL FUNCTION 'BC412_BDS_GET_2PIC_URL_INTERAC'
       EXPORTING
            title_text         = 'Pictures      '(053)
       IMPORTING
            url1                = l_url1
            url2                = l_url2
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
  IF ref_custom_container IS INITIAL.

*   create custom container object
    CREATE OBJECT ref_custom_container
      EXPORTING
        container_name = 'CONTROL_AREA1'
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   create easy_splitter container object and link to custom container
    CREATE OBJECT ref_easy_splitter
      EXPORTING
        parent  = ref_custom_container
        orientation = l_orient
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   get cell references
    ref_cell_1 = ref_easy_splitter->top_left_container.
    ref_cell_2 = ref_easy_splitter->bottom_right_container.

*   create picture objects and link to cells
    CREATE OBJECT ref_picture_1
      EXPORTING
        i_parent      = ref_cell_1
        i_url                 = l_url1
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

    CREATE OBJECT ref_picture_2
      EXPORTING
        i_parent      = ref_cell_2
        i_url                 = l_url2
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

*   event handling (only ABAP objects part!)
    SET HANDLER lcl_event_handler=>on_picture_click FOR:
            ref_picture_1,
            ref_picture_2.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI title and GUI status for screen 100.
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'NORM_0100'.
  CASE c_marked.
    WHEN p_horizo.                     " horizontal split selected
      SET TITLEBAR 'TITLE_1'.
    WHEN p_vertic.                     " vertical   split selected
      SET TITLEBAR 'TITLE_2'.
  ENDCASE.
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
    WHEN 'POPUP1'.
      MESSAGE i100(bc412) WITH text-005.
    WHEN 'POPUP2'.
      MESSAGE i100(bc412) WITH text-006.
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
  CALL METHOD:
      ref_picture_1->free,
      ref_picture_2->free,
      ref_easy_splitter->free,
      ref_custom_container->free.
  FREE:
      ref_picture_1,
      ref_picture_2,
      ref_cell_1,
      ref_cell_2,
      ref_easy_splitter,
      ref_custom_container.
ENDFORM.                               " FREE_CONTROL_RESSOURCES
