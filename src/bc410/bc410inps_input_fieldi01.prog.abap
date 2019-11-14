*----------------------------------------------------------------------*
***INCLUDE BC410INPS_INPUT_FIELDI01
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_100 INPUT.
  CASE save_ok.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND  INPUT

*&---------------------------------------------------------------------*
*&      Module  SAVE_OK_CODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE save_ok_code INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
ENDMODULE.                             " SAVE_OK_CODE  INPUT
*&---------------------------------------------------------------------*
*&      Module  CHECK_SFLIGHT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_sflight INPUT.
  CHECK sdyn_conn00-carrid NE wa_sflight-carrid
     OR sdyn_conn00-connid NE wa_sflight-connid
     OR sdyn_conn00-fldate NE wa_sflight-fldate.
  SELECT SINGLE * INTO CORRESPONDING FIELDS OF sdyn_conn00 FROM sflight
    WHERE carrid = sdyn_conn00-carrid
      AND connid = sdyn_conn00-connid
      AND fldate = sdyn_conn00-fldate.
  CHECK sy-subrc NE 0.
  MESSAGE e007(bc410).
ENDMODULE.                             " CHECK_SFLIGHT  INPUT
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
*&      Module  TRANS_FROM_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_100 INPUT.
  MOVE-CORRESPONDING sdyn_conn00 TO wa_sflight.
ENDMODULE.                             " TRANS_FROM_100  INPUT

