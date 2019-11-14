*&---------------------------------------------------------------------*
*&  Include           BC405_ARCD_CREATEK01
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       CLASS exc_handler DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS exc_handler DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS process_alv_error_msg IMPORTING r_error TYPE REF TO
    cx_salv_error     .

ENDCLASS.                    "exc_handler DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_added_function
        FOR EVENT added_function OF cl_salv_events_table
        IMPORTING e_salv_function,  " type salv_de_function
      on_double_click
        FOR EVENT double_click OF cl_salv_events_table
        IMPORTING
          row      " type salv_de_row
          column,   " type salv_de_column
      on_link_click
        FOR EVENT link_click OF cl_salv_events_table
        IMPORTING
          row      " type salv_de_row
          column.   " type salv_de_column

    CLASS-METHODS:
      on_top_of_page
        FOR EVENT top_of_page OF cl_salv_events_table
        IMPORTING
          r_top_of_page  " cl_salv_form
          page           " sypagno
          table_index.   " syindex

ENDCLASS.                    "lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       CLASS exc_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS exc_handler IMPLEMENTATION.
  METHOD process_alv_error_msg.
    DATA: result_message TYPE bal_s_msg .
    result_message = r_error->get_message(  ).
    MESSAGE ID result_message-msgid
            TYPE 'A'
            NUMBER result_message-msgno
            WITH result_message-msgv1
                 result_message-msgv2
                 result_message-msgv3
                 result_message-msgv4.

  ENDMETHOD.                    "process_alv_error_msg

ENDCLASS.                    "exc_handler IMPLEMENTATION

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_added_function.
    DATA: lr_columns TYPE REF TO cl_salv_columns_table,
          lr_column TYPE REF TO cl_salv_column_table,
          lr_functions TYPE REF TO cl_salv_functions_list.
    CASE e_salv_function.
      WHEN 'ONLY_CD'.    " only columns with customer data
* get the COLUMNS object
        lr_columns = gr_alv->get_columns( ).
* set several columns invisible
* hide column LEAVES_HOME
        lr_column ?= lr_columns->get_column(
                       columnname = 'LEAVES_HOME' ).
        lr_column->set_visible(
            value  = if_salv_c_bool_sap=>false ).

* hide column GOES_HOME
        lr_column ?= lr_columns->get_column(
                       columnname = 'GOES_HOME' ).
        lr_column->set_visible(
            value  = if_salv_c_bool_sap=>false ).
* hide function
* get the FUNCTIONS object
        lr_functions = gr_alv->get_functions( ).
        lr_functions->set_function(
            name    = 'ONLY_CD'
            boolean = if_salv_c_bool_sap=>false
               ).
    ENDCASE.
  ENDMETHOD.                    "on_added_function

  METHOD on_double_click.
    DATA: n_o_bookings TYPE n,
          m_text(70),
          c_row(10).
    READ TABLE it_book INTO wa_book INDEX row.
    IF sy-subrc EQ 0.
      SELECT COUNT( * ) FROM  sbook
        INTO n_o_bookings
        WHERE  customid  = wa_book-customid.

      c_row = row.
      CONCATENATE
        'Customer' wa_book-customid 'had'
        n_o_bookings 'bookings so far! (Row:' c_row
        'Column:' column ')'
        INTO m_text SEPARATED BY space.

      MESSAGE m_text TYPE 'I'.
    ENDIF.
  ENDMETHOD.                    "on_double_click

  METHOD on_link_click.
    DATA: m_text(70).
    CASE column.
      WHEN 'LUGGWEIGHT'.
        m_text = text-lwl.
        MESSAGE m_text TYPE 'I'.
      WHEN 'TELEPHONE'.
        m_text = text-tel.
        MESSAGE m_text TYPE 'I'.
      WHEN 'LEAVES_HOME'.
* change flag
        READ TABLE it_book INTO wa_book INDEX row.
        IF sy-subrc = 0.
          IF wa_book-leaves_home = 'X'.
            CLEAR wa_book-leaves_home.
          ELSE.
            wa_book-leaves_home = 'X'.
          ENDIF.

          MODIFY it_book FROM wa_book
            INDEX row TRANSPORTING leaves_home.
          gr_alv->refresh( ).
        ENDIF.
      WHEN 'GOES_HOME'.
* change flag
        READ TABLE it_book INTO wa_book INDEX row.
        IF sy-subrc = 0.
          IF wa_book-goes_home = 'X'.
            CLEAR wa_book-goes_home.
          ELSE.
            wa_book-goes_home = 'X'.
          ENDIF.

          MODIFY it_book FROM wa_book
            INDEX row TRANSPORTING goes_home.
          gr_alv->refresh( ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.                    "on_link_click

  METHOD on_top_of_page.
    DATA: header_text(70).
    DATA: lr_content
            TYPE REF TO cl_salv_form_element.
    DATA: lr_text TYPE REF TO cl_salv_form_text.
* read data set #1 of current page
    READ TABLE it_book INTO wa_book INDEX table_index.
    IF sy-subrc EQ 0.
* concatenate heading text
      CONCATENATE
        'Airline'(air) wa_book-carrid
        'Connection'(con) wa_book-connid
        INTO header_text
        SEPARATED BY space.
* create text object (of class cl_salv_form_text)
      CREATE OBJECT lr_text
        EXPORTING
          text   = header_text.
* widening cast
*  (cl_salv_form_element is superclass for cl_salv_form_text)
      lr_content = lr_text.
* set content of top-of-page-area
*  ( r_top_of_page points to it -
*    we got hold of it via the event's interface )
      r_top_of_page->set_content( lr_content ).
    ENDIF.
  ENDMETHOD.                    "on_top_of_page
ENDCLASS.                    "lcl_event_handler DEFINITION
