*&---------------------------------------------------------------------*
*& Report  SAPBC408LAYD_EXC
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408layd_exc.

DATA: BEGIN OF wa_sflight.
  INCLUDE TYPE sflight.
DATA: light,
  END OF wa_sflight,
  it_sflight LIKE TABLE OF wa_sflight.

DATA: percentage TYPE p DECIMALS 2,
      ok_code TYPE sy-ucomm.

DATA: alv TYPE REF TO cl_gui_alv_grid,
      cont TYPE REF TO cl_gui_custom_container.

DATA: wa_layout TYPE lvc_s_layo.

SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.

************************************************************************
START-OF-SELECTION.
  SELECT * FROM sflight
    INTO wa_sflight
    WHERE carrid IN so_car
    AND   connid IN so_con.

    percentage = wa_sflight-seatsocc * 100 / wa_sflight-seatsmax.
    IF percentage < 50.
      wa_sflight-light = '3'.
    ELSEIF percentage < 90.
      wa_sflight-light = '2'.
    ELSE.
      wa_sflight-light = '1'.
    ENDIF.
    APPEND wa_sflight TO it_sflight.
  ENDSELECT.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT

*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT' OR 'CANCEL'.
      PERFORM free. " here and there
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                 " exit  INPUT


*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1.

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
ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
MODULE transfer_data OUTPUT.
  wa_layout-sel_mode = 'D'. " cells, rows, columns
  wa_layout-cwidth_opt = 'X'.
  wa_layout-grid_title = 'Flüge'(001).
  wa_layout-excp_fname = 'LIGHT'.
*  wa_layout-excp_led = 'X'.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
      is_layout        = wa_layout
    CHANGING
      it_outtab        = it_sflight
    EXCEPTIONS
      OTHERS           = 1.

  IF sy-subrc <> 0.
    MESSAGE a012(bc408).
  ENDIF.

ENDMODULE.                 " transfer_data  OUTPUT

*----------------------------------------------------------------------*
FORM free.
  CALL METHOD: alv->free,
               cont->free.
  FREE: alv, cont.
ENDFORM.                    " free
