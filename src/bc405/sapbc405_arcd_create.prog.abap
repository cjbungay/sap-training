*&---------------------------------------------------------------------*
*& Report  SAPBC405_ARCD_CREATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
INCLUDE bc405_arcd_createtop                  .    " global Data
INCLUDE bc405_arcd_createk01.
INCLUDE bc405_arcd_createo01                    .  " PBO-Modules
INCLUDE bc405_arcd_createi01                    .  " PAI-Modules


LOAD-OF-PROGRAM.
  date_from = sy-datum - 15.
  date_to = sy-datum + 15.

START-OF-SELECTION.
* retrieve data
  SELECT        * FROM  sbook
    INTO CORRESPONDING FIELDS OF TABLE it_book
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

    WHEN pa_cont.
      CALL SCREEN 100.
  ENDCASE.

* display data
  gr_alv->display( ).
