*&---------------------------------------------------------------------*
*&  Include           BC405_EVED_COMPLETEE01
*&---------------------------------------------------------------------*
LOAD-OF-PROGRAM.
  date_from = sy-datum - 15.
  date_to = sy-datum + 15.

*&---------------------------------------------------------------------*
*&   Event at selection-screen on value-request
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.
  PERFORM f4layouts
    CHANGING p_layout.

START-OF-SELECTION.
* retrieve data
  SELECT      *
    INTO CORRESPONDING FIELDS OF TABLE it_book
    FROM  sbook INNER JOIN scustom
    ON sbook~customid = scustom~id
         WHERE  carrid  IN so_car
         AND    connid  IN so_con
         AND    fldate  IN so_date.

* calculate additional data
  LOOP AT it_book INTO wa_book.
    ON CHANGE OF wa_book-carrid OR wa_book-connid.
      SELECT SINGLE *
      FROM spfli INTO wa_spfli
      WHERE carrid = wa_book-carrid
      AND connid = wa_book-connid.
    ENDON.
* Flag LEAVES_HOME
    IF wa_book-country = wa_spfli-countryfr.
      wa_book-leaves_home = 'X'.
    ENDIF.
* Flag GOES_HOME
    IF wa_book-country = wa_spfli-countryto.
      wa_book-goes_home = 'X'.
    ENDIF.
* icon: invoice yes / no
    IF wa_book-invoice = 'X'.
      wa_book-invoice_icon = icon_positive.
    ELSE.
      wa_book-invoice_icon = icon_negative.
    ENDIF.

* exception value
    CASE wa_book-class.
      WHEN 'F'.
        wa_book-exception = '1'.
      WHEN 'C'.
        wa_book-exception = '2'.
      WHEN 'Y'.
        wa_book-exception = '3'.
    ENDCASE.

************************************************************************
* Color informations
************************************************************************
*   whole row shall be COL_NEGATIVE if booking is cancelled
    IF wa_book-cancelled = 'X'.
      CLEAR wa_colors.
* no fname is set -> whole row is affected
      wa_colors-color-col = col_negative.
      wa_colors-color-int = 1.
      APPEND wa_colors TO wa_book-it_colors.
* possible: show key one column in different color as well
      CLEAR wa_colors.
      wa_colors-fname = 'CARRID'.
      wa_colors-color-col = col_positive.
      wa_colors-color-int = 1.
      wa_colors-nokeycol = 'X'.
      APPEND wa_colors TO wa_book-it_colors.
    ENDIF.
*   field SMOKER shall be COL_GROUP if checked
    IF wa_book-smoker = 'X'.
      CLEAR wa_colors.
      wa_colors-fname = 'SMOKER'.
      wa_colors-color-col = col_group.
      wa_colors-color-int = 1.
      APPEND wa_colors TO wa_book-it_colors.
    ENDIF.

***********************************************************************
* Cell type informations
***********************************************************************
* the following doesn't work for classical ABAP list
* luggage weight gt 20 kg ?
    IF wa_book-luggweight > 20 AND pa_cont = 'X'.
      CLEAR wa_cell_types.
      wa_cell_types-columnname = 'LUGGWEIGHT'.
      wa_cell_types-value = if_salv_c_cell_type=>button.
      APPEND wa_cell_types TO wa_book-it_cell_types.
    ENDIF.
    CLEAR wa_cell_types.
    IF wa_book-agencynum IS NOT INITIAL.
      wa_cell_types-columnname = 'AGENCYNUM'.
      wa_cell_types-value = if_salv_c_cell_type=>link.
      APPEND wa_cell_types TO wa_book-it_cell_types.
    ENDIF.

***********************************************************************
* Hyperlink informations
***********************************************************************
* Additional infos - controlled via IT_HYPERLINKS
* (column ADDITIONAL_INFOS to offer hyperlink, in fact it's only text,
* (column IT_HYPERLINKS control any hyperlinks in that line)

    CLEAR wa_hyperlinks.
    wa_hyperlinks-columnname = 'ADDITIONAL_INFOS'.

    CASE wa_book-class.
      WHEN 'F'.
        wa_book-additional_infos = text-sap.
        wa_hyperlinks-value = 1.
* refers to Hyperlink OBJECT with handle 1
      WHEN 'C'.
        wa_book-additional_infos = text-hlp.
        wa_hyperlinks-value = 2.
* refers to Hyperlink OBJECT with handle 2
      WHEN 'Y'.
        wa_book-additional_infos = text-srv.
        wa_hyperlinks-value = 3.
* refers to Hyperlink OBJECT with handle 3
    ENDCASE.

    APPEND wa_hyperlinks TO wa_book-it_hyperlinks.

* modify internal table
    MODIFY it_book
      FROM wa_book
      TRANSPORTING
        leaves_home
        goes_home
        it_colors
        invoice_icon
        exception
        additional_infos
        it_cell_types
        it_hyperlinks.
  ENDLOOP.
* create ALV object

  CASE 'X'.
    WHEN pa_full OR pa_list.
      IF pa_list = 'X'.
        list_display = if_salv_c_bool_sap=>true.
      ELSE.
        list_display = if_salv_c_bool_sap=>false.
      ENDIF.

      TRY.
          cl_salv_table=>factory(
            EXPORTING
              list_display   = list_display
*    R_CONTAINER    =
*    CONTAINER_NAME =
            IMPORTING
              r_salv_table   = gr_alv
            CHANGING
              t_table        = it_book
                 ).
        CATCH cx_salv_msg INTO gd_salv_msg.

          exc_handler=>process_alv_error_msg( gd_salv_msg ).
      ENDTRY.

      PERFORM set_everything USING gr_alv.
    WHEN pa_cont.
      CALL SCREEN 100.
  ENDCASE.

* display data
  gr_alv->display( ).
