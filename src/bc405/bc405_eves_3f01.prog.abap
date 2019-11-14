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
           set_columns USING p_alv,
           set_sorts USING p_alv,
           set_aggregs USING p_alv,
           set_selections USING p_alv,
           set_layout USING p_alv,
           set_functions USING p_alv,
           set_events USING p_alv.
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
  DATA: l_pos TYPE i.
* help field for column color
  DATA: l_lvc_s_colo TYPE lvc_s_colo.
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

*************************************************
* columns for special purposes
*************************************************
* set exception column
  lr_columns->set_exception_column(
      value     = 'USAGE'
*    GROUP     = SPACE
*    CONDENSED = IF_SALV_C_BOOL_SAP=>FALSE
         ).
* set count column
  lr_columns->set_count_column(
    value = 'LINE_COUNTER' ).

* set cell colors / line colors column
  lr_columns->set_color_column(
    value = 'IT_COLORS' ).
* CATCH CX_SALV_DATA_ERROR .

*************************************************
* single columns' settings
*************************************************
* Column SEATSFREE
* 1. get object
  TRY.
      lr_column ?= lr_columns->get_column(
                     columnname = 'SEATSFREE' ).
    CATCH cx_salv_not_found INTO gr_error.
      cl_sapbc405_exc_handler=>process_alv_error_msg(
         r_error     = gr_error
         type        = 'A'
             ).
  ENDTRY.
* 2. change titles
*   (might as well be done via new data element)
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

* set color to COL_GROUP
  l_lvc_s_colo-col = col_group.
  l_lvc_s_colo-int = 1.
  lr_column->set_color( value = l_lvc_s_colo ).


* column MANDT
* 1. get object
  TRY.
      lr_column ?= lr_columns->get_column(
                     columnname = 'MANDT' ).
    CATCH cx_salv_not_found INTO gr_error.
      cl_sapbc405_exc_handler=>process_alv_error_msg(
         r_error = gr_error
         type    = 'A'
             ).
  ENDTRY.
* 2. set as technical
  lr_column->set_technical(
*    VALUE  = IF_SALV_C_BOOL_SAP=>TRUE
         ).

* column PRICE
  lr_column ?= lr_columns->get_column(
                 columnname = 'PRICE' ).
  lr_column->set_visible(
      value  = if_salv_c_bool_sap=>false
         ).

* column ICON_FUTURE
  lr_column ?= lr_columns->get_column(
                 columnname = 'ICON_FUTURE' ).
  lr_column->set_icon( ).

  l_scrtext_s = text-fut.
  lr_column->set_short_text( value = l_scrtext_s ).
  lr_column->set_row( value = 2 ).

* column PAYMENTSUM
  lr_column ?= lr_columns->get_column(
                 columnname = 'PAYMENTSUM' ).
  lr_column->set_row( value = 2 ).

* column CURRENCY
  lr_column ?= lr_columns->get_column(
                 columnname = 'CURRENCY' ).
  lr_column->set_row( value = 2 ).

* column CARRID
  lr_column ?= lr_columns->get_column(
                 columnname = 'CARRID' ).
* set cell type
  lr_column->set_cell_type(
      value  = if_salv_c_cell_type=>hotspot
         ).

ENDFORM.                    " set_columns
*&-----------------------------------------------
*&      Form  set_sorts
*&-----------------------------------------------
*       text
*------------------------------------------------
*      -->P_ALV  text
*------------------------------------------------
FORM set_sorts
  USING  p_alv TYPE REF TO cl_salv_table.
  DATA: lr_sorts TYPE REF TO cl_salv_sorts.

* get the SORTS object
  lr_sorts = p_alv->get_sorts( ).

* add sorts
  lr_sorts->add_sort(
      columnname = 'CARRID'
      position   = 1
*    SEQUENCE   = IF_SALV_C_SORT=>SORT_UP
*    SUBTOTAL   = IF_SALV_C_BOOL_SAP=>FALSE
*    GROUP      = IF_SALV_C_SORT=>GROUP_NONE
*    OBLIGATORY = IF_SALV_C_BOOL_SAP=>FALSE
         ).

  lr_sorts->add_sort(
      columnname = 'CONNID'
      position   = 2
*    SEQUENCE   = IF_SALV_C_SORT=>SORT_UP
      subtotal   = if_salv_c_bool_sap=>true
*    GROUP      = IF_SALV_C_SORT=>GROUP_NONE
*    OBLIGATORY = IF_SALV_C_BOOL_SAP=>FALSE
         ).

  lr_sorts->add_sort(
      columnname = 'FLDATE'
      position   = 3
*    SEQUENCE   = IF_SALV_C_SORT=>SORT_UP
*    SUBTOTAL   = IF_SALV_C_BOOL_SAP=>FALSE
*    GROUP      = IF_SALV_C_SORT=>GROUP_NONE
*    OBLIGATORY = IF_SALV_C_BOOL_SAP=>FALSE
         ).

