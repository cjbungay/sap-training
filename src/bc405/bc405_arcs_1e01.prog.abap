*&---------------------------------------------------------------------*
*&  Include           SAPBC405_SSCS_1E01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&   Event START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
* retrieve data into internal table
  SELECT        * FROM  sflight INTO TABLE it_sflight
         WHERE  carrid  IN so_car
         AND    connid  IN so_con.

* create ALV instance

  TRY.
      cl_salv_table=>factory(
*   EXPORTING
*     LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE
*     R_CONTAINER    =
*     CONTAINER_NAME =
        IMPORTING
          r_salv_table   = gr_alv
        CHANGING
          t_table        = it_sflight
             ).
    CATCH cx_salv_msg INTO gr_error.
      cl_sapbc405_exc_handler=>process_alv_error_msg(
          r_error = gr_error
*    TYPE    = 'A'
             ).

  ENDTRY.

* display ALV
  gr_alv->display( ).
