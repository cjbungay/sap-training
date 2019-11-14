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
           set_columns USING p_alv,
           set_sorts   USING p_alv,
           set_aggregs USING p_alv,
           set_filters USING p_alv,
           set_selections USING p_alv,
           set_layout USING p_alv,
           set_functions USING p_alv,
           set_events USING p_alv,
           set_func_settings USING p_alv,
           set_print USING p_alv,
           set_header_footer USING p_alv.

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
*&-----------------------------------------------
*&      Form  set_columns
*&-----------------------------------------------
*       set columns' properties
*------------------------------------------------
*      -->P_ALV  text
*------------------------------------------------
FORM set_columns
  USING p_alv TYPE REF TO cl_salv_table.

  DATA: lr_columns
          TYPE REF TO cl_salv_columns_table,
        lr_column TYPE REF TO cl_salv_column_table.
*        lr_help_column TYPE REF TO cl_salv_column.
  DATA: l_shorttext TYPE scrtext_s,
        l_mediumtext TYPE scrtext_m,
        l_ddic_reference TYPE salv_s_ddic_reference.

  DATA: l_lvc_s_colo TYPE lvc_s_colo.

* get columns' object
  lr_columns = p_alv->get_columns( ).
************************************************************************
* settings valid for all columns                                       *
************************************************************************
* optimize columns' width
  lr_columns->set_optimize( ).
* fix key columns
  lr_columns->set_key_fixation( ).
* display column PASSNAME next to column CUSTOMID
  lr_columns->set_column_position(
      columnname = 'PASSNAME'
      position   = 6
         ).

  lr_columns->set_column_position(
      columnname = 'TELEPHONE'
      position   = 7
         ).

  lr_columns->set_column_position(
      columnname = 'LEAVES_HOME'
      position   = 8
         ).

  lr_columns->set_column_position(
      columnname = 'GOES_HOME'
      position   = 9
         ).

*************************************************
* setting columns with special purposes
*************************************************

* set exception column
  lr_columns->set_exception_column(
      value     = 'EXCEPTION'
      group     = '1'
*    CONDENSED = IF_SALV_C_BOOL_SAP=>FALSE
         ).
* set count column
  lr_columns->set_count_column( value = 'COUNT_COL' ).

* set color column
  lr_columns->set_color_column( value = 'IT_COLORS' ).

* set cell type column
  lr_columns->set_cell_type_column( value = 'IT_CELL_TYPES' ).

* set hyperlink control column (not possible for class. ABAP list)
  IF pa_list NE 'X'.
    lr_columns->set_hyperlink_entry_column( value = 'IT_HYPERLINKS' ).
  ENDIF.

*************************************************
* settings valid for one column
*************************************************
* get MANDT column object - functional writing
  lr_column ?= lr_columns->get_column( columnname = 'MANDT' ).

* column MANDT
* get MANDT column object - classical writing
*  CALL METHOD lr_columns->get_column
*    EXPORTING
*      columnname = 'MANDT'
*    RECEIVING
*      value      = lr_help_column.
*
*  lr_column ?= lr_help_column.
* set column as technical - will never been shown
  lr_column->set_technical( ).
* column LEAVES_HOME
  lr_column ?= lr_columns->get_column( columnname = 'LEAVES_HOME' ).

  l_shorttext = text-lvs. " leaving home
  lr_column->set_short_text( value = l_shorttext ).

  IF pa_list NE 'X'.
    lr_column->set_cell_type(
      value  = if_salv_c_cell_type=>checkbox_hotspot ).
  ELSE.
    lr_column->set_cell_type(
      value  = if_salv_c_cell_type=>checkbox ).
  ENDIF.

* column GOES_HOME
  lr_column ?= lr_columns->get_column( columnname = 'GOES_HOME' ).

  l_shorttext = text-cms. " coming home
  lr_column->set_short_text( value = l_shorttext ).

  IF pa_list NE 'X'.
    lr_column->set_cell_type(
      value  = if_salv_c_cell_type=>checkbox_hotspot ).
  ELSE.
    lr_column->set_cell_type(
      value  = if_salv_c_cell_type=>checkbox ).
  ENDIF.

* column TELEPHONE
  lr_column ?= lr_columns->get_column( columnname = 'TELEPHONE' ).
  lr_column->set_cell_type( value  = if_salv_c_cell_type=>hotspot ).

* set column's color
  l_lvc_s_colo-col = col_group.
  l_lvc_s_colo-int = 0.
  l_lvc_s_colo-inv = 1.
  lr_column->set_color( value = l_lvc_s_colo  ).

* set alignment
  lr_column->set_alignment( value  = if_salv_c_alignment=>right ).

