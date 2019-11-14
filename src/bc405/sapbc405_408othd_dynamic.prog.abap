*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

INCLUDE bc405_408othd_dynamictop.

*&---------------------------------------------------------------------*
AT SELECTION-SCREEN.
  SELECT SINGLE * FROM dd02l
    WHERE tabname = pa_tab.
  IF sy-subrc <> 0
    OR dd02l-tabclass = 'INTTAB'
    OR dd02l-tabclass = 'APPEND'
    OR dd02l-as4local <> 'A'.
    MESSAGE e030(bc405_408) WITH pa_tab.
  ENDIF.

*&---------------------------------------------------------------------*
START-OF-SELECTION.
  CREATE DATA d_ref_itab TYPE TABLE OF (pa_tab).
  ASSIGN d_ref_itab->* TO <fs_src_itab>.

  SELECT * FROM (pa_tab)
    INTO CORRESPONDING FIELDS OF TABLE <fs_src_itab>
    UP TO pa_max ROWS.
  wa_layout-grid_title = pa_tab.

  CALL SCREEN 100.

*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.

  IF g_custom_container IS INITIAL.
    CREATE OBJECT g_custom_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.

    CREATE OBJECT alv_grid
      EXPORTING
        i_parent = g_custom_container.
  ENDIF.

ENDMODULE.                             " CREATE_OBJECTS  OUTPUT

*----------------------------------------------------------------------*
MODULE transfer_data OUTPUT.
  ON CHANGE OF pa_tab.
    CALL METHOD alv_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = pa_tab
        is_layout        = wa_layout
      CHANGING
        it_outtab        = <fs_src_itab>.
  ENDON.
ENDMODULE.                             " TRANSFER_DATA  OUTPUT


*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH pa_tab.
ENDMODULE.                             " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT
