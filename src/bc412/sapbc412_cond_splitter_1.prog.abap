*&---------------------------------------------------------------------*
*& Report  SAPBC412_COND_SPLITTER_1                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cond_splitter_1     .
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

* object references
  ref_custom_container   TYPE REF TO cl_gui_custom_container,
  ref_splitter_container TYPE REF TO cl_gui_splitter_container,
  ref_cell_1_1           TYPE REF TO cl_gui_container,
  ref_cell_1_2           TYPE REF TO cl_gui_container,
  ref_cell_2_1           TYPE REF TO cl_gui_container,
  ref_cell_2_2           TYPE REF TO cl_gui_container,
  ref_picture_1          TYPE REF TO cl_bc412_picture_1,
  ref_picture_2          TYPE REF TO cl_bc412_picture_1,
  ref_picture_3          TYPE REF TO cl_bc412_picture_1,
  ref_picture_4          TYPE REF TO cl_bc412_picture_1,

* URLs
  l_url1                 TYPE t_url,
  l_url2                 TYPE t_url,
  l_url3                 TYPE t_url,
  l_url4                 TYPE t_url.

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
* get url of pictures
  CALL FUNCTION 'BC412_BDS_GET_4PIC_URL_INTERAC'
       EXPORTING
            title_text         = 'Pictures      '(055)
       IMPORTING
            url1                = l_url1
            url2                = l_url2
            url3                = l_url3
            url4                = l_url4
       EXCEPTIONS
            selection_canceled = 1
            OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE i035(bc412) WITH 1.
    LEAVE PROGRAM.
  ENDIF.


* call container screen hosting the container area
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

*   create easy splitter container object and link to custom container
    CREATE OBJECT ref_splitter_container
      EXPORTING
        parent  = ref_custom_container
        rows    = 2
        columns = 2
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   get cell references
*   - cell 1 1 (row | column)
*    CALL METHOD ref_splitter_container->get_container
*      EXPORTING
*        row       = 1
*        column    = 1
*      RECEIVING
*        container = ref_cell_1_1.
    ref_cell_1_1 = ref_splitter_container->get_container( row = 1
                 column = 1 ).

*   - cell 1 2 (row | column)
    ref_cell_1_2 = ref_splitter_container->get_container( row = 1
                 column = 2 ).

*   - cell 2 1 (row | column)
    ref_cell_2_1 = ref_splitter_container->get_container( row = 2
                 column = 1 ).

*   - cell 2 2 (row | column)
    ref_cell_2_2 = ref_splitter_container->get_container( row = 2
                 column = 2 ).

*   create picture objects and link to cells
    CREATE OBJECT ref_picture_1
      EXPORTING
        i_parent      = ref_cell_1_1
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
        i_parent      = ref_cell_1_2
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

    CREATE OBJECT ref_picture_3
      EXPORTING
        i_parent      = ref_cell_2_1
        i_url                 = l_url3
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

    CREATE OBJECT ref_picture_4
      EXPORTING
        i_parent      = ref_cell_2_2
        i_url                 = l_url4
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
            ref_picture_2,
            ref_picture_3,
            ref_picture_4.
  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI title and GUI status for screen 100.
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'NORM_0100'.
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
  CALL METHOD:
    ref_picture_1->free,
    ref_picture_2->free,
    ref_picture_3->free,
    ref_picture_4->free,
    ref_splitter_container->free,
    ref_custom_container->free.
  FREE:
    ref_picture_1,
    ref_picture_2,
    ref_picture_3,
    ref_picture_4,
    ref_cell_1_1,
    ref_cell_1_2,
    ref_cell_2_1,
    ref_cell_2_2,
    ref_splitter_container,
    ref_custom_container.
ENDFORM.                               " FREE_CONTROL_RESSOURCES
