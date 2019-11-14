*----------------------------------------------------------------------*
***INCLUDE BC401_CALD_CREATE_CUSTOMERI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.

    WHEN 'EXIT'.
      IF sy-datar IS INITIAL AND flag IS INITIAL.
* no changes on screen 100
        LEAVE PROGRAM.
      ELSE.
        PERFORM ask_save USING answer.
        CASE answer.
          WHEN 'J'.
            ok_code = 'SAVE&EXIT'.
          WHEN 'N'.
            LEAVE PROGRAM.
          WHEN 'A'.
            CLEAR ok_code.
            SET SCREEN 100.
        ENDCASE.
      ENDIF.

    WHEN 'CANCEL'.
      IF sy-datar IS INITIAL AND flag IS INITIAL.
* no changes on screen 100
        LEAVE TO SCREEN 0.
      ELSE.
        PERFORM ask_loss USING answer.
        CASE answer.
          WHEN 'J'.
            LEAVE TO SCREEN 0.
          WHEN 'N'.
            CLEAR ok_code.
            SET SCREEN 100.
        ENDCASE.
      ENDIF.

  ENDCASE.
ENDMODULE.                             " EXIT  INPUT

*&---------------------------------------------------------------------*
*&      Module  SAVE_OK_CODE  INPUT
*&---------------------------------------------------------------------*
MODULE save_ok_code INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
ENDMODULE.                             " SAVE_OK_CODE  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE save_ok.

    WHEN 'SAVE&EXIT'.
      PERFORM save.
      LEAVE PROGRAM.

    WHEN 'SAVE'.
      IF flag IS INITIAL.
        SET SCREEN 100.
      ELSE.
        PERFORM save.
        SET SCREEN 0.
      ENDIF.

    WHEN 'BACK'.
      IF flag IS INITIAL.
        SET SCREEN 0.
      ELSE.
        PERFORM ask_save USING answer.
        CASE answer.
          WHEN 'J'.
            PERFORM save.
            SET SCREEN 0.
          WHEN 'N'.
            SET SCREEN 0.
          WHEN 'A'.
            SET SCREEN 100.
        ENDCASE.
      ENDIF.

  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  MARK_CHANGED  INPUT
*&---------------------------------------------------------------------*
MODULE mark_changed INPUT.
* set flag to mark that changes have been made on screen 100
  flag = 'X'.
ENDMODULE.                             " MARK_CHANGED  INPUT