* get DDIC reference (ain't necessary, just to show writing)
*  l_ddic_reference = lr_column->get_ddic_reference( ).

* set DDIC reference (data element into component "table")
  CLEAR l_ddic_reference.
* example: DDIC reference via DDIC table field ...
  l_ddic_reference-field = 'TELEPHONE'.
  l_ddic_reference-table = 'SAPBC405_CUSTOMERS'.
  lr_column->set_ddic_reference( value = l_ddic_reference ).

* column INVOICE_ICON
  lr_column ?= lr_columns->get_column( columnname = 'INVOICE_ICON' ).
* set it as icon column
  lr_column->set_icon(
*    VALUE  = IF_SALV_C_BOOL_SAP=>TRUE
         ).

* set DDIC reference (data element into component "table")
  CLEAR l_ddic_reference.
* example: DDIC reference via DDIC table field ...
  l_ddic_reference-field = 'INVOICE'.
  l_ddic_reference-table = 'SBOOK'.
  lr_column->set_ddic_reference( value = l_ddic_reference ).


* column FORCURAM
*  lr_column ?= lr_columns->get_column( columnname = 'FORCURAM' ).

*  example for setting currency
*  a) via one value for the whole column
*  b) via one value for each amount, i.e. via a control column
*  (ain't a very useful example, that's why it is commented out!)

*  lr_column->set_currency( value = 'JPY'  ).
*  lr_column->set_currency_column( value = 'LOCCURKEY' ).

* column LUGGWEIGHT
*  lr_column ?= lr_columns->get_column( columnname = 'LUGGWEIGHT' ).
*  lr_column->set_row( value = 2 ).
* column WUNIT
*  lr_column ?= lr_columns->get_column( columnname = 'WUNIT' ).
*  lr_column->set_row( value = 2 ).

* column CANCELLED
  lr_column ?= lr_columns->get_column( columnname = 'CANCELLED' ).
  lr_column->set_cell_type( value  = if_salv_c_cell_type=>checkbox ).

* column ADDITIONAL_INFOS
  lr_column ?=
    lr_columns->get_column( columnname = 'ADDITIONAL_INFOS' ).

  l_mediumtext = text-add. " leaving home
  lr_column->set_medium_text( value = l_mediumtext ).

ENDFORM.                    " set_columns
*&---------------------------------------------------------------------*
*&      Form  set_sorts
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_sorts  USING    p_alv TYPE REF TO cl_salv_table.
  DATA: lr_sorts TYPE REF TO cl_salv_sorts,
        lr_sort  TYPE REF TO cl_salv_sort.

* get SORTS object
  lr_sorts = p_alv->get_sorts( ).
* enable grouping
  lr_sorts->set_group_active(
*    VALUE  = IF_SALV_C_BOOL_SAP=>TRUE
         ).

* add sort objects for CARRID, CONNID, and FLDATE
  lr_sorts->add_sort(
    columnname = 'CARRID'
    position   = 1
*    SEQUENCE   = IF_SALV_C_SORT=>SORT_UP
*    SUBTOTAL   = IF_SALV_C_BOOL_SAP=>FALSE
*    group      = if_salv_c_sort=>group_with_newpage
*    OBLIGATORY = IF_SALV_C_BOOL_SAP=>FALSE
         ).

  lr_sorts->add_sort(
    columnname = 'CONNID'
    position   = 2
*    SEQUENCE   = IF_SALV_C_SORT=>SORT_UP
    subtotal   = if_salv_c_bool_sap=>true
    group      = if_salv_c_sort=>group_with_newpage
*    OBLIGATORY = IF_SALV_C_BOOL_SAP=>FALSE
         ).

  lr_sorts->add_sort(
    columnname = 'FLDATE'
    position   = 3
*    SEQUENCE   = IF_SALV_C_SORT=>SORT_UP
*    subtotal   = if_salv_c_bool_sap=>true
    group      = if_salv_c_sort=>group_with_newpage
*    OBLIGATORY = IF_SALV_C_BOOL_SAP=>FALSE
         ).

* change sort of FLDATE: Grouping shall be with underline
*  - only for demonstration purpose - could better be done
*    with method ADD_SORT
* 1.get sort object for column FLDATE
  lr_sort = lr_sorts->get_sort( columnname = 'FLDATE' ).
* 2.set grouping new
  lr_sort->set_group(
      value = if_salv_c_sort=>group_with_underline
      ).

ENDFORM.                    " set_sorts
*&---------------------------------------------------------------------*
*&      Form  set_aggregs
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_aggregs  USING    p_alv TYPE REF TO cl_salv_table.
  DATA: lr_aggregs TYPE REF TO cl_salv_aggregations,
        lr_aggreg  TYPE REF TO cl_salv_aggregation.

* 1. get AGGREGATIONS object
  lr_aggregs = p_alv->get_aggregations( ).
