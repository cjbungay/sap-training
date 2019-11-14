*&---------------------------------------------------------------------*
*& Report  SAPBC408LAYD_sort
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408layd_sort.

* work area plus internal table for ALV data
DATA:
  wa_sbook             TYPE sbook,
  it_sbook             LIKE TABLE OF wa_sbook.

* data needed for layout
DATA:
  wa_layout            TYPE lvc_s_layo,
  it_sorting_criteria  TYPE lvc_t_sort,
  wa_sorting_criterion TYPE lvc_s_sort.

DATA:
  ok_code              LIKE sy-ucomm.

DATA:
  cont                 TYPE REF TO cl_gui_custom_container,
  alv                  TYPE REF TO cl_gui_alv_grid.

SELECT-OPTIONS:
  so_car FOR wa_sbook-carrid MEMORY ID car,
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
    MESSAGE a010(bc408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc408).
  ENDIF.

  wa_layout-grid_title =
    'Preset sorting order'(h01). "#EC *

  wa_sorting_criterion-fieldname = 'ORDER_DATE'.
*  wa_sorting_criterion-down = 'X'.
*  wa_sorting_criterion-up = space.
*  wa_sorting_criterion-spos = 1.
  APPEND wa_sorting_criterion TO it_sorting_criteria.

  clear wa_sorting_criterion.
  wa_sorting_criterion-fieldname = 'CUSTOMID'.
  wa_sorting_criterion-up = 'X'.
*  wa_sorting_criterion-spos = 2.
  APPEND wa_sorting_criterion TO it_sorting_criteria.


  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SBOOK'
      is_layout        = wa_layout
    CHANGING
      it_outtab        = it_sbook
      it_sort          = it_sorting_criteria
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc408).
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
