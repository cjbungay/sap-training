*&---------------------------------------------------------------------*
*& Report  SAPBC412_GRDD_FUNCTIONALITY                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  BC412 unit 'SAP Grid Control'.                                     *
*&  Demo program that can be used to show the functionality of the SAP *
*&  Grid Control.                                                      *
*&  SFLIGHT data is displayed in an ALV Grid Control. There are three  *
*&  bushbuttons in the application toolbar that allow                  *
*&  - to change a few layout parameters                                *
*&  - to change the list contents (data to be displayed)               *
*&  - to switch to the initial list again                              *
*&---------------------------------------------------------------------*

REPORT  sapbc412_grdd_functionality.

DATA:
* global screen fields
  fcode                TYPE sy-ucomm,
  copy_fcode           LIKE fcode,

* object references
  ref_custom_container TYPE REF TO cl_gui_custom_container,
  ref_alv              TYPE REF TO cl_gui_alv_grid,

* alv data
  it_sflight           TYPE STANDARD TABLE OF sflight,
  alv_layout           TYPE lvc_s_layo," alv screen layout

* auxiliary
  carrid               TYPE sflight-carrid,
  connid               TYPE sflight-connid,
  return_code          TYPE sy-subrc,
  change_flag          TYPE c,

* fields on screen 150 (Layout-Selection-Screen) -> switches
  header_on, header_off,               " header line
  horizontal_on, horizontal_off,       " horizontal grid lines
  vertical_on, vertical_off,           " vertical grid lines
  toolbar_on, toolbar_off,             " toolbar
  col_header_on, col_header_off,       " column headers
  zebra_on, zebra_off,                 " display_mode
  single_line, multiple_line, cell,    " grid sel_mode

  grid_title           TYPE lvc_s_layo-grid_title.


CONSTANTS:
  c_mark VALUE 'X',
  c_on   VALUE '1',
  c_off  VALUE '0'.


SELECTION-SCREEN BEGIN OF SCREEN 1100.
  SELECT-OPTIONS:
    so_carr FOR carrid,
    so_conn FOR connid.
SELECTION-SCREEN END OF SCREEN 1100.

* includes
*INCLUDE BC412_ALVD_FUNCTION_LCL_APPL.  " local class for application


START-OF-SELECTION.

* set special initial values for grid layout
  grid_title = 'List of flights for LH 400'(051).
  header_off = c_mark.

  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&---------------------------------------------------------------------*
*       control related processings
*----------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF ref_custom_container IS INITIAL.

*   create custom container object
    CREATE OBJECT ref_custom_container
      EXPORTING
        container_name = 'CONTAINER_AREA1'
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   create alv grid control object and link to container
    CREATE OBJECT ref_alv
      EXPORTING
*       i_shellstyle  =
*       I_LIFETIME    =
        i_parent      = ref_custom_container
*       I_APPL_EVENTS =
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   fetch and store data into internal table
    SELECT * FROM  sflight INTO TABLE it_sflight.

*   show data in alv
    CALL METHOD ref_alv->set_table_for_first_display
      EXPORTING
        i_structure_name     = 'SFLIGHT'" name of itab structure (DDIC)
*       IS_VARIANT           =          " type DISVARIANT
*       I_SAVE               =          " ' ', no save possible
*                                       " 'U', user specific variants
*                                       " 'X', only user independent var
*                                       " 'A', all variants possible
*       I_DEFAULT            =          " default variant possible
*       is_layout            =          " type LVC_S_LAYO
*       IS_PRINT             =          " type LVC_S_PRNT
*       IT_SPECIAL_GROUPS    =          " type LVC_T_SGRP
*       IT_TOOLBAR_EXCLUDING =          " type UI_FUNC
      CHANGING
        it_outtab            = it_sflight
*       IT_FIELDCATALOG      =          " type LVC_T_FCAT
*       IT_SORT              =          " type LVC_T_SORT
*       IT_FILTER            =          " type LVC_T_FILT
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       implementation of user commands of type ' '
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE copy_fcode.
    WHEN 'BACK'.                       " leave screen

      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.

    WHEN 'CHG_LAYOUT'.                 " change grid layout

      PERFORM change_grid_layout_data.
      IF NOT change_flag IS INITIAL.
        CALL METHOD ref_alv->refresh_table_display.
        CLEAR change_flag.
      ENDIF.

    WHEN 'CHG_DATA'.                   " change alv contents

      PERFORM change_itab_contents CHANGING return_code.
      IF return_code = 0.              " do only refresh if changed
        CALL METHOD ref_alv->refresh_table_display.
      ENDIF.

    WHEN 'UNDO'.                       " restart program

      PERFORM free_control_ressources.
      SUBMIT sapbc412_alvd_functionality.

  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       GUI settings
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'SCREEN_0100_NORMAL'.
  SET TITLEBAR  'SCREEN_0100_NORMAL'.

ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       implementation of user commands of type 'E'
*----------------------------------------------------------------------*
MODULE exit_command_0100 INPUT.
  CASE fcode.
    WHEN 'CANCEL'.                     "Abbrechen
      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.                       "Beenden
      PERFORM free_control_ressources.
      LEAVE PROGRAM.
    WHEN OTHERS.

  ENDCASE.


