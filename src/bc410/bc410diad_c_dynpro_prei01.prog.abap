*----------------------------------------------------------------------*
***INCLUDE BC410DIAD_C_DYNPRO_PREI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.
      CLEAR ok_code.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " EXIT  INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 100.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0200  INPUT

*&---------------------------------------------------------------------*
*&      Module  CHECK_SPFLI  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_spfli INPUT.
  SELECT SINGLE * FROM spfli INTO wa_spfli
  WHERE carrid = sdyn_conn-carrid
    AND connid = sdyn_conn-connid.
  IF sy-subrc = 0.
    MOVE-CORRESPONDING wa_spfli TO sdyn_conn.
  ENDIF.
ENDMODULE.                             " CHECK_SPFLI  INPUT
