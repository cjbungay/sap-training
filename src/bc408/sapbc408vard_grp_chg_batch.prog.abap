*&---------------------------------------------------------------------*
*& Report  SAPBC408VARD_GRP_CHG_BATCH                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408vard_grp_chg_batch                                  .
DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight,
      ok_code TYPE sy-ucomm.

DATA: cont TYPE REF TO cl_gui_custom_container,
      alv TYPE REF TO cl_gui_alv_grid.
DATA: it_sort TYPE lvc_t_sort,
      wa_sort LIKE LINE OF it_sort.
DATA: my_print TYPE lvc_s_prnt.

SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.
SELECTION-SCREEN SKIP.

START-OF-SELECTION.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE get_data OUTPUT.


  SELECT * FROM sflight
  INTO TABLE it_sflight
  WHERE carrid IN so_car
  AND   connid IN so_con.

ENDMODULE.                 " get_data  OUTPUT

*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1
      .
  IF sy-subrc <> 0.
    MESSAGE w010(bc408).
  ENDIF.

  CREATE OBJECT alv
    EXPORTING
      i_parent          = cont
    EXCEPTIONS
      OTHERS            = 1
      .
  IF sy-subrc <> 0.
    MESSAGE w010(bc408).
  ENDIF.


ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
MODULE transfer_data OUTPUT.

  CLEAR wa_sort.
  wa_sort-spos      = 1.
  wa_sort-fieldname = 'CARRID'.
  wa_sort-up        = 'X'.
  wa_sort-group     = '*'.
  wa_sort-subtot    = 'X'.
  APPEND wa_sort TO it_sort.

  CLEAR wa_sort.
  wa_sort-spos      = 1.
  wa_sort-fieldname = 'CONNID'.
  wa_sort-up        = 'X'.
  APPEND wa_sort TO it_sort.

  my_print-grpchgedit = 'X'.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name              = 'SFLIGHT'
      is_print                      = my_print
    CHANGING
      it_outtab                     = it_sflight
      it_sort                       = it_sort
    EXCEPTIONS
      OTHERS                        = 1
          .
  IF sy-subrc <> 0.
    MESSAGE i012(bc408).
  ENDIF.

ENDMODULE.                 " transfer_data  OUTPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' or 'EXIT' OR 'CANC'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT

*----------------------------------------------------------------------*
FORM free.
  CALL METHOD: alv->free,
               cont->free.

  FREE: alv,
        cont.
ENDFORM.                    " free
