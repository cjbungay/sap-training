*&---------------------------------------------------------------------*
*& Report  SAPBC408LAYD
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408layd.
TYPE-POOLS: col.

* work area plus internal table for ALV data
DATA:
  BEGIN OF wa_sbook.
INCLUDE TYPE sbook.
DATA: class_indicator,
it_colfields TYPE lvc_t_scol,
color(4),
END OF wa_sbook,
it_sbook LIKE TABLE OF wa_sbook.

DATA:
  ok_code    LIKE sy-ucomm.

DATA: cont   TYPE REF TO cl_gui_custom_container,
      alv    TYPE REF TO cl_gui_alv_grid.

DATA: variant TYPE disvariant.

*data needed for layout
DATA:  wa_layout TYPE lvc_s_layo,

* work area is required in order to fill the internal table
* with the fields/colors
  wa_colfield LIKE LINE OF wa_sbook-it_colfields,

  it_excluded_functions TYPE ui_functions,

  it_sorting_criteria  TYPE lvc_t_sort,
  wa_sorting_criterion TYPE lvc_s_sort.




******************************************************************
*selection screen
SELECT-OPTIONS: so_car FOR wa_sbook-carrid MEMORY ID car,
                so_con FOR wa_sbook-connid MEMORY ID con,
                so_dat FOR wa_sbook-fldate MEMORY ID dat.
PARAMETERS: pa_lv TYPE disvariant-variant.


******************************************************************
* at least the report name has to be passed on to the layout field.
INITIALIZATION.
  variant-report = sy-cprog.

******************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.
  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'
    CHANGING
      cs_variant  = variant
    EXCEPTIONS
      OTHERS      = 1.

  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    pa_lv = variant-variant.
  ENDIF.

*****************************************************************
START-OF-SELECTION.
  SELECT * FROM sbook
    INTO CORRESPONDING FIELDS OF TABLE it_sbook
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.

* mark lines of business customers
  LOOP AT it_sbook
    INTO wa_sbook
    WHERE custtype = 'B'.
    wa_sbook-color = 'C711'.
    MODIFY it_sbook FROM wa_sbook TRANSPORTING color.
  ENDLOOP.

* set indicator for class
  LOOP AT it_sbook
    INTO wa_sbook.
    CASE wa_sbook-class.
      WHEN 'Y'.         "Economy
        wa_sbook-class_indicator = '1'.
      WHEN 'B' OR 'C'.  "Business
        wa_sbook-class_indicator = '2'.
      WHEN 'F'.         "First
        wa_sbook-class_indicator = '3'.
    ENDCASE.
    MODIFY it_sbook FROM wa_sbook TRANSPORTING class_indicator.
  ENDLOOP.

* loop at data table and find the smokers
* set color red for the field 'SMOKER'
  LOOP AT it_sbook INTO wa_sbook
    WHERE smoker = 'X'.
    wa_colfield-fname     = 'SMOKER'.
    wa_colfield-color-col = col_negative.
    wa_colfield-color-int = '1'.
    wa_colfield-color-inv = '0'.
    APPEND wa_colfield TO wa_sbook-it_colfields.
    MODIFY it_sbook FROM wa_sbook TRANSPORTING it_colfields.
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

  IF sy-subrc <> 0 AND sy-batch IS INITIAL.
    MESSAGE a010(bc405_408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0 AND sy-batch IS INITIAL.
    MESSAGE a010(bc405_408).
  ENDIF.

*set layout
  wa_layout-grid_title = 'ALV demo'(t01).
  wa_layout-zebra      = 'X'.
  wa_layout-cwidth_opt = 'X'.
  wa_layout-sel_mode   = 'A'.
  wa_layout-info_fname = 'COLOR'.

* exception lights
  wa_layout-excp_fname = 'CLASS_INDICATOR'.

* internal table with the fields/colors to the layout structure
  wa_layout-ctab_fname = 'IT_COLFIELDS'.

* exclude functions from toolbar
  APPEND cl_gui_alv_grid=>mc_fc_print_back TO it_excluded_functions.
  APPEND cl_gui_alv_grid=>mc_fc_detail     TO it_excluded_functions.
  APPEND cl_gui_alv_grid=>mc_fc_filter     TO it_excluded_functions.
  APPEND cl_gui_alv_grid=>mc_mb_sum        TO it_excluded_functions.

* determine sorting order for first display
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
      i_structure_name     = 'SBOOK'
      is_variant           = variant
      i_save               = 'A'
      is_layout            = wa_layout
      it_toolbar_excluding = it_excluded_functions
    CHANGING
      it_outtab            = it_sbook
      it_sort          = it_sorting_criteria
    EXCEPTIONS
      OTHERS               = 1.
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
