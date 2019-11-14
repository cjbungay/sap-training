*&---------------------------------------------------------------------*
*& Report  SAPBC401_CLSS_ALV                                           *
*&---------------------------------------------------------------------*
*& Demo on ALV-Grid event-processing of double_click                   *
*&---------------------------------------------------------------------*

REPORT  sapbc401_clss_alv.
DATA ok_code TYPE sy-ucomm.

TYPES: ty_spfli TYPE STANDARD TABLE OF spfli
                     WITH KEY carrid connid.

TYPES: ty_sflight TYPE STANDARD TABLE OF sflight
                     WITH KEY carrid connid fldate.

DATA: r_container TYPE REF TO cl_gui_custom_container,
      r_alv_grid  TYPE REF TO cl_gui_alv_grid.

DATA: it_spfli TYPE ty_spfli.
DATA: it_sflight TYPE ty_sflight.


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

    DATA: wa_sflight TYPE sflight,
          wa_spfli TYPE spfli.

    READ TABLE it_spfli INTO wa_spfli
                        INDEX es_row_no-row_id.
    SELECT * FROM sflight INTO TABLE it_sflight
              WHERE carrid = wa_spfli-carrid.

*** Call method to visualize data of internal table ************
    CALL METHOD r_alv_grid->set_table_for_first_display
      EXPORTING
        i_structure_name = 'SFLIGHT'
      CHANGING
        it_outtab        = it_sflight
      EXCEPTIONS
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.                    "handler_method
ENDCLASS.                    "lcl_event_handler IMPLEMENTATION



************** Types and Data Definitions ************************
DATA: r_handler TYPE REF TO lcl_event_handler.

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
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA: save_ok TYPE sy-ucomm.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN 'BACK'.
      SET SCREEN '0100'.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  SET_TABLE_FOR_FIRST_DISPLAY  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_table_for_first_display OUTPUT.

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

ENDMODULE.                 " SET_TABLE_FOR_FIRST_DISPLAY  OUTPUT
