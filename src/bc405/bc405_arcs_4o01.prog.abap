*----------------------------------
***INCLUDE BC405_ARCS_3O01 .
*----------------------------------
*&---------------------------------
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------
*       text
*----------------------------------
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.

ENDMODULE.   " STATUS_0100  OUTPUT
*&-------------------------------------
*&      Module  create_control  OUTPUT
*&-------------------------------------
*       text
*--------------------------------------
MODULE create_control OUTPUT.
  IF gr_cont IS NOT BOUND.

* create container control and link it to the dynpro
    CREATE OBJECT gr_cont
      EXPORTING
        container_name    = 'MY_CONTAINER'
      EXCEPTIONS
        OTHERS            = 1
        .
    IF sy-subrc <> 0.
      MESSAGE a015(bc405).
*   Fehler beim Anlegen des Container Objekts.
    ENDIF.

* create ALV and link it to the container control
    TRY.
        cl_salv_table=>factory(
          EXPORTING
*    LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE
            r_container    = gr_cont
*    CONTAINER_NAME =
          IMPORTING
            r_salv_table   = gr_alv
          CHANGING
            t_table        = it_sflight
               ).
      CATCH cx_salv_msg INTO gr_error.
    ENDTRY.

* display ALV
    gr_alv->display( ).
  ENDIF.
ENDMODULE.    " create_control  OUTPUT
