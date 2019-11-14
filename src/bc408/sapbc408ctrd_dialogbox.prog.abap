*&---------------------------------------------------------------------*
*& Report  SAPBC408CTRD_DIALOGBOX
*&                                                                     *
*&---------------------------------------------------------------------*
*& Displaying an ALV Grid Control in a dialogbox container.
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408ctrd_dialogbox.
* internal table for ALV data
DATA:
  it_sbook             TYPE TABLE OF sbook.

DATA:
  ok_code              LIKE sy-ucomm.

DATA:
  cont                 TYPE REF TO cl_gui_dialogbox_container,
  alv                  TYPE REF TO cl_gui_alv_grid.

* needed for data transportation ABAP <-> dynpro
TABLES: sbook.


************************************************************************
*Local class for ALV event handling
************************************************************************
CLASS: lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_close
                     FOR EVENT close OF cl_gui_dialogbox_container
                     IMPORTING sender.
ENDCLASS.                    "lcl_handler DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS: lcl_handler IMPLEMENTATION.
  METHOD on_close.
    CALL METHOD sender->free.
    FREE: alv, cont.
  ENDMETHOD.                    "on_close
ENDCLASS.                    "lcl_handler IMPLEMENTATION

************************************************************************
START-OF-SELECTION.
  CALL SCREEN 100.

************************************************************************
*PBO modules
************************************************************************
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      width                  = 600
      height                 = 200
      top                    = 50
      left                   = 300
     caption                = 'ALV in a Dialogbox Container'(001)"#EC *
    EXCEPTIONS
      OTHERS                      = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc408).
  ENDIF.

  SET HANDLER lcl_handler=>on_close  FOR cont.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc408).
  ENDIF.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SBOOK'
    CHANGING
      it_outtab        = it_sbook
    EXCEPTIONS
      OTHERS           = 1.
  IF sy-subrc <> 0.
    MESSAGE a012(bc408).
  ENDIF.
ENDMODULE.                 " create_objects  OUTPUT


************************************************************************
*PAI Modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'ALV'.
      SELECT *
        FROM sbook
        INTO TABLE it_sbook
        WHERE carrid = sbook-carrid.
      IF alv IS NOT INITIAL.
        CALL METHOD alv->refresh_table_display.
      ENDIF.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      CALL METHOD: alv->free, cont->free.
      FREE: alv, cont.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