* 2. add an aggregation
  lr_aggregs->add_aggregation(
      columnname  = 'LUGGWEIGHT'
      aggregation = if_salv_c_aggregation=>total
         ).

* change an aggregation - only for demonstration purpose - better
*   done with method ADD_AGGREGATION
* 1. get AGGREGATION object
  lr_aggreg = lr_aggregs->get_aggregation(
                columnname = 'LUGGWEIGHT' ).

* 2. change aggregation type to average
  lr_aggreg->set(
      aggregation = if_salv_c_aggregation=>average
         ).

ENDFORM.                    " set_aggregs
*&---------------------------------------------------------------------*
*&      Form  set_filters
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_filters  USING    p_alv TYPE REF TO cl_salv_table.
  DATA: lr_filters TYPE REF TO cl_salv_filters,
        lr_filter  TYPE REF TO cl_salv_filter.

* 1. get FILTERS object
  lr_filters = p_alv->get_filters( ).
* 2. add filter for column LUGGWEIGHT
  lr_filters->add_filter(
      columnname = 'CUSTOMID'
      sign       = 'I'
      option     = 'LT'
      low        = '20'
*    HIGH       =
       ).

* 3. get certain FILTER object
  lr_filter = lr_filters->get_filter(
                columnname = 'CUSTOMID' ).
* 4. add another selection to this filter object
  lr_filter->add_selopt(
      sign   = 'I'
      option = 'GT'
      low    = '1000'
*    HIGH   =
         ).

ENDFORM.                    " set_filters
*&---------------------------------------------------------------------*
*&      Form  set_selections
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_selections  USING p_alv TYPE REF TO cl_salv_table.
  DATA: lr_selections TYPE REF TO cl_salv_selections.
  lr_selections = p_alv->get_selections( ).
* multiple: several columns, several rows, no row button
  lr_selections->set_selection_mode(
    value  = if_salv_c_selection_mode=>multiple
         ).


ENDFORM.                    " set_selections
*&---------------------------------------------------------------------*
*&      Form  set_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_layout  USING p_alv TYPE REF TO cl_salv_table.
  DATA: lr_layout TYPE REF TO cl_salv_layout,
        gs_key TYPE salv_s_layout_key.

* 1. get the LAYOUT object
  lr_layout = p_alv->get_layout( ).
* 2. set the layout key
  gs_key-report = sy-cprog.
  lr_layout->set_key( value = gs_key ).
* 3. set save restriction:
*    no restriction / only user-dependent / only user-independent
  lr_layout->set_save_restriction(
    value  = if_salv_c_layout=>restrict_none
         ).
* 4. set: setting of default layout is allowed / isn't allowed
  lr_layout->set_default( value = 'X' ).
* 5. set initial layout (best from selection screen)
*    (initial layout wins against default layout)
  IF p_layout IS NOT INITIAL.
    lr_layout->set_initial_layout( value = p_layout ).
  ENDIF.

ENDFORM.                    " set_layouts
*&---------------------------------------------------------------------*
*&      Form  f4layouts
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_P_LAYOUT  text
*----------------------------------------------------------------------*
FORM f4layouts  CHANGING p_layout TYPE disvariant-variant.
  DATA: ls_layout TYPE salv_s_layout_info,
        ls_key    TYPE salv_s_layout_key.

  ls_key-report = sy-cprog.

  ls_layout = cl_salv_layout_service=>f4_layouts(
      s_key    = ls_key
*    LAYOUT   =
*    RESTRICT = IF_SALV_C_LAYOUT=>RESTRICT_NONE
         ).

  p_layout = ls_layout-layout.

ENDFORM.                                                    " f4layouts
*&---------------------------------------------------------------------*
*&      Form  set_functions
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_functions
  USING    p_alv TYPE REF TO cl_salv_table.
  DATA: lr_functions TYPE REF TO cl_salv_functions_list.
  DATA: l_icon TYPE string,
        l_text TYPE string,
        l_tooltip TYPE string.
* get the FUNCTIONS object
  lr_functions = p_alv->get_functions( ).
************************************************************************
* Settings for generic functions                                       *
************************************************************************
* set default set of generic functions
  lr_functions->set_default( ).
* ... but switch off filter functions
  lr_functions->set_group_filter( value  = if_salv_c_bool_sap=>false ).
* ... and additionally set print preview, please
  lr_functions->set_print_preview( ).

************************************************************************
* User-defined functions (for container)
************************************************************************
  IF pa_cont = 'X'.
* type conversions for method call
    l_icon = icon_customer.
    l_text = text-ocd.  " only customer data
    l_tooltip = text-oct.
    lr_functions->add_function(
        name     = 'ONLY_CD'
        icon     = l_icon
        text     = l_text
        tooltip  = l_tooltip
        position = if_salv_c_function_position=>right_of_salv_functions
           ).
  ENDIF.
