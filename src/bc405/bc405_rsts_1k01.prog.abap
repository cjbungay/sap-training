*&------------------------------------------------
*&  Include           BC405_EVES_2K01
*&------------------------------------------------
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_added_function
        FOR EVENT added_function
          OF cl_salv_events_table
        IMPORTING e_salv_function,  " type salv_de_function
      on_double_click
        FOR EVENT double_click
          OF cl_salv_events_table
        IMPORTING
          row,   " type salv_de_row = int4
      on_link_click
        FOR EVENT link_click
          OF cl_salv_events_table
        IMPORTING
          row    " type salv_de_row = int4
          column." type salv_de_column = char(30)

ENDCLASS.                    "lcl_handler DEFINITION

*-------------------------------------------------
*       CLASS lcl_handler IMPLEMENTATION
*-------------------------------------------------
CLASS lcl_handler IMPLEMENTATION.
  METHOD on_added_function.
    DATA: lr_columns TYPE REF TO cl_salv_columns_table,
          lr_column TYPE REF TO cl_salv_column_table.
    DATA: l_lvc_s_colo TYPE lvc_s_colo.
    CASE e_salv_function.
      WHEN 'REORDER'.
* get the COLUMNS object
        lr_columns = gr_alv->get_columns( ).
* positions: (MANDT column + 3 key colums)
        lr_columns->set_column_position(
            columnname = 'SEATSOCC'
            position   = 5
               ).

        lr_columns->set_column_position(
            columnname = 'SEATSOCC_B'
            position   = 6
               ).

        lr_columns->set_column_position(
            columnname = 'SEATSOCC_F'
            position   = 7
               ).

* prepare color info
        l_lvc_s_colo-col = col_negative.
        l_lvc_s_colo-int = 0.
        l_lvc_s_colo-inv = 0.
* column SEATSOCC
        lr_column
          ?= lr_columns->get_column(
               columnname = 'SEATSOCC' ).
        lr_column->set_color( value = l_lvc_s_colo ).

* column SEATSOCC_B
        lr_column
          ?= lr_columns->get_column(
               columnname = 'SEATSOCC_B' ).
        lr_column->set_color( value = l_lvc_s_colo ).

* column SEATSOCC_F
        lr_column
          ?= lr_columns->get_column(
               columnname = 'SEATSOCC_F' ).
        lr_column->set_color( value = l_lvc_s_colo ).

    ENDCASE.
  ENDMETHOD.                    "on_added_function

  METHOD on_double_click.
    DATA: message_text(70),
          lc_seatsfree_e(10),
          lc_seatsfree_b(10),
          lc_seatsfree_f(10).

    READ TABLE it_sflight INTO wa_sflight INDEX row.
    CHECK sy-subrc EQ 0.
    lc_seatsfree_e =
      wa_sflight-seatsmax - wa_sflight-seatsocc.
    lc_seatsfree_b =
      wa_sflight-seatsmax_b - wa_sflight-seatsocc_b.
    lc_seatsfree_f =
      wa_sflight-seatsmax_f - wa_sflight-seatsocc_f.

    CONCATENATE
      'Free Seats:'(frs)
      'Economy:'(eco) lc_seatsfree_e
      'Business'(bus) lc_seatsfree_b
      'First'(fst) lc_seatsfree_f
      INTO message_text SEPARATED BY space.

    MESSAGE message_text TYPE 'I'.

  ENDMETHOD. "on_double_click

  METHOD on_link_click.
    DATA: lc_carrname TYPE scarr-carrname,
          lc_currcode TYPE scarr-currcode,
          message_text(70).

    READ TABLE it_sflight INTO wa_sflight INDEX row.
    CHECK sy-subrc EQ 0.
    CASE column.
      WHEN 'CARRID'.
        SELECT SINGLE carrname currcode
          INTO (lc_carrname, lc_currcode)
          FROM scarr
          WHERE carrid = wa_sflight-carrid.
        IF sy-subrc EQ 0.
          CONCATENATE
            'Airline:'(air) wa_sflight-carrid
            'Name:'(nme) lc_carrname
            'Currency:' lc_currcode
            INTO message_text
              SEPARATED BY space.

          MESSAGE message_text TYPE 'I'.
        ENDIF.
    ENDCASE.
  ENDMETHOD. "on_link_click
ENDCLASS.    "lcl_handler IMPLEMENTATION
