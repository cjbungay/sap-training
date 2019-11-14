*----------------------------------------------------------------------*
***INCLUDE BC414S_UPDATE_STRAVELAGI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE save_ok.
    WHEN 'SAVE'.
      IF flag IS INITIAL.
* enries on table control not changed.
        SET SCREEN 0.
      ELSE.
* at least one field on table control changed
        PERFORM save_changes.
        SET SCREEN 0.
      ENDIF.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  SAVE_OK_CODE  INPUT
*&---------------------------------------------------------------------*
MODULE save_ok_code INPUT.
  save_ok = ok_code.
  CLEAR: ok_code.
ENDMODULE.                             " SAVE_OK_CODE  INPUT

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.
      IF sy-datar IS INITIAL AND flag IS INITIAL.
* no changes performed on screen
        LEAVE TO SCREEN 0.
      ELSE.
* at least one field on table control changed.
        PERFORM popup_to_confirm_loss_of_data.
      ENDIF.
  ENDCASE.
ENDMODULE.                             " EXIT  INPUT

*&---------------------------------------------------------------------*
*&      Module  SET_MARKER  INPUT
*&---------------------------------------------------------------------*
MODULE set_marker INPUT.
  MOVE-CORRESPONDING stravelag TO wa_travel.
  wa_travel-mark_changed = 'X'.
* mark datasets in internal table as modified
  MODIFY TABLE itab_travel FROM wa_travel.
* at least one dataset is modified in table control
  flag = 'X'.
ENDMODULE.                             " SET_MARKER  INPUT
