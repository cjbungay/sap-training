*&---------------------------------------------------------------------*
*& Report  SAPBC408CTRT_DOCK_OR_DIALOG
*&                                                                     *
*&---------------------------------------------------------------------*
*& Template for displaying an ALV Grid Control in a docking container or
*& a dialogbox container.
*& In its original version, this program displays the ALV in a custom
*& container control.
*&
*& To be done:
*& - delete control area in screen 100.
*& - define cont as a docking container
*&   (instead of a custom control container)
*& - adapt CREATE OBJECT for cont
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408ctrt_dock_or_dialog.
* internal table for ALV data
DATA:
  it_sbook             TYPE TABLE OF sbook.

DATA:
  ok_code              LIKE sy-ucomm.

DATA:
  cont                 TYPE REF TO cl_gui_custom_container,
  alv                  TYPE REF TO cl_gui_alv_grid.

* needed for data transportation ABAP <-> dynpro
TABLES: sbook.

************************************************************************
START-OF-SELECTION.
  CALL SCREEN 100.

************************************************************************
*PBO modules
************************************************************************
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name    = 'CONTROL_AREA'
    EXCEPTIONS
      OTHERS            = 1.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SBOOK'
    CHANGING
      it_outtab        = it_sbook
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.
ENDMODULE.                 " create_objects  OUTPUT


************************************************************************
*PAI Modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'ALV'.
      SELECT *
        FROM sbook
        INTO TABLE it_sbook
        WHERE carrid = sbook-carrid.
      CALL METHOD alv->refresh_table_display.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      CALL METHOD: alv->free, cont->free.
      FREE: alv, cont.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
