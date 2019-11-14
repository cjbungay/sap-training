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
*       text
*------------------------------------------------
*      -->P_ALV  text
*------------------------------------------------
FORM set_columns
  USING    p_alv TYPE REF TO cl_salv_table.
  DATA: lr_columns
          TYPE REF TO cl_salv_columns_table.
  DATA: lr_column
          TYPE REF TO cl_salv_column_table.
* help fields for title text
  DATA: l_scrtext_s TYPE scrtext_s,
        l_scrtext_m TYPE scrtext_m,
        l_scrtext_l TYPE scrtext_l.
* help field for tooltip
  DATA: l_lvc_tip TYPE lvc_tip.
* help field for column position
  data: l_pos type i.

**************************************************
* general columns' settings                                            *
**************************************************

* get columns object
  lr_columns = p_alv->get_columns( ).
* fix key fields
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

* show column SEATSFREE in position 6
  lr_columns->set_column_position(
      columnname = 'SEATSFREE'
      position   = 6
         ).

************************************************************************
* single columns' settings                                             *
************************************************************************
* Column SEATSFREE
* 1. get object
  TRY.
      lr_column ?= lr_columns->get_column( columnname = 'SEATSFREE' ).
    CATCH cx_salv_not_found INTO gr_error.
      cl_sapbc405_exc_handler=>process_alv_error_msg(
          r_error = gr_error
     type        =  'A'
             ).
  ENDTRY.
* 2. change titles (might as well be done via new data element)
* short
  l_scrtext_s = text-sfr.
  lr_column->set_short_text( value = l_scrtext_s ).
* medium
  l_scrtext_m = text-sfm.
  lr_column->set_medium_text( value = l_scrtext_m ).
* long
  l_scrtext_l = text-sfl.
  lr_column->set_long_text( value = l_scrtext_l ).

* 3. set tooltip
  l_lvc_tip = text-sft.
  lr_column->set_tooltip( value = l_lvc_tip ).

* column MANDT
* 1. get object
  TRY.
      lr_column ?= lr_columns->get_column( columnname = 'MANDT' ).
    CATCH cx_salv_not_found INTO gr_error.
      cl_sapbc405_exc_handler=>process_alv_error_msg(
          r_error = gr_error
     type        =  'A'
             ).
  ENDTRY.
* 2. set as technical
  lr_column->set_technical(
*    VALUE  = IF_SALV_C_BOOL_SAP=>TRUE
         ).

* column PRICE
  lr_column ?= lr_columns->get_column( columnname = 'PRICE' ).
  lr_column->set_visible(
      value  = if_salv_c_bool_sap=>false
         ).

ENDFORM.                    " set_columns
