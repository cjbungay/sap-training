*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYNS_RTTS_2                                        *
*&---------------------------------------------------------------------*
*& create internal table type at runtime and instantiate an itab       *
*& at runtime based on this type --> example of dynamic programming    *
*& This program shows a kind of DATA BROSER as example                 *
*&---------------------------------------------------------------------*

REPORT sapbc401_dyns_RTTS_2.
DATA:  ok_code LIKE sy-ucomm,  popans.

DATA:
  ref_docking TYPE REF TO cl_gui_docking_container,
  ref_alv     TYPE REF TO cl_gui_alv_grid.

DATA ref_itab TYPE REF TO data.

FIELD-SYMBOLS <fs_itab> TYPE ANY TABLE.

DATA: r_linetype TYPE REF TO cl_abap_structdescr,
      r_tabletype TYPE REF TO cl_abap_tabledescr,
      key TYPE abap_keydescr_tab.

PARAMETERS pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.

START-OF-SELECTION.
*########################################################

  r_linetype ?= cl_abap_typedescr=>describe_by_name( pa_tab ).
  r_tabletype = cl_abap_tabledescr=>create(
                  p_line_type = r_linetype ).

*** new technique with RTTC-type creation ******************
  CREATE DATA ref_itab TYPE HANDLE r_tabletype.

* old technique without type creation ***************************
*  CREATE DATA ref_itab TYPE STANDARD TABLE OF (pa_tab)
*                       WITH NON-UNIQUE DEFAULT KEY.

  ASSIGN ref_itab->* TO <fs_itab>.

  SELECT * FROM (pa_tab)
           INTO TABLE <fs_itab>
           UP TO 100 ROWS.
  IF sy-subrc <> 0.
    MESSAGE a702(bc401).
  ENDIF.

  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       initialize command input field for screen
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       set user interface
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ST100'.
  SET TITLEBAR 'T100'.
ENDMODULE.                 " STATUS_0100  OUTPUT



*&---------------------------------------------------------------------*
*&      Module  init_controls_0100  OUTPUT
*&---------------------------------------------------------------------*
*       initialize controls
*----------------------------------------------------------------------*
MODULE init_controls_0100 OUTPUT.

  IF ref_docking IS INITIAL.

    CREATE OBJECT ref_docking
      EXPORTING
*    SIDE                        = DOCK_AT_LEFT
        extension                   = 2000
      EXCEPTIONS
        OTHERS                      = 6
        .
    IF sy-subrc <> 0.
      MESSAGE a015(rfw).
    ENDIF.

    CREATE OBJECT ref_alv
      EXPORTING
        i_parent          = ref_docking
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5
        .
    IF sy-subrc <> 0.
      MESSAGE a702(bc401).
    ENDIF.


    CALL METHOD ref_alv->set_table_for_first_display
      EXPORTING
        i_structure_name              = pa_tab
      CHANGING
        it_outtab                     = <fs_itab>
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
      MESSAGE a702(bc401).
    ENDIF.

  ENDIF.

ENDMODULE.                 " init_controls_0100  OUTPUT



*&---------------------------------------------------------------------*
*&      Module  leave_programm  INPUT
*&---------------------------------------------------------------------*
*       handle interface exit commands
*----------------------------------------------------------------------*
MODULE leave_program INPUT.
  CLEAR popans.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      textline1      = text-dml
      textline2      = text-rcn
      titel          = text-cnc
      cancel_display = ' '
    IMPORTING
      answer         = popans.
  CASE popans.
    WHEN 'J'.
      LEAVE PROGRAM.
    WHEN 'N'.
      CLEAR ok_code.
  ENDCASE.
ENDMODULE.                 " leave_programm  INPUT



*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       handle other interface commands
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      CLEAR popans.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
        EXPORTING
          textline1      = text-dml
          textline2      = text-rbk
          titel          = text-bak
          cancel_display = ' '
        IMPORTING
          answer         = popans.
      IF popans = 'J'.
        LEAVE TO SCREEN 0.
      ENDIF.

    WHEN 'EXIT'.
      CLEAR popans.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
        EXPORTING
          textline1      = text-dml
          textline2      = text-rex
          titel          = text-ext
          cancel_display = ' '
        IMPORTING
          answer         = popans.
      IF popans = 'J'.
        LEAVE PROGRAM.
      ENDIF.

    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
