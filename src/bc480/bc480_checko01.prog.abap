*----------------------------------------------------------------------*
***INCLUDE BC480_CHECKO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STAT100'.
  SET TITLEBAR 'T100' with pa_if.

ENDMODULE.                 " STATUS_0100  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  alv  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE alv OUTPUT.

* general settings for ALV Grid display
  gs_layout-no_toolbar = 'X'.
*internal table that contains information on cell color
  gs_layout-ctab_fname = 'T_FIELD_COLORS'.
*field that contains information on line color
  gs_layout-info_fname = 'COLOR'.
*field that contains information on exception (indicator)
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led   = 'X'.
  gs_layout-cwidth_opt = 'X'.

***********************************************************************
* import parameters
  DESCRIBE TABLE gt_import_parameters LINES len1.
  DESCRIBE TABLE gt_import_correct    LINES len2.
  IF cont_import IS INITIAL AND ( len1 > 0 OR len2 > 0 ).
    number = number + 1.
    container+4 = number.
    CREATE OBJECT cont_import
      EXPORTING
        container_name              = container.

    CREATE OBJECT alv_import
      EXPORTING
        i_parent          = cont_import.

* Move fields of student's interface to equivalent ALV internal table.
    LOOP AT gt_import_parameters INTO gs_import_parameters.
      MOVE-CORRESPONDING gs_import_parameters TO gs_alv_import.
      gs_alv_import-light = 3. "green icon as default
      APPEND gs_alv_import TO gt_alv_import.
    ENDLOOP.

    PERFORM compare_two_itabs
                USING    gt_import_correct
                         1 " column = name
                CHANGING gt_alv_import.

    gs_layout-grid_title = 'Import parameters'(imp).

* ALV field catalog
    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'CONSTANT'.
    gs_field_cat-tech = 'X'.
    APPEND gs_field_cat TO gt_field_cat.

    gs_field_cat-fieldname = 'STANDARD'.
    APPEND gs_field_cat TO gt_field_cat.

    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'LIGHT'.
    gs_field_cat-coltext = 'Correct'(cor).                  "#EC *
    APPEND gs_field_cat TO gt_field_cat.

    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'COMMENT'.
    gs_field_cat-coltext = 'Comment'(com).                  "#EC *
    gs_field_cat-col_pos = 1.
    APPEND gs_field_cat TO gt_field_cat.

    CALL METHOD alv_import->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SFPIOPAR'
        is_layout        = gs_layout
      CHANGING
        it_outtab        = gt_alv_import
        it_fieldcatalog  = gt_field_cat.
  ENDIF.

***********************************************************************
* export parameters
  DESCRIBE TABLE gt_export_parameters LINES len1.
  DESCRIBE TABLE gt_export_correct    LINES len2.
  IF cont_export IS INITIAL AND ( len1 > 0 OR len2 > 0 ).
    number = number + 1.
    container+4 = number.
    CREATE OBJECT cont_export
      EXPORTING
        container_name              = container.
    CREATE OBJECT alv_export
      EXPORTING
        i_parent          = cont_export.

* Move fields of student's interface to equivalent ALV internal table.
    LOOP AT gt_export_parameters INTO gs_export_parameters.
      MOVE-CORRESPONDING gs_export_parameters TO gs_alv_export.
      gs_alv_export-light = 3. "green icon as default
      APPEND gs_alv_export TO gt_alv_export.
    ENDLOOP.

    PERFORM compare_two_itabs
                USING    gt_export_correct
                         1 " column = name
                CHANGING gt_alv_export.

    gs_layout-grid_title = 'Export parameters'(exp).

* ALV field catalog
    REFRESH gt_field_cat.
    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'CONSTANT'.
    gs_field_cat-tech = 'X'.
    APPEND gs_field_cat TO gt_field_cat.

    gs_field_cat-fieldname = 'STANDARD'.
    APPEND gs_field_cat TO gt_field_cat.

    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'LIGHT'.
    gs_field_cat-coltext = 'Correct'(cor).                  "#EC *
    APPEND gs_field_cat TO gt_field_cat.

    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'COMMENT'.
    gs_field_cat-coltext = 'Comment'(com).                  "#EC *
    gs_field_cat-col_pos = 1.
    APPEND gs_field_cat TO gt_field_cat.

    CALL METHOD alv_export->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SFPIOPAR'
        is_layout        = gs_layout
      CHANGING
        it_outtab        = gt_export_parameters
        it_fieldcatalog  = gt_field_cat.

  ENDIF.

