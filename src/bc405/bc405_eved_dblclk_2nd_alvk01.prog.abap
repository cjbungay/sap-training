*&---------------------------------------------------------------------*
*&  Include           BC405_EVED_DBLCLK_2ND_ALVK01
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_double_click FOR EVENT double_click
        OF cl_salv_events_table
        IMPORTING
          row.
ENDCLASS.                    "lcl_handler DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_handler IMPLEMENTATION.
  METHOD on_double_click.
    READ TABLE it_join INTO wa_join INDEX row.
    CHECK sy-subrc EQ 0.
    SELECT *
      FROM sflight
      INTO TABLE it_sflight
      WHERE carrid = wa_join-carrid
        AND connid = wa_join-connid.

    cl_salv_table=>factory(
      IMPORTING
        r_salv_table   = r_2nd_alv
      CHANGING
        t_table        = it_sflight
           ).

    r_2nd_alv->set_screen_popup(
        start_column = 5
        end_column   = 80
        start_line   = 5
        end_line     = 18
           ).

    r_2nd_alv->display( ).


  ENDMETHOD.                    "on_double_click
ENDCLASS.                    "lcl_handler IMPLEMENTATION