* compress subtotal's rows
*  lr_sorts->set_compressed_subtotal(
*      value  = 'CONNID'
*         ).
ENDFORM.                    " set_sorts
*&-----------------------------------------------
*&      Form  set_aggregs
*&-----------------------------------------------
*       text
*------------------------------------------------
*      -->P_ALV  text
*------------------------------------------------
FORM set_aggregs
  USING p_alv TYPE REF TO cl_salv_table.
  DATA: lr_aggregs TYPE REF TO cl_salv_aggregations.

  lr_aggregs = p_alv->get_aggregations( ).

  lr_aggregs->add_aggregation(
      columnname  = 'SEATSFREE'
      aggregation = if_salv_c_aggregation=>total
         ).

ENDFORM.                    " set_aggregs
*&-----------------------------------------------
*&      Form  set_selections
*&-----------------------------------------------
*       text
*------------------------------------------------
*      -->P_ALV  text
*------------------------------------------------
FORM set_selections
  USING p_alv TYPE REF TO cl_salv_table.
  DATA: lr_selections TYPE REF TO cl_salv_selections.

* get the SELECTIONS object
  lr_selections = p_alv->get_selections( ).
* set the selection mode
  lr_selections->set_selection_mode(
      value  = if_salv_c_selection_mode=>cell
         ).

ENDFORM.                    " set_selections
*&-----------------------------------------------
*&      Form  set_layout
*&-----------------------------------------------
*       text
*------------------------------------------------
*      -->P_ALV  text
*------------------------------------------------
FORM set_layout
  USING p_alv TYPE REF TO cl_salv_table.
  DATA: lr_layout TYPE REF TO cl_salv_layout,
        ls_key TYPE salv_s_layout_key.

* get the LAYOUT object
  lr_layout = p_alv->get_layout( ).
* set the layout key
  ls_key-report = sy-cprog.
  lr_layout->set_key( value = ls_key ).

* set save restriction
*  (none restriction is intended, so we may use the default)
  lr_layout->set_save_restriction(
*    VALUE  = IF_SALV_C_LAYOUT=>RESTRICT_NONE
         ).

* allow setting a default layout
  lr_layout->set_default( value = 'X' ).

* set initial layout
  lr_layout->set_initial_layout( value = p_layout ).

ENDFORM.                    " set_layout
*&-----------------------------------------------
*&      Form  set_functions
*&-----------------------------------------------
*      -->P_ALV  text
*------------------------------------------------
FORM set_functions
  USING p_alv TYPE REF TO cl_salv_table.

  DATA: lr_functions
          TYPE REF TO cl_salv_functions_list.

* help variables for method call ADD_FUNCTION
  DATA: l_icon TYPE string,
        l_text TYPE string,
        l_tooltip TYPE string.

* get the FUNCTIONS object
  lr_functions = p_alv->get_functions( ).
* offer all generic functions
  lr_functions->set_all(
*    VALUE  = IF_SALV_C_BOOL_SAP=>TRUE
         ).
* subtract average
  lr_functions->set_aggregation_average(
      value  = if_salv_c_bool_sap=>false
         ).
* subtract all export functions
  lr_functions->set_group_export(
      value  = if_salv_c_bool_sap=>false
         ).

* customer defined function:
*   display occupied seats columns most left
*   and highlight them
  IF pa_cont = 'X'.
    l_icon = icon_insert_row.
    l_text = text-tot.
    l_tooltip = text-ttt.
    lr_functions->add_function(
        name     = 'REORDER'
        icon     = l_icon
        text     = l_text
        tooltip  = l_tooltip
        position = if_salv_c_function_position=>right_of_salv_functions
           ).
  ENDIF.

ENDFORM.                    " set_functions
*&------------------------------------------------
*&      Form  set_events
*&------------------------------------------------
*      -->P_ALV  text
*-------------------------------------------------
FORM set_events
  USING p_alv TYPE REF TO cl_salv_table.

  DATA: lr_event TYPE REF TO cl_salv_events_table.
* get the EVENT object
  lr_event = p_alv->get_event( ).

  SET HANDLER:
    lcl_handler=>on_added_function FOR lr_event,
    lcl_handler=>on_double_click FOR lr_event,
    lcl_handler=>on_link_click FOR lr_event.
ENDFORM.  " set_events
