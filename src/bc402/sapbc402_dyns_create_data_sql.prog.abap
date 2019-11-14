*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYNS_CREATE_DATA_SQL
*&
*&---------------------------------------------------------------------*
*& Optional Solution: Output realized as classical ALV Grid Control
*&
*&---------------------------------------------------------------------*
REPORT  sapbc402_dyns_create_data_sql.

*----------------------------------------------------------------------*
DATA:
    ok_code LIKE sy-ucomm,
    popans,

    gr_docking TYPE REF TO cl_gui_docking_container,
    gr_alv     TYPE REF TO cl_gui_alv_grid,

    gr_itab TYPE REF TO data.

*----------------------------------------------------------------------*
FIELD-SYMBOLS:
    <fs_itab> TYPE ANY TABLE.

*----------------------------------------------------------------------*
PARAMETERS:
    pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.

*======================================================================*
START-OF-SELECTION.
*----------------------------------------------------------------------*

  CREATE DATA gr_itab  TYPE STANDARD TABLE OF (pa_tab)
                       WITH NON-UNIQUE DEFAULT KEY.

  ASSIGN gr_itab->* TO <fs_itab>.

  SELECT * FROM (pa_tab)
           INTO TABLE <fs_itab>
           UP TO 100 ROWS
           .
  IF sy-subrc <> 0.
    MESSAGE e041(bc402).
  ENDIF.

*--Optional-Output-----------------------------------------------------*
  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ST100'.
  SET TITLEBAR 'T100'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_controls_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE init_controls_0100 OUTPUT.

  IF gr_docking IS INITIAL.

    CREATE OBJECT gr_docking
      EXPORTING
*    SIDE                        = DOCK_AT_LEFT
        extension                   = 2000
      EXCEPTIONS
        OTHERS                      = 6
        .
    IF sy-subrc <> 0.
      MESSAGE a015(rfw).
    ENDIF.

    CREATE OBJECT gr_alv
      EXPORTING
        i_parent          = gr_docking
      EXCEPTIONS
        OTHERS            = 5
        .
    IF sy-subrc <> 0.
      MESSAGE a015(rfw).
    ENDIF.

  ENDIF.

  gr_alv->set_table_for_first_display(
    EXPORTING
      i_structure_name              = pa_tab
    CHANGING
      it_outtab                     = <fs_itab>
    EXCEPTIONS
      OTHERS                        = 4
         ).
  IF sy-subrc <> 0.
    MESSAGE a020(rfw).
  ENDIF.

ENDMODULE.                 " init_controls_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  leave_programm  INPUT
*&---------------------------------------------------------------------*
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
