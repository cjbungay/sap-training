*&---------------------------------------------------------------------*
*& Report  SAPBC408ARCS_1                                              *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408arcs_1                                             .

* work area and internal table for ALV data
DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight.
DATA  ok_code    LIKE sy-ucomm.

DATA: cont       TYPE REF TO cl_gui_custom_container,
      alv        TYPE REF TO cl_gui_alv_grid.


SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.

************************************************************************
*ABAP events
************************************************************************
START-OF-SELECTION.
  SELECT * FROM sflight
    INTO TABLE it_sflight
    WHERE carrid IN so_car
    AND   connid IN so_con.
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
MODULE create_and_transfer OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE a010(bc405_408).
  ENDIF.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      it_outtab        = it_sflight
    EXCEPTIONS
      OTHERS           = 1.

  IF sy-subrc <> 0.
    MESSAGE a012(bc405_408).
  ENDIF.

ENDMODULE.                 " create_and_transfer  OUTPUT

************************************************************************
*PAI modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT


************************************************************************
*Form routines
************************************************************************
FORM free.
  CALL METHOD: alv->free,
               cont->free.
  FREE: alv,
        cont.
ENDFORM.                    " free
