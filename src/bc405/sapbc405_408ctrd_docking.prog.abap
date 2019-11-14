*&---------------------------------------------------------------------*
*& Report  SAPBC408CTRD_DOCKING
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408ctrd_docking.

* internal table for ALV data
DATA:
  it_sbook             TYPE TABLE OF sbook.

DATA:
  ok_code              LIKE sy-ucomm.

DATA:
  cont                 TYPE REF TO cl_gui_docking_container,
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
     side                     = cl_gui_docking_container=>dock_at_right
      extension               = 600
      caption                 = 'Test'(001)
    EXCEPTIONS
      OTHERS                  = 1.
  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

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
