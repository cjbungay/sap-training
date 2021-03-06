*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYNS_CREATE_DATA_4
*&
*&---------------------------------------------------------------------*
*&  This program works similar to the Data Browser.
*&  Selection-Screen for a table name.
*&  Use of RTTI to retrieve info about fields
*&  Function module call to display field names and field descriptions
*&  Use of RTTC to create temporary table type with selected fields
*&  Dynamic SQL Statement to read the data from the table
*&  Use ALV to display the data
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_dyns_create_data_4.

*----------------------------------------------------------------------*
DATA:
    ok_code LIKE sy-ucomm,

    gr_alv   TYPE REF TO cl_salv_table,
    ref_itab TYPE REF TO data.

DATA:
    gr_type      TYPE REF TO cl_abap_typedescr,
    gr_struc     TYPE REF TO cl_abap_structdescr,

    gt_component TYPE cl_abap_structdescr=>component_table,
    gt_ddfields  TYPE ddfields,
    gs_ddfields  TYPE dfies,
    gt_comp      TYPE bc402_t_comp,
    gs_comp      TYPE bc402_s_comp.

DATA:
    gr_struc_new TYPE REF TO cl_abap_structdescr,
    gr_table_new TYPE REF TO cl_abap_tabledescr,

    gt_comp_new  TYPE cl_abap_structdescr=>component_table,
    gs_component TYPE cl_abap_structdescr=>component.

*----------------------------------------------------------------------*
FIELD-SYMBOLS:
    <fs_itab> TYPE ANY TABLE.

*----------------------------------------------------------------------*
PARAMETERS pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*

** RTTI here - get description of structure pa_tab into gr_struc
  CALL METHOD cl_abap_typedescr=>describe_by_name
    EXPORTING
      p_name         = pa_tab
    RECEIVING
      p_descr_ref    = gr_type
    EXCEPTIONS
      type_not_found = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
    MESSAGE e801(bc402) WITH pa_tab.
  ENDIF.
  TRY.
      gr_struc ?= gr_type.
    CATCH cx_sy_move_cast_error.
      MESSAGE e802(bc402) WITH pa_tab.
  ENDTRY.

* get component list of structure pa_tab
  gt_component = gr_struc->get_components( ).

* get field list with DDIC info for  structure pa_tab
  CALL METHOD  gr_struc->get_ddic_field_list
*  EXPORTING
*    P_LANGU                  = SY-LANGU
   RECEIVING
     p_field_list             = gt_ddfields
  EXCEPTIONS
    not_found                = 1
    no_ddic_type             = 2
    OTHERS                   = 3
       .
  IF sy-subrc <> 0.
    MESSAGE e803(bc402) WITH pa_tab.
  ENDIF.

*----------------------------------------------------------------------*

* call function module to display field names and field descriptions
  LOOP AT gt_ddfields INTO gs_ddfields.
    MOVE-CORRESPONDING gs_ddfields TO gs_comp.
    INSERT gs_comp INTO TABLE gt_comp.
  ENDLOOP.

  CALL FUNCTION 'BC402_DISPLAY_COMPONENTS'
    CHANGING
      ct_comp         = gt_comp
    EXCEPTIONS
      error_container = 1
      error_grid      = 2
      error_method    = 3
      OTHERS          = 4.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*----------------------------------------------------------------------*
** NEW NEW NEW NEW NEW **
* build component table for new structure
  LOOP AT gt_comp INTO gs_comp.
    READ TABLE gt_component INTO gs_component
                            WITH TABLE KEY name = gs_comp-fieldname.
    IF sy-subrc = 0.
      INSERT gs_component INTO TABLE gt_comp_new.
    ENDIF.
  ENDLOOP.

** RTTC here - create line type and table type:
  TRY.
      CALL METHOD cl_abap_structdescr=>create
        EXPORTING
          p_components = gt_comp_new
        RECEIVING
          p_result     = gr_struc_new.
    CATCH cx_sy_struct_creation.
      MESSAGE e804(bc402).
  ENDTRY.
  TRY.
      CALL METHOD cl_abap_tabledescr=>create
        EXPORTING
          p_line_type = gr_struc_new
        RECEIVING
          p_result    = gr_table_new.
    CATCH cx_sy_table_creation .
      MESSAGE e805(bc402).
  ENDTRY.

*----------------------------------------------------------------------*

* use new table type to create internal table

*  CREATE DATA ref_itab TYPE STANDARD TABLE OF (pa_tab)
*                       WITH NON-UNIQUE DEFAULT KEY.
*  ASSIGN ref_itab->* TO <fs_itab>.
*
*  SELECT * FROM (pa_tab)
*           INTO TABLE <fs_itab>
*           UP TO 100 ROWS
*           .

  CREATE DATA ref_itab  TYPE HANDLE gr_table_new.
  ASSIGN ref_itab->* TO <fs_itab>.

  SELECT * FROM (pa_tab)
           INTO CORRESPONDING FIELDS OF TABLE <fs_itab>
           UP TO 100 ROWS
           .

  IF sy-subrc <> 0.
    MESSAGE e041(bc402).
  ENDIF.

*----------------------------------------------------------------------*
  TRY.
    cl_salv_table=>factory(
*  EXPORTING
*    LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE
*    R_CONTAINER    = R_CONTAINER
*    CONTAINER_NAME = CONTAINER_NAME
      IMPORTING
        r_salv_table   = gr_alv
      CHANGING
        t_table        = <fs_itab>
           ).
* CATCH CX_SALV_MSG .
  ENDTRY.

  gr_alv->display( ).
