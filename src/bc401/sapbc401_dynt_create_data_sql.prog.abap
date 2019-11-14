*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYNT_CREATE_DATA_SQL                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc401_dynt_create_data_sql    .

DATA:
  ok_code LIKE sy-ucomm,
  popans.

DATA:
  ref_docking TYPE REF TO cl_gui_docking_container.

PARAMETERS pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.




START-OF-SELECTION.

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
