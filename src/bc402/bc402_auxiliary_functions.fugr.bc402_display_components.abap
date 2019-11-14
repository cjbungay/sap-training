FUNCTION bc402_display_components.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  CHANGING
*"     REFERENCE(CT_COMP) TYPE  BC402_T_COMP
*"  EXCEPTIONS
*"      ERROR_CONTAINER
*"      ERROR_GRID
*"      ERROR_METHOD
*"----------------------------------------------------------------------

  DATA:
     lt_index_rows TYPE lvc_t_row,
     ls_index_rows TYPE lvc_s_row,

     ls_comp LIKE LINE OF ct_comp.

  gt_comp[] = ct_comp[].

* call dynpro with Grid Control

  CALL SCREEN 100.

* get selected rows and copy them to output

  CALL METHOD ref_grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_index_rows.

  IF LINES( lt_index_rows ) GT 0.
    REFRESH ct_comp.
    LOOP AT lt_index_rows INTO ls_index_rows.
      READ TABLE gt_comp INTO ls_comp INDEX ls_index_rows-index.
      IF sy-subrc = 0.
        INSERT ls_comp INTO TABLE ct_comp.
      ENDIF.
    ENDLOOP.
  ENDIF.

* reset selcted rows

  REFRESH lt_index_rows.
  CALL METHOD ref_grid->set_selected_rows
    EXPORTING
      it_index_rows = lt_index_rows.

ENDFUNCTION.