************************************************************************
* global fields
  DESCRIBE TABLE gt_global_data    LINES len1.
  DESCRIBE TABLE gt_global_correct LINES len2.
  IF cont_global IS INITIAL AND ( len1 > 0 OR len2 > 0 ).
    number = number + 1.
    container+4 = number.
    CREATE OBJECT cont_global
      EXPORTING
        container_name              = container.

    CREATE OBJECT alv_global
      EXPORTING
        i_parent          = cont_global.

* Move fields of student's interface to equivalent ALV internal table.
    LOOP AT gt_global_data INTO gs_global_data.
      MOVE-CORRESPONDING gs_global_data TO gs_alv_global.
      gs_alv_global-light = 3. "green icon as default
      APPEND gs_alv_global TO gt_alv_global.
    ENDLOOP.

    PERFORM compare_two_itabs
                USING    gt_global_correct
                         1 " column = name
                CHANGING gt_alv_global.

    gs_layout-grid_title = 'Global data'(glo).

* ALV field catalog
    REFRESH gt_field_cat.
    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'LIGHT'.
    gs_field_cat-coltext = 'Correct'(cor).                  "#EC *
    APPEND gs_field_cat TO gt_field_cat.

    gs_field_cat-fieldname = 'COMMENT'.
    gs_field_cat-coltext = 'Comment'(com).                  "#EC *
    gs_field_cat-col_pos = 1.
    APPEND gs_field_cat TO gt_field_cat.

    CALL METHOD alv_global->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SFPGDATA'
        is_layout        = gs_layout
      CHANGING
        it_outtab        = gt_alv_global
        it_fieldcatalog  = gt_field_cat.
  ENDIF.

************************************************************************
* reference fields
* create display only if reference fields are included in template
* and/or student's interface.
  DESCRIBE TABLE gt_reference_fields  LINES len1.
  DESCRIBE TABLE gt_reference_correct LINES len2.
  IF cont_reference IS INITIAL AND ( len1 > 0 OR len2 > 0 ).
    number = number + 1.
    container+4 = number.
    CREATE OBJECT cont_reference
      EXPORTING
        container_name              = container.

    CREATE OBJECT alv_reference
      EXPORTING
        i_parent          = cont_reference.

* Move fields of student's interface to equivalent ALV internal table.
    LOOP AT gt_reference_fields INTO gs_reference_fields.
      MOVE-CORRESPONDING gs_reference_fields TO gs_alv_reference.
      gs_alv_reference-light = 3. "green icon as default
      APPEND gs_alv_reference TO gt_alv_reference.
    ENDLOOP.

    PERFORM compare_two_itabs
                USING    gt_reference_correct
                         4 " column = value
                CHANGING gt_alv_reference.

    gs_layout-grid_title = 'Reference fields'(ref).

* ALV field catalog
    REFRESH gt_field_cat.
    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'ACTIVE'.
    gs_field_cat-tech = 'X'.
    APPEND gs_field_cat TO gt_field_cat.

    gs_field_cat-fieldname = 'STANDARD'.
    APPEND gs_field_cat TO gt_field_cat.

    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'LIGHT'.
    gs_field_cat-coltext = 'Correct'(cor).                  "#EC *
    APPEND gs_field_cat TO gt_field_cat.

    CLEAR gs_field_cat.
    gs_field_cat-fieldname = 'COMMENT'.
    gs_field_cat-coltext = 'Comment'(com).                  "#EC *
    gs_field_cat-col_pos = 2.
    APPEND gs_field_cat TO gt_field_cat.

    CALL METHOD alv_reference->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SFPREF'
        is_layout        = gs_layout
      CHANGING
        it_outtab        = gt_alv_reference
        it_fieldcatalog  = gt_field_cat.
  ENDIF.
ENDMODULE.                 " alv  OUTPUT
