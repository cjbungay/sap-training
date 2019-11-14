*&---------------------------------------------------------------------*
*& Report  SAPBC408ARCD_MINIMUM                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC408ARCD_MINIMUM                                        .
DATA: itab TYPE TABLE OF spfli,
      ref_grid TYPE REF TO cl_gui_alv_grid.

START-OF-SELECTION.

  WRITE space.

  SELECT * FROM spfli INTO TABLE itab.

  CREATE OBJECT ref_grid
    EXPORTING
      i_parent          = cl_gui_container=>screen0.

  CALL METHOD ref_grid->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SPFLI'
    CHANGING
      it_outtab        = itab.
