*&---------------------------------------------------------------------*
*& Report  SAPBC405_ARCD_CREATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

INCLUDE bc405_layd_selectionstop.
INCLUDE bc405_layd_selectionsk01.
INCLUDE bc405_layd_selectionso01.
INCLUDE bc405_layd_selectionsi01.
INCLUDE bc405_layd_selectionsf01.

LOAD-OF-PROGRAM.
  date_from = sy-datum - 15.
  date_to = sy-datum + 15.

START-OF-SELECTION.
* retrieve data
  SELECT      *
    INTO CORRESPONDING FIELDS OF TABLE it_book
    FROM  sbook INNER JOIN scustom
    ON sbook~customid = scustom~id
         WHERE  carrid  IN so_car
         AND    connid  IN so_con
         AND    fldate  IN so_date.

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
