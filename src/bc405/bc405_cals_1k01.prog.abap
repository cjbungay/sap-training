*&-----------------------------------------------
*&  Include           BC405_CALS_1K01
*&-----------------------------------------------
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_double_click FOR EVENT double_click
        OF cl_salv_events_table
        IMPORTING
          row
          column,
      on_added_function FOR EVENT added_function
        OF cl_salv_events_table
        IMPORTING
          e_salv_function.

ENDCLASS.          "lcl_handler DEFINITION
*-------------------------------------------------
*       CLASS lcl_handler IMPLEMENTATION
*-------------------------------------------------
CLASS lcl_handler IMPLEMENTATION.
  METHOD on_double_click.
    READ TABLE it_spfli INTO wa_spfli INDEX row.
    CHECK sy-subrc EQ 0.

    SUBMIT sapbc405_eves_3 AND RETURN
            WITH pa_full EQ 'X'
*        with p_layout ...
            WITH so_car EQ wa_spfli-carrid
            WITH so_con EQ wa_spfli-connid.

  ENDMETHOD.                    "on_double_click

  METHOD on_added_function.
    DATA: l_salv_s_cell TYPE salv_s_cell,
          l_salv_t_row TYPE salv_t_row,
          l_row TYPE i.
    DATA: l_it_spfli TYPE TABLE OF spfli.

    CASE e_salv_function.
      WHEN 'MAINTAIN'.
* get current cell
        l_salv_s_cell =
          r_selections->get_current_cell( ).
        READ TABLE it_spfli INTO wa_spfli
          INDEX l_salv_s_cell-row.
        CHECK sy-subrc EQ 0.

        SET PARAMETER:
          ID 'CAR' FIELD wa_spfli-carrid,
          ID 'CON' FIELD wa_spfli-connid.
        CALL TRANSACTION 'SAPBC405CAL'.
      WHEN 'MULTI_ROWS'.
        l_salv_t_row = r_selections->get_selected_rows( ).
        LOOP AT l_salv_t_row INTO l_row.
          READ TABLE it_spfli INTO wa_spfli
            INDEX l_row.
          CHECK sy-subrc EQ 0.
          APPEND wa_spfli TO l_it_spfli.
        ENDLOOP.

        EXPORT mem_it_spfli FROM l_it_spfli
          TO MEMORY ID 'BC405'.

        SUBMIT sapbc405_calx_flights AND RETURN.
    ENDCASE.
  ENDMETHOD.     "on_added_function

ENDCLASS.        "lcl_handler IMPLEMENTATION
