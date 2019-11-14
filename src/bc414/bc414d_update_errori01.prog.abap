*----------------------------------------------------------------------*
***INCLUDE BC414D_UPDATE_ERRORI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  save_ok_code = ok_code.
  clear ok_code.

  case save_ok_code.
    when 'BACK'.
      leave to screen 0.
    when 'CREATE'.
      loop at it_sflight into wa_sflight.
        CALL FUNCTION 'BC414_SFLIGHT_DUMMY' in update task
             EXPORTING
                  wa_sflight = wa_sflight.
      endloop.

      CALL FUNCTION 'BC414_UPDATE_ERROR' in update task
           EXPORTING
                wa_spfli = spfli.

      message s115(bc414).

      commit work.
  endcase.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_COMMAND_0100 INPUT.
  case ok_code.
    when 'CANCEL'.
      leave to screen 0.
    when 'EXIT'.
      leave program.
  endcase.
ENDMODULE.                 " EXIT_COMMAND_0100  INPUT