ENDMODULE.                             " EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  DEFAULT_FCODE_PROCESSING  INPUT
*&---------------------------------------------------------------------*
*       1. filter control events --> control_dispatch
*       2. fcode --> copy_fcode
*----------------------------------------------------------------------*
MODULE default_fcode_processing INPUT.
*
* -> control_dispatch
  CALL METHOD cl_gui_cfw=>dispatch.

  copy_fcode = fcode.
  CLEAR fcode.

ENDMODULE.                             " DEFAULT_FCODE_PROCESSING  INPUT

*&---------------------------------------------------------------------*
*&      Form  FREE_CONTROL_RESSOURCES
*&---------------------------------------------------------------------*
*       free ressources of front end controls (basic list)
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM free_control_ressources.
  CALL METHOD: ref_alv->free,
               ref_custom_container->free.
  FREE: ref_alv,
        ref_custom_container.
ENDFORM.                               " FREE_CONTROL_RESSOURCES

*&---------------------------------------------------------------------*
*&      Form  CHANGE_GRID_LAYOUT_DATA
*&---------------------------------------------------------------------*
*       perform user dialog to change screen layout
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_grid_layout_data.
  CALL SCREEN 150 STARTING AT 5 5.

ENDFORM.                               " CHANGE_GRID_LAYOUT_DATA

*&---------------------------------------------------------------------*
*&      Form  CHANGE_ITAB_CONTENTS
*&---------------------------------------------------------------------*
*       change the content of the internal table for the basic list
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_itab_contents CHANGING rc TYPE sy-subrc.
  CALL SELECTION-SCREEN 1100 STARTING AT 5 5.

  rc = sy-subrc.
  IF sy-subrc EQ 0.
    SELECT  * FROM  sflight INTO TABLE it_sflight
           WHERE  carrid  IN so_carr
           AND    connid  IN so_conn.
  ENDIF.

ENDFORM.                               " CHANGE_ITAB_CONTENTS

*&---------------------------------------------------------------------*
*&      Module  STATUS_0150  OUTPUT
*&---------------------------------------------------------------------*
*       GUI settings screen 0150
*----------------------------------------------------------------------*
MODULE status_0150 OUTPUT.
  SET PF-STATUS 'STATUS_0150'.
  SET TITLEBAR  'TITLE_0150'.
  CLEAR: fcode.
ENDMODULE.                             " STATUS_0150  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0150  INPUT
*&---------------------------------------------------------------------*
*       implementation of user commands of type ' ' for screen 0150
*----------------------------------------------------------------------*
MODULE user_command_0150 INPUT.
  CASE fcode.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'OK'.
*     get current layout from proxy
      CALL METHOD ref_alv->get_frontend_layout
        IMPORTING
          es_layout = alv_layout.

*     list header
      CASE c_mark.
        WHEN header_on.
          alv_layout-grid_title = grid_title.
          "'List of flights for LH 400'(051).
        WHEN header_off.
          CLEAR alv_layout-grid_title.
      ENDCASE.

*     horizontal grid lines
      alv_layout-no_hgridln = horizontal_off.

*     vertical   grid lines
      alv_layout-no_vgridln = vertical_off.

*     toolbar display
      alv_layout-no_toolbar = toolbar_off.

*     column headings
      alv_layout-no_headers = col_header_off.

*     alternating line colors
      alv_layout-zebra      = zebra_on.

*     selection mode : line, single cell, multiple cells
      CASE c_mark.
        WHEN single_line.
          alv_layout-sel_mode   = 'B'.
        WHEN multiple_line.
          alv_layout-sel_mode   = 'C'.
        WHEN cell.
          alv_layout-sel_mode   = 'D'.                      "
      ENDCASE.

*     send new settings to proxy
      CALL METHOD ref_alv->set_frontend_layout
        EXPORTING
          is_layout = alv_layout.

*     set change indicator
      change_flag = 'X'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0150  INPUT

*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       Screen modification in reaction to a user interaction
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  CHECK header_off = c_mark.
  LOOP AT SCREEN.
    IF screen-name = 'GRID_TITLE'.
      screen-active = c_off.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.                             " MODIFY_SCREEN  OUTPUT
