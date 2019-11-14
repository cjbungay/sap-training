*&---------------------------------------------------------------------*
*&  Include           BC480_CHECKF01
*&---------------------------------------------------------------------*
************************************************************************
FORM parse_interface
  CHANGING pt_import_parameters  TYPE tfpiopar
           pt_export_parameters  TYPE tfpiopar
           pt_table_parameters   TYPE tfpiopar
           pt_global_data        TYPE tfpgdata
           pt_reference_fields   TYPE tfpref.


  DATA:
    lr_xml_interface      TYPE REF TO cl_fp_interface_data,

    lr_parameters         TYPE REF TO if_fp_parameters,
    lr_global_definitions TYPE REF TO if_fp_global_definitions,
    lr_reference_fields   TYPE REF TO if_fp_reference_fields.

  TRY.
      CALL TRANSFORMATION id
        SOURCE XML xml
        RESULT interface = lr_xml_interface.
    CATCH cx_xslt_exception.
    message e040.
  ENDTRY.

  lr_global_definitions =
  lr_xml_interface->if_fp_interface_data~get_global_definitions( ).
  pt_global_data = lr_global_definitions->get_global_data( ).

  lr_reference_fields =
  lr_xml_interface->if_fp_interface_data~get_reference_fields( ).
  pt_reference_fields = lr_reference_fields->get_reference_fields( ).

  lr_parameters =
  lr_xml_interface->if_fp_interface_data~get_parameters( ).
  pt_export_parameters = lr_parameters->get_export_parameters( ).
  pt_import_parameters = lr_parameters->get_import_parameters( ).
  pt_table_parameters  = lr_parameters->get_table_parameters( ).

ENDFORM.                    "parse_interface

************************************************************************
FORM parse_context.
  DATA:
    l_form_context TYPE REF TO cl_fp_context,
    lr_child TYPE REF TO  if_fp_node,
    lr_structure TYPE REF TO if_fp_structure,
    l_field TYPE fpfield.
  TRY.
      CALL TRANSFORMATION id
        SOURCE XML xml
        RESULT context = l_form_context.
    CATCH cx_xslt_deserialization_error.
    message e041.
  ENDTRY.
  lr_child = l_form_context->if_fp_node~get_child( ).
  lr_structure ?= lr_child.
  l_field = lr_structure->get_field( ).
*  CL_FP_STRUCTURE
ENDFORM.                    "parse_context


************************************************************************
FORM parse_style
  USING p_style TYPE stxsadmt-stylename
  CHANGING pt_paragraphs TYPE  ty_para.
  SELECT *
    FROM stxspara
    INTO TABLE pt_paragraphs
    WHERE active = 'X' AND
          stylename = 'BC480' AND
          vari = space.
ENDFORM.                    "parse_style

************************************************************************
FORM compare_two_itabs
  USING p_it_correct TYPE INDEX TABLE
        value(important_col_no) TYPE i
  CHANGING p_it_to_be_checked TYPE INDEX TABLE.

  TYPE-POOLS: abap.

  DATA:
    dref_it         TYPE REF TO data,
    dref_wa         TYPE REF TO data,
    ls_colors       TYPE lvc_s_scol,
    column          TYPE abap_compdescr,
    ref_type_struct TYPE REF TO cl_abap_structdescr,
    column_details  TYPE abap_compdescr,
    type_name       TYPE string,
    ls_par          TYPE sfpiopar,
    alv_additions   TYPE ty_alv_layout,
    sort_by(30)     VALUE 'LIGHT',
    def_value.

  FIELD-SYMBOLS:
    <wa1>       TYPE ANY,
    <wa2>       TYPE ANY,
    <field1>    TYPE ANY,
    <field2>    TYPE ANY,
    <wa>        TYPE ANY,
    <it>        TYPE INDEX TABLE.


  ls_colors-color-col = col_negative.
  ls_colors-color-int = 1.
  ls_colors-color-inv = 0.

  LOOP AT p_it_correct
    ASSIGNING <wa1>.
    CLEAR alv_additions-t_field_colors.
    IF sy-tabix = 1. " find out type once
      ref_type_struct ?= cl_abap_typedescr=>describe_by_data( <wa1> ).
      READ TABLE ref_type_struct->components
        INDEX important_col_no
        INTO column_details.
      type_name = ref_type_struct->get_relative_name( ).
      CREATE DATA dref_it LIKE p_it_to_be_checked.
      ASSIGN dref_it->* TO <it>.
