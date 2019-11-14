*&---------------------------------------------------------------------*
*& Report  SAPBC401_CLSS_ALV                                           *
*&---------------------------------------------------------------------*
*& Demo on ALV-Grid event-processing of double_click                   *
*&---------------------------------------------------------------------*

REPORT  sapbc401_clss_alv.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    "-------------
    METHODS on_double_click FOR EVENT double_click OF cl_gui_alv_grid
                              IMPORTING es_row_no e_column.
ENDCLASS.                    "lcl_event_handler DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.
    DATA: text TYPE string, es_row_string TYPE string.
    es_row_string = es_row_no-row_id.

    CONCATENATE 'row: ' es_row_string 'column: '
        e_column-fieldname INTO text .
    MESSAGE text TYPE 'I'.

  ENDMETHOD.                    "handler_method
ENDCLASS.                    "lcl_event_handler IMPLEMENTATION

************** Types and Data Definitions ************************
TYPES: ty_spfli TYPE STANDARD TABLE OF spfli
                     WITH KEY carrid connid.

DATA: r_handler TYPE REF TO lcl_event_handler.
DATA: r_container TYPE REF TO cl_gui_custom_container,
      r_alv_grid  TYPE REF TO cl_gui_alv_grid.

DATA: it_spfli TYPE ty_spfli.


START-OF-SELECTION.
*########################

  CREATE OBJECT r_handler.

  SELECT * FROM spfli INTO TABLE it_spfli.

*** calling the dynpro on which ALV-Grid will be shown *****
  CALL SCREEN '0100'.


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYNPROSTATUS'.
  SET TITLEBAR 'TITLE1'.
ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  ALV_GRID  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE alv_grid OUTPUT.
*** Create object of class CL_GUI_CUSTOM_CAONTAINER to manage data !
  IF NOT r_container IS BOUND.
    CREATE OBJECT r_container
      EXPORTING
        container_name              = 'CONTAINER_1'
      EXCEPTIONS
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.
*** create object of class cl_gui_alv_grid to visualize data !
  IF NOT r_alv_grid IS BOUND.
    CREATE OBJECT r_alv_grid
      EXPORTING
        i_parent          = r_container
      EXCEPTIONS
        OTHERS            = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*** set handler to react on double-click *******************
    SET HANDLER r_handler->on_double_click FOR r_alv_grid.

  ENDIF.
*** Call method to visualize data of internal table ************
  CALL METHOD r_alv_grid->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SPFLI'
    CHANGING
      it_outtab        = it_spfli
    EXCEPTIONS
      OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDMODULE.                 " ALV_GRID  OUTPUT
