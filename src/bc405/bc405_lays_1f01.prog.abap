*-----------------------------------------
***INCLUDE BC405_LAYS_1F01 .
*-----------------------------------------
*&----------------------------------------
*&      Form  define_settings
*&-----------------------------------------
*       main form to call specialized forms
*------------------------------------------
*      -->P_ALV  ALV object
*------------------------------------------
FORM define_settings
  USING p_alv TYPE REF TO cl_salv_table.

  PERFORM: set_display USING p_alv,
           set_columns USING p_alv.
ENDFORM.                    " define_settings
*&-------------------------------------------
*&      Form  set_display
*&-------------------------------------------
*       set general display attributs
*--------------------------------------------
*      -->P2_ALV  ALV object
*--------------------------------------------
FORM set_display
  USING p_alv  TYPE REF TO cl_salv_table.

  DATA: lr_display
          TYPE REF TO cl_salv_display_settings,
        l_title TYPE lvc_title.
* get display settings object
  lr_display = p_alv->get_display_settings( ).
* set header
  l_title = text-ttl.
  lr_display->set_list_header( value = text-ttl ).
* set horizontal lines off
  lr_display->set_horizontal_lines( value = ' ' ).
* set striped pattern
  lr_display->set_striped_pattern( value = 'X' ).


ENDFORM.                    " set_display
*&-----------------------------------------------
*&      Form  set_columns
*&-----------------------------------------------
*      -->P_ALV  text
*------------------------------------------------
FORM set_columns
  USING    p_alv TYPE REF TO cl_salv_table.
  DATA: lr_columns TYPE REF TO cl_salv_columns_table.

* get columns object
  lr_columns = p_alv->get_columns( ).
* fix key fields fix
  lr_columns->set_key_fixation(
*    VALUE  = IF_SALV_C_BOOL_SAP~TRUE
         ).

* optimize columns' width
  lr_columns->set_optimize(
*    VALUE  = IF_SALV_C_BOOL_SAP~TRUE
         ).

* bring column PLANETYPE to position 5
  lr_columns->set_column_position(
      columnname = 'PLANETYPE'
      position   = 5
         ).
ENDFORM.                    " set_columns
