*----------------------------------------------------------------------*
***BC410LISD_LIST_ON_DYNPROI01
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
    WHEN 'FLIGHTS'.
      PERFORM read_flights.
      SORT it_sflight BY carrid connid fldate.
      DESCRIBE TABLE it_sflight LINES my_table_control-lines.
      SET SCREEN 200.
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
    WHEN 'RESTORE'.
      REFRESH CONTROL 'MY_TABLE_CONTROL' FROM SCREEN '0200'.
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
ENDMODULE.                             " CHECK_SPFLI  INPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_FROM_TC_FIELDS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_tc_fields INPUT.
  MOVE sdyn_conn-mark TO wa_sflight-mark.
  MODIFY it_sflight INDEX my_table_control-current_line FROM wa_sflight.
ENDMODULE.                             " TRANS_FROM_TC_FIELDS  INPUT

*&---------------------------------------------------------------------*
*&      Module  CHANGE_COLS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE change_cols INPUT.
  MODIFY my_table_control-cols INDEX tc_cols-current_line FROM wa_cols.
ENDMODULE.                             " CHANGE_COLS  INPUT
