FUNCTION bc401_alv_list_output.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IT_LIST1) TYPE  BC401_T_FLIGHTS_COLOR
*"     VALUE(IT_LIST2) TYPE  BC401_T_FLIGHTS_COLOR OPTIONAL
*"  EXCEPTIONS
*"      CONTROL_ERROR
*"----------------------------------------------------------------------

* local data objects
  DATA:
*   needed for list output
    wa           TYPE bc401_s_flight_color,
*   control reference variables
    ref_custom   TYPE REF TO cl_gui_custom_container,
    ref_splitter TYPE REF TO cl_gui_splitter_container,
    ref_top_cell TYPE REF TO cl_gui_container,
    ref_bot_cell TYPE REF TO cl_gui_container,
    ref_alv1     TYPE REF TO cl_gui_alv_grid,
    ref_alv2     TYPE REF TO cl_gui_alv_grid,
*   ALV auxiliaries
*   - layout structures: title and color codes
    wa_layo1     TYPE lvc_s_layo,
    wa_layo2     TYPE lvc_s_layo,
*   - field catalogs: change column properties
    it_fcat      TYPE lvc_t_fcat,
    wa_fcat      LIKE LINE OF it_fcat,
*   function module auxiliary
    mode         TYPE i.

  CONSTANTS:
    c_mode_1         TYPE i VALUE 1,
    c_mode_2         TYPE i VALUE 2,
    c_tab_struc_name TYPE dd02l-tabname
                     VALUE 'BC401_S_FLIGHT_COLOR'.


***************************************************************
*   adjust field catalog for both ALV controls:
*   - disable the display of colum 'COLOR' containing
*     the color codes
***************************************************************
  wa_fcat-fieldname = 'COLOR'.
  wa_fcat-tech      = 'X'.
  INSERT wa_fcat INTO TABLE it_fcat.

***************************************************************
* map color codes to ALV color codes
* x -> Cx10, x= color code defined in type pool COL
***************************************************************
  LOOP AT it_list1 INTO wa.
    CONCATENATE 'C' wa-color(1) '10' INTO wa-color.
    MODIFY it_list1 FROM wa.
  ENDLOOP.

***************************************************************
*   adjust layout structure for first ALV:
*   - name of column containing color codes of list lines
*   - list heading
***************************************************************
  wa_layo1-info_fname = 'COLOR'.
  wa_layo1-grid_title = text-001.      " <-- flight list

* *************************************************************
* set display mode
*   mode = c_mode_1:  only one list displayed
*   mode = c_mode_2:  two lists are displayed
***************************************************************
  IF it_list2 IS INITIAL.
    mode = c_mode_1.
  ELSE.
    mode = c_mode_2.

*   map color codes for second table
    LOOP AT it_list2 INTO wa.
      CONCATENATE 'C' wa-color(1) '10' INTO wa-color.
      MODIFY it_list2 FROM wa.
    ENDLOOP.

*   adjust layout structure for second ALV
    wa_layo2-info_fname = 'COLOR'.
    wa_layo2-grid_title = text-002.    " <-- duplicates

  ENDIF.

****************************************************************
* C O N T A I N E R    H A N D L I N G
****************************************************************
  IF ref_custom IS INITIAL.
    CREATE OBJECT ref_custom
      EXPORTING
        parent                      = cl_gui_custom_container=>screen0
        container_name              = 'CONTROL_AREA1'
        repid                       = g_repid
        dynnr                       = '0100'
      EXCEPTIONS
        OTHERS                      = 6
        .

    IF sy-subrc <> 0.
      MESSAGE a031(bc402) RAISING control_error.
    ENDIF.

  ENDIF.

  CASE mode.
    WHEN c_mode_1.                     " only one list requested
      ref_top_cell = ref_custom.
    WHEN c_mode_2.                     " two lists are requested
      CREATE OBJECT ref_splitter
        EXPORTING
          parent            = ref_custom
          rows              = 2
          columns           = 1
        EXCEPTIONS
          OTHERS            = 3
          .

      IF sy-subrc <> 0.
        MESSAGE a081(bc401) RAISING control_error.
      ENDIF.

      ref_top_cell = ref_splitter->get_container( row = 1 column = 1 ).
      ref_bot_cell = ref_splitter->get_container( row = 2 column = 1 ).

*     adjust cell spacing
      CALL METHOD ref_splitter->set_row_mode
        EXPORTING
          mode   = ref_splitter->mode_relative
        EXCEPTIONS
          OTHERS = 3.
      IF sy-subrc <> 0.
        MESSAGE a083(bc401) RAISING control_error.
      ENDIF.

      CALL METHOD ref_splitter->set_row_height
        EXPORTING
          id     = 2
          height = 30
        EXCEPTIONS
          OTHERS = 3.
      IF sy-subrc <> 0.
        MESSAGE a083(bc401) RAISING control_error.
      ENDIF.


  ENDCASE.

*********************************************************************
* A L V    H A N D L I N G
*********************************************************************

  IF ref_alv1 IS INITIAL.

    CREATE OBJECT ref_alv1
      EXPORTING
        i_parent          = ref_top_cell
      EXCEPTIONS
        OTHERS            = 5
        .
    IF sy-subrc <> 0.
      MESSAGE a082(bc401) RAISING control_error.
    ENDIF.

    CALL METHOD ref_alv1->set_table_for_first_display
      EXPORTING
        i_structure_name = c_tab_struc_name
        is_layout        = wa_layo1
      CHANGING
        it_outtab        = it_list1
        it_fieldcatalog  = it_fcat
      EXCEPTIONS
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE a083(bc401) RAISING control_error.
    ENDIF.

  ELSE.
    CALL METHOD ref_alv1->refresh_table_display.

    IF sy-subrc <> 0.
      MESSAGE a083(bc401) RAISING control_error.
    ENDIF.

  ENDIF.

  IF mode = c_mode_2.
*   create second ALV if necessary and link to bottom cell
    IF ref_alv2 IS INITIAL.

      CREATE OBJECT ref_alv2
        EXPORTING
          i_parent          = ref_bot_cell
        EXCEPTIONS
          OTHERS            = 5
          .
      IF sy-subrc <> 0.
        MESSAGE a082(bc401) RAISING control_error.
      ENDIF.

      CALL METHOD ref_alv2->set_table_for_first_display
        EXPORTING
          i_structure_name = c_tab_struc_name
          is_layout        = wa_layo2
        CHANGING
          it_outtab        = it_list2
          it_fieldcatalog  = it_fcat
        EXCEPTIONS
          OTHERS           = 4.
      IF sy-subrc <> 0.
        MESSAGE a083(bc401) RAISING control_error.
      ENDIF.

    ELSE.
      CALL METHOD ref_alv2->refresh_table_display.

      IF sy-subrc <> 0.
        MESSAGE a083(bc401) RAISING control_error.
      ENDIF.

    ENDIF.
  ENDIF.

  CALL SCREEN 0100.

* free control and proxy object ressources
  CASE mode.
    WHEN c_mode_1.
*     free: - ALV1
*           - custom container
      CALL METHOD ref_alv1->free.
      CALL METHOD ref_custom->free.
      CLEAR: ref_alv1, ref_custom.
    WHEN c_mode_2.
*     free: - ALV1, ALV2
*           - splitter container, custom container
      CALL METHOD ref_alv1->free.
      CALL METHOD ref_alv2->free.
      CALL METHOD ref_splitter->free.
      CALL METHOD ref_custom->free.
      CLEAR: ref_alv1, ref_alv2, ref_splitter, ref_custom.
  ENDCASE.

ENDFUNCTION.
