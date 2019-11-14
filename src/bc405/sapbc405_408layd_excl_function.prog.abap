*&---------------------------------------------------------------------*
*& Report  SAPBC408LAYD_EXCL_FUNCTIONS
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408layd_excl_functions.

* work area plus internal table for ALV data
DATA:
  wa_sbook TYPE sbook,
  it_sbook LIKE TABLE OF wa_sbook.

* data needed for layout
DATA:
  wa_layout  TYPE lvc_s_layo,
  it_excluded_functions TYPE ui_functions.

DATA:
  ok_code    LIKE sy-ucomm,
  no_set_table_needed.

DATA: cont   TYPE REF TO cl_gui_custom_container,
      alv    TYPE REF TO cl_gui_alv_grid.

SELECT-OPTIONS: so_car FOR wa_sbook-carrid MEMORY ID car,
                so_con FOR wa_sbook-connid MEMORY ID con,
                so_dat FOR wa_sbook-fldate MEMORY ID dat.

************************************************************************
START-OF-SELECTION.
  SELECT * FROM sbook
    INTO TABLE it_sbook
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.

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
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1.

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
ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
MODULE transfer_data OUTPUT.
  wa_layout-grid_title =
    'Keine Details, Filter, Summe und kein Drucken'(h01).

  IF no_set_table_needed = space.
    no_set_table_needed = 'X'.
    CALL METHOD alv->set_table_for_first_display
      EXPORTING
        i_structure_name     = 'SBOOK'
        is_layout            = wa_layout
        it_toolbar_excluding = it_excluded_functions
      CHANGING
        it_outtab            = it_sbook
      EXCEPTIONS
        OTHERS               = 1.
    IF sy-subrc <> 0.
      MESSAGE a012(bc405_408).
    ENDIF.

  ENDIF.
ENDMODULE.                 " transfer_data  OUTPUT


************************************************************************
*PAI Modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      CALL METHOD: alv->free, cont->free.
      FREE: alv, cont.
      SET SCREEN 0.
    WHEN 'TOGGLE'.
      IF it_excluded_functions IS INITIAL.
      APPEND cl_gui_alv_grid=>mc_fc_print_back TO it_excluded_functions.
      APPEND cl_gui_alv_grid=>mc_fc_detail     TO it_excluded_functions.
      APPEND cl_gui_alv_grid=>mc_fc_filter     TO it_excluded_functions.
      APPEND cl_gui_alv_grid=>mc_mb_sum        TO it_excluded_functions.
      ELSE.
        CLEAR it_excluded_functions.
      ENDIF.
      CLEAR no_set_table_needed.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
