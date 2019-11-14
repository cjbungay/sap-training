*&---------------------------------------------------------------------*
*& Report  SAPBC408ARCD_MIN_POPUP                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC408ARCD_MIN_POPUP.
DATA: wa_spfli TYPE spfli,
      it_spfli TYPE TABLE OF spfli,
      it_sflight TYPE TABLE OF sflight,
      ref_grid TYPE REF TO cl_gui_alv_grid.

SELECT-OPTIONS: so_car FOR wa_spfli-carrid.

START-OF-SELECTION.
  SELECT        *
    FROM  spfli
    INTO wa_spfli
    WHERE  carrid  IN so_car.

    WRITE: / wa_spfli-carrid COLOR COL_KEY,
             wa_spfli-connid COLOR COL_KEY,
             wa_spfli-cityfrom,
             wa_spfli-airpfrom,
             wa_spfli-cityto,
             wa_spfli-airpto,
             wa_spfli-fltime,
             wa_spfli-distance UNIT wa_spfli-distid,
             wa_spfli-distid.

    HIDE: wa_spfli-carrid,
          wa_spfli-connid.
  ENDSELECT.

  CLEAR wa_spfli.

AT LINE-SELECTION.

  CHECK NOT wa_spfli IS INITIAL.
  WRITE space.

  SELECT *
    FROM sflight
    INTO TABLE it_sflight
    WHERE carrid = wa_spfli-carrid
    AND   connid = wa_spfli-connid.

  WINDOW STARTING AT 5 5.

  CREATE OBJECT ref_grid
    EXPORTING
      i_parent          = cl_gui_container=>screen1. " Pop-Up-Level 1
* It's necessary to determine popup level 1, because window is used.
* If window wasn't used, popup level were to be 0.

  CALL METHOD ref_grid->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      it_outtab        = it_sflight.
