*&---------------------------------------------------------------------*
*& Report  SAPBC408ARCD_SEL_SCREEN                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408arcd_sel_screen                                     .

DATA: wa_spfli TYPE spfli,
      it_spfli TYPE TABLE OF spfli,
      it_scarr TYPE TABLE OF scarr,
      ref_cont TYPE REF TO cl_gui_docking_container,
      ref_grid TYPE REF TO cl_gui_alv_grid,
      first_time VALUE 'X'.

SELECT-OPTIONS: so_car FOR wa_spfli-carrid.

AT SELECTION-SCREEN OUTPUT.

  IF ref_cont IS INITIAL.
    CREATE OBJECT ref_cont
      EXPORTING
        parent                      = cl_gui_container=>screen0
        side = cl_gui_docking_container=>dock_at_bottom
        extension                   = 250
        caption                     = 'Airlines'(001).

    CREATE OBJECT ref_grid
      EXPORTING
        i_parent          = ref_cont.
  ENDIF.

  SELECT *
    FROM scarr
    INTO TABLE it_scarr.

  IF first_time = 'X'.
    CLEAR first_time.
    CALL METHOD ref_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SCARR'
      CHANGING
        it_outtab        = it_scarr.
  ELSE.
    CALL METHOD ref_grid->refresh_table_display.
  ENDIF.


START-OF-SELECTION.
  SELECT * FROM spfli INTO wa_spfli
    WHERE carrid IN so_car.
    WRITE: / wa_spfli-carrid,
             wa_spfli-connid,
             wa_spfli-cityfrom,
             wa_spfli-airpfrom,
             wa_spfli-cityto,
             wa_spfli-airpto,
             wa_spfli-fltime,
             wa_spfli-distance unit wa_spfli-distid,
             wa_spfli-distid.

  ENDSELECT.
