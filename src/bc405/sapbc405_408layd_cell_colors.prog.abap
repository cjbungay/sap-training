*&---------------------------------------------------------------------*
*& Report  SAPBC408LAYD_CELL_COLORS
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408layd_cell_colors.

* allow symbolic names for colors, e.g. col_normal
TYPE-POOLS: col.

* work area plus internal table for ALV data and color information
DATA BEGIN OF wa_sbook.
INCLUDE TYPE sbook.
DATA: it_colfields TYPE lvc_t_scol,
END OF wa_sbook.
DATA: it_sbook LIKE TABLE OF wa_sbook.

* data needed for layout
DATA:
wa_colfield  LIKE LINE OF wa_sbook-it_colfields,
  wa_layout  TYPE lvc_s_layo.


DATA:
  ok_code    LIKE sy-ucomm.

DATA: cont   TYPE REF TO cl_gui_custom_container,
      alv    TYPE REF TO cl_gui_alv_grid.

SELECT-OPTIONS: so_car FOR wa_sbook-carrid MEMORY ID car,
                so_con FOR wa_sbook-connid MEMORY ID con,
                so_dat FOR wa_sbook-fldate MEMORY ID dat.

START-OF-SELECTION.
  SELECT * FROM sbook
    INTO CORRESPONDING FIELDS OF TABLE it_sbook
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.

  LOOP AT it_sbook INTO wa_sbook
    WHERE smoker = 'X'.
    wa_colfield-fname = 'SMOKER'.
    wa_colfield-color-col = col_negative.
    wa_colfield-color-int = 1.
    wa_colfield-color-inv = 0.
    wa_colfield-nokeycol = 'X'.
    APPEND wa_colfield TO wa_sbook-it_colfields.

    MODIFY it_sbook
      FROM wa_sbook
      TRANSPORTING it_colfields.
  ENDLOOP.

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

  wa_layout-grid_title = 'Flüge'(h01).

*internal table that contains information on cell color
  wa_layout-ctab_fname = 'IT_COLFIELDS'.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SBOOK'
      is_layout        = wa_layout
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
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      CALL METHOD: alv->free, cont->free.
      FREE: alv, cont.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
