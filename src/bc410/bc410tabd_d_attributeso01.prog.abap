*----------------------------------------------------------------------*
***BC410LISD_LIST_ON_DYNPROO01
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR 'TITLE_100'.

ENDMODULE.                             " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS_200'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_TC_FIELDS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_to_tc_fields OUTPUT.
  MOVE-CORRESPONDING wa_sflight TO sdyn_conn.
ENDMODULE.                             " TRANS_TO_TC_FIELDS  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_to_200 OUTPUT.
  MOVE-CORRESPONDING wa_spfli TO sdyn_conn.
ENDMODULE.                             " TRANS_TO_200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  CHANGE_COLUMN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE change_column OUTPUT.
  LOOP AT my_table_control-cols INTO wa_cols.
    CHECK NOT wa_cols-selected IS INITIAL.
    wa_cols-screen-intensified = '1'.
    MODIFY my_table_control-cols FROM wa_cols.
  ENDLOOP.

ENDMODULE.                             " CHANGE_COLUMN  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  CHECK wa_sflight-seatsocc < 20.
  LOOP AT SCREEN.
    CHECK screen-name = 'SDYN_CONN-SEATSOCC'.
    screen-intensified = 1.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                             " MODIFY_SCREEN  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  clear ok_code.
ENDMODULE.                             " clear_ok_code  OUTPUT
