*&---------------------------------------------------------------------*
*& Report  SAPBC408ARCD_ONE_SCREEN                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408arcd_one_screen.
DATA: wa_sbook TYPE sbook,
      it_sbook LIKE TABLE OF wa_sbook,
      ok_code  LIKE sy-ucomm.

DATA: alv      TYPE REF TO cl_gui_alv_grid,
      cont     TYPE REF TO cl_gui_custom_container.


SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
SELECT-OPTIONS:
  so_car FOR wa_sbook-carrid MEMORY ID car DEFAULT 'AA',
  so_con FOR wa_sbook-connid MEMORY ID con,
  so_dat FOR wa_sbook-fldate.
SELECTION-SCREEN END OF SCREEN 101.

START-OF-SELECTION.
  CALL SCREEN 100.

*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
MODULE create_objects OUTPUT.

  IF cont IS INITIAL.
    CREATE OBJECT cont
      EXPORTING
        container_name    = 'CONTROL_AREA'
      EXCEPTIONS
        OTHERS            = 1.

    IF sy-subrc <> 0.
      MESSAGE a010(bc408).
    ENDIF.

    CREATE OBJECT alv
      EXPORTING
        i_parent          = cont
      EXCEPTIONS
        OTHERS            = 1.

    IF sy-subrc <> 0.
      MESSAGE a010(bc408).
    ENDIF.
  ENDIF.

  ON CHANGE OF it_sbook.
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
  ENDON.
ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT'.
      CALL METHOD: alv->free, cont->free.
      FREE: alv, cont.
      SET SCREEN 0.
    WHEN 'CANC'.
      CLEAR: so_car, so_con, so_dat.
      REFRESH: so_car, so_con, so_dat.
    WHEN 'READ'.
      SELECT * FROM sbook
        INTO TABLE it_sbook
        WHERE carrid IN so_car AND
              connid IN so_con AND
              fldate IN so_dat.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
