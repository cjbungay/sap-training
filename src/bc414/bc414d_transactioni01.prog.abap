*----------------------------------------------------------------------*
***INCLUDE BC414D_TRANSACTIONI01 .
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
    when 'SHOW'.
      SELECT single * FROM  spfli into spfli
             WHERE  carrid  = sflight-carrid
             AND    connid  = sflight-connid.
      leave to screen 200.
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
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_COMMAND_0200 INPUT.
  case ok_code.
   when 'CANCEL'.
     leave to screen 100.
   when 'EXIT'.
     leave program.
 endcase.
ENDMODULE.                 " EXIT_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.
  save_ok_code = ok_code.
  clear ok_code.

  case save_ok_code.
    when 'BACK'.
      leave to screen 100.
  endcase.
ENDMODULE.                 " USER_COMMAND_0200  INPUT