* <it> will hold the fields from the template itab that are not
* part of the student's itab.
      CREATE DATA dref_wa LIKE LINE OF p_it_to_be_checked.
      ASSIGN dref_wa->* TO <wa>.
    ENDIF.

* data row with key important_col_no available in second itab?
    ASSIGN COMPONENT important_col_no OF STRUCTURE <wa1> TO <field1>.
    READ TABLE p_it_to_be_checked
      ASSIGNING <wa2>
      WITH KEY (column_details-name)  = <field1>.

    IF sy-subrc <> 0.
      MOVE-CORRESPONDING <wa1> TO <wa>.
      alv_additions-light = 1.
      alv_additions-comment = 'Missing'(mis).
      alv_additions-color = 'C610'.
      MOVE-CORRESPONDING alv_additions TO <wa>.
      APPEND <wa> TO <it>.

      CONTINUE.
    ENDIF.

* do all fields correspond to each other?
* parse every field from the current original line of the loop
* and compare it to the student's values.
    DO.
      READ TABLE ref_type_struct->components
              INDEX sy-index
              INTO column.

* check once for every student field/parameter whether a default value
* is given - this makes the parameter implicitly optional.
      IF sy-index = 1.
        CLEAR def_value.
        ASSIGN COMPONENT 'DEFAULTVAL' OF STRUCTURE <wa2> TO <field2>.
        IF sy-subrc = 0.
          IF <field2> IS NOT INITIAL.
            def_value = 'X'.
          ENDIF.
        ENDIF.
      ENDIF.
      ASSIGN COMPONENT sy-index OF STRUCTURE <wa1> TO <field1>.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      ASSIGN COMPONENT sy-index OF STRUCTURE <wa2> TO <field2>.
      IF <field1> <> <field2>.
        MOVE-CORRESPONDING <wa2> TO alv_additions.
        IF column-name = 'OPTIONAL' AND
           <field1> = 'X' AND
           def_value = 'X' OR column-name = 'DEFAULTVAL'.
          ls_colors-color-col = col_total. " yellow
          IF alv_additions-light = 3.
            alv_additions-light = 2.
          ENDIF.
          " default values make a parameter implicity optional
        ELSE.
          alv_additions-light = 1.
        ENDIF.
        ls_colors-fname = column-name.
        APPEND ls_colors TO alv_additions-t_field_colors.
        MOVE-CORRESPONDING alv_additions TO <wa2>.
      ENDIF.
      ls_colors-color-col = col_negative. " red
    ENDDO.
  ENDLOOP.


  LOOP AT p_it_to_be_checked
  ASSIGNING <wa2>.
* If a data row exists in the second itab, is there an equivalent in
* the first one?
* In other words: any superfluous fields?
    ASSIGN COMPONENT important_col_no OF STRUCTURE <wa2> TO <field2>.
    READ TABLE p_it_correct
      ASSIGNING <wa1>
      WITH KEY (column_details-name)  = <field2>.
    IF sy-subrc <> 0.
      CLEAR alv_additions.
      alv_additions-comment = 'Extra'(ext).
      alv_additions-color = 0.
      CASE type_name.
        WHEN 'SFPIOPAR'.
          MOVE-CORRESPONDING <wa2> TO ls_par.
          IF ls_par-optional = 'X'
            OR ls_par-defaultval IS NOT INITIAL.
            alv_additions-light = 2. " yellow icon
          ELSE.
            alv_additions-light = 1. " red icon
          ENDIF.
        WHEN 'SFPGDATA'.
          alv_additions-light = 2. " yellow icon
        WHEN 'SFPREF'.
          alv_additions-light = 2. " yellow icon
      ENDCASE.
      MOVE-CORRESPONDING alv_additions TO <wa2>.
    ENDIF.

  ENDLOOP.
  APPEND LINES OF <it> TO p_it_to_be_checked.
  SORT p_it_to_be_checked BY (sort_by).
ENDFORM.                    "compare_two_itabs
