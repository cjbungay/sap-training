*----------------------------------------------------------------------*
***INCLUDE BC405_ARCDO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.

ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  create_control  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_control OUTPUT.
  IF gr_cont IS NOT BOUND.
    CREATE OBJECT gr_cont
      EXPORTING
        container_name              = 'MY_CONTAINER'
        .
    IF sy-subrc <> 0.
      MESSAGE a015(bc405).
*   Fehler beim Anlegen des Container Objekts.
    ENDIF.
  ENDIF.

  TRY.
      cl_salv_table=>factory(
        EXPORTING
*      list_display   = if_salv_c_bool_sap=>false
          r_container    = gr_cont
*      CONTAINER_NAME =
        IMPORTING
          r_salv_table   = gr_alv
        CHANGING
          t_table        = it_book
             ).
    CATCH cx_salv_msg INTO gd_salv_msg.

      exc_handler=>process_alv_error_msg( gd_salv_msg ).
  ENDTRY.

  gr_alv->display( ).

ENDMODULE.                 " create_control  OUTPUT
