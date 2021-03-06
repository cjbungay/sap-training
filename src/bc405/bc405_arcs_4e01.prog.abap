*&------------------------------------
*&  Include           BC405_ARCS_3E01
*&------------------------------------
*&------------------------------------
*&   Event START-OF-SELECTION
*&------------------------------------
START-OF-SELECTION.
* retrieve data into internal table
  SELECT        * FROM  sflight
    INTO TABLE it_sflight
         WHERE  carrid  IN so_car
         AND    connid  IN so_con.

  CASE 'X'.
    WHEN pa_full OR pa_list.

* decide about list display
      IF pa_list IS NOT INITIAL.
        list_display = if_salv_c_bool_sap=>true.
      ELSE.
        list_display = if_salv_c_bool_sap=>false.
      ENDIF.

* create ALV instance
      TRY.
          cl_salv_table=>factory(
           EXPORTING
             list_display   = list_display
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

    WHEN pa_cont.
      CALL SCREEN 100.
  ENDCASE.
