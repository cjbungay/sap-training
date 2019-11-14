*&---------------------------------------------------------------------*
*& Report  SAPBC408OTHD_EDITABLE_ALV                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC405_408OTHD_EDITABLE_ALV.

DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight,
      ok_code TYPE sy-ucomm.

DATA: cont TYPE REF TO cl_gui_custom_container,
      alv TYPE REF TO cl_gui_alv_grid.
DATA: my_variant TYPE disvariant.
DATA: my_print TYPE lvc_s_prnt.
data: my_fcat type lvc_t_fcat,
      wa_fcat type lvc_s_fcat.

SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.
SELECTION-SCREEN SKIP.
PARAMETERS: pa_lv TYPE slis_vari.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.
  PERFORM get_layout_variant CHANGING my_variant.
  pa_lv = my_variant-variant.
  CLEAR my_variant.

START-OF-SELECTION.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE get_data OUTPUT.

  SELECT * FROM sflight
  INTO TABLE it_sflight
  WHERE carrid IN so_car
  AND   connid IN so_con.

ENDMODULE.                 " get_data  OUTPUT

*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1
      .
  IF sy-subrc <> 0.
    MESSAGE i010(bc405_408).  " Type I to avoid end of batch processing
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1
      .
  IF sy-subrc <> 0.
    MESSAGE i010(bc405_408).   " Type I to avoid end of batch processing
  ENDIF.

  my_variant-report = sy-cprog.
  IF NOT pa_lv IS INITIAL.
    my_variant-variant = pa_lv.
  ENDIF.

  my_print-grpchgedit = 'X'.

  clear wa_fcat.
  wa_fcat-fieldname = 'PLANETYPE'.
  wa_fcat-edit = 'X'.
  append wa_fcat to my_fcat.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
      is_variant       = my_variant
      i_save           = 'A'
      is_print         = my_print
    CHANGING
      it_outtab        = it_sflight
      it_fieldcatalog  = my_fcat
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc <> 0.
    MESSAGE i012(bc405_408).   " Type I to avoid end of batch processing
  ENDIF.

  CALL METHOD alv->set_ready_for_input
    EXPORTING i_ready_for_input = 1.

ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT

*----------------------------------------------------------------------*
FORM free.
  CALL METHOD: alv->free,
               cont->free.

  FREE: alv,
        cont.
ENDFORM.                    " free

*----------------------------------------------------------------------*
FORM get_layout_variant CHANGING p_variant TYPE disvariant.

  p_variant-report = sy-cprog.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'
    CHANGING
      cs_variant  = p_variant
    EXCEPTIONS
      OTHERS      = 1.
  IF sy-subrc <> 0.
    MESSAGE e065(bc405_408).
*   Keine Anzeigevariante gefunden.
*   No layout variant found
  ENDIF.

ENDFORM.                    " get_layout_variant