************************************************************************
* User-defined functions via GUI status
* (for Fullscreen grid or classical ABAP list)
************************************************************************
  IF pa_full = 'X' OR pa_list = 'X'.
    p_alv->set_screen_status(
        report        = sy-cprog
        pfstatus      = 'UD_FULLSCREEN'
*        set_functions = cl_salv_model_base=>c_functions_all
           ).
  ENDIF.
ENDFORM.                    " set_functions
*&---------------------------------------------------------------------*
*&      Form  set_events
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_events
  USING    p_alv TYPE REF TO cl_salv_table.
  DATA: lr_event TYPE REF TO cl_salv_events_table.
  lr_event = p_alv->get_event( ).

  SET HANDLER:
    lcl_event_handler=>on_added_function FOR lr_event,
    lcl_event_handler=>on_double_click FOR lr_event,
    lcl_event_handler=>on_link_click FOR lr_event,
    lcl_event_handler=>on_top_of_page FOR lr_event.

ENDFORM.                    " set_events
*&---------------------------------------------------------------------*
*&      Form  set_func_settings
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_func_settings
  USING p_alv TYPE REF TO cl_salv_table.

  DATA: lr_func_settings TYPE REF TO cl_salv_functional_settings.
* get the FUNCTIONAL SETTINGS object
  lr_func_settings = p_alv->get_functional_settings( ).

************************************************************************
* Hyperlinks                                                           *
************************************************************************
  DATA: lr_hyperlinks TYPE REF TO cl_salv_hyperlinks.

  IF pa_list NE 'X'.
* get the HYPERLINKS object
    lr_hyperlinks = lr_func_settings->get_hyperlinks( ).
* add some hyperlinks
    lr_hyperlinks->add_hyperlink(
        handle    = 1
        hyperlink = 'http://www.sap.com'
           ).

    lr_hyperlinks->add_hyperlink(
        handle    = 2
        hyperlink = 'http://help.sap.com'
           ).

    lr_hyperlinks->add_hyperlink(
        handle    = 3
        hyperlink = 'http://service.sap.com'
           ).
  ENDIF.
ENDFORM.                    " set_func_settings
*&---------------------------------------------------------------------*
*&      Form  set_print
*&---------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_print USING p_alv TYPE REF TO cl_salv_table.
  DATA: lr_print TYPE REF TO cl_salv_print.
* get the PRINT object
  lr_print = p_alv->get_print( ).
* set listinfo on
  lr_print->set_listinfo_on( value = 'X' ).
* set selectioninfo on
  lr_print->set_selectioninfo_on( callback_program = sy-cprog  ).
* set coverpage on
  lr_print->set_coverpage_on( value = 'X' ).
* set standard header on
  lr_print->set_report_standard_header_on( value = 'X' ).
* regard actual listsize (optimize column width)
  lr_print->set_print_parameters_enabled( value = 'X' ).
ENDFORM.                    " set_print
*&---------------------------------------------------------------------*
*&      Form  set_header_footer
*&---------------------------------------------------------------------*
*      -->P_ALV  text
*----------------------------------------------------------------------*
FORM set_header_footer
  USING p_alv TYPE REF TO cl_salv_table.
  DATA: lr_grid TYPE REF TO cl_salv_form_layout_grid.
  DATA: lr_text TYPE REF TO cl_salv_form_text.

  CREATE OBJECT lr_grid.
* add header: booking list
  lr_grid->create_header_information(
      row     = 1
      column  = 1
      colspan = 2
      text    = text-hdi
     ).
* add text: please check bookings
  lr_grid->create_text(
      row     = 2
      column  = 1
      colspan = 2
      text    = text-pls
     ).
* add text: red light
  lr_grid->create_text(
      row     = 3
      column  = 2
      text    = text-red
     ).
* add label for text: what means red light
  lr_grid->create_label(
      row         = 3
      column      = 1
      text        = text-1st
         ).
* add text: yellow light
  lr_grid->create_text(
      row     = 4
      column  = 2
      text    = text-yel
     ).
* add label for text: what means yellow light
  lr_grid->create_label(
      row         = 4
      column      = 1
      text        = text-bus
         ).

* add text: green light
  lr_grid->create_text(
      row     = 5
      column  = 2
      text    = text-grn
     ).
* add label for text: what means green light
  lr_grid->create_label(
      row         = 5
      column      = 1
      text        = text-eco
         ).

* set grid lines
  lr_grid->set_grid_lines(
    value  = if_salv_form_c_grid_lines=>lines
         ).

  p_alv->set_top_of_list( lr_grid ).

  CREATE OBJECT lr_text
    EXPORTING
      text   = text-nbt
      .

  p_alv->set_end_of_list( lr_text ).
ENDFORM.                    " set_header_footer
