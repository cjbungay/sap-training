*----------------------------------------------------------------------*
***INCLUDE BC405_LAYD_COMPLETEF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  set_everything
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GR_ALV  text
*----------------------------------------------------------------------*
FORM set_everything
  USING    p_alv TYPE REF TO cl_salv_table.

  PERFORM: set_display USING p_alv,
           set_selections USING p_alv.

ENDFORM.                    " set_everything
*&---------------------------------------------------------------------*
*&      Form  set_display
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PL_ALV  text
*----------------------------------------------------------------------*
FORM set_display
  USING    p_alv TYPE REF TO cl_salv_table.

  DATA: ls_display TYPE REF TO cl_salv_display_settings,
        l_title TYPE lvc_title.

* get object for display attributes
  ls_display = p_alv->get_display_settings( ).
* set title
  l_title = text-ttl.
  ls_display->set_list_header( value = l_title ).
* header size
  IF pa_cont = 'X' OR pa_full = 'X'.
    ls_display->set_list_header_size(
      value = cl_salv_display_settings=>c_header_size_medium  ).
  ENDIF.
* suppress empty table
  IF pa_list = 'X'.
    ls_display->set_suppress_empty_data(
      value = if_salv_c_bool_sap=>true  ).
  ENDIF.

 ls_display->set_horizontal_lines( value =  if_salv_c_bool_sap=>false )
.
  ls_display->set_vertical_lines( value = if_salv_c_bool_sap=>true  ).
  ls_display->set_striped_pattern( value =  if_salv_c_bool_sap=>true ).


ENDFORM.                    " set_display
*&---------------------------------------------------------------------*
*&      Form  set_selections
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_selections
  USING p_alv TYPE REF TO cl_salv_table.

  DATA: lr_selections TYPE REF TO cl_salv_selections.
  lr_selections = p_alv->get_selections( ).

  CASE 'X'.
    WHEN pa_full OR pa_cont. " Fullscreen or Container
      CASE 'X'.
        WHEN pa_multi.
* multiple: several columns, several rows, no row button
          lr_selections->set_selection_mode(
            value  = if_salv_c_selection_mode=>multiple ).

        WHEN pa_cell.
* cell: several columns, several rows, several cells, with row button
          lr_selections->set_selection_mode(
            value  = if_salv_c_selection_mode=>cell ).

        WHEN pa_row_c.
* row_column: several columns, several rows, with row button
          lr_selections->set_selection_mode(
            value  = if_salv_c_selection_mode=>cell ).

        WHEN pa_none.
* none: several columns, one row, no row button
          lr_selections->set_selection_mode(
            value  = if_salv_c_selection_mode=>none ).

      ENDCASE.

    WHEN pa_list. " classical ABAP list
      CASE 'X'.
        WHEN pa_lsing.
* SINGLE: several columns, several rows, row check box
          lr_selections->set_selection_mode(
            value  = if_salv_c_selection_mode=>single ).

        WHEN pa_lnone.
* none: several columns, no row, no row button
          lr_selections->set_selection_mode(
            value  = if_salv_c_selection_mode=>none ).

      ENDCASE.
  ENDCASE.
ENDFORM.                    " set_selections
