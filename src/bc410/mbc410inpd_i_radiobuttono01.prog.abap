*----------------------------------------------------------------------*
*   INCLUDE MBC410DIAD_MODIFY_SCREENO01                                *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_to_200 OUTPUT.

  MOVE-CORRESPONDING wa_spfli TO sdyn_conn.

ENDMODULE.                             " GET_SPFLI_DATA  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.

  LOOP AT SCREEN.
    IF check_departure IS INITIAL AND screen-group1 = 'DEP'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
    IF check_arrival IS INITIAL AND screen-group1 = 'ARR'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
    IF ( NOT maintain IS INITIAL ) AND screen-group2 = 'MOD'.
      screen-input = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDMODULE.                             " MODIFY_SCREEN  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS 'DYNPRO'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'DYNPRO'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  clear ok_code.
ENDMODULE.                             " clear_ok_code  OUTPUT
