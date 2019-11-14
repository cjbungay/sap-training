*----------------------------------------------------------------------*
***INCLUDE MBC410ADIAS_DYNPROI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  check_sflight  INPUT
*&---------------------------------------------------------------------*
*       Read flight record from database
*----------------------------------------------------------------------*
MODULE check_sflight INPUT.
  SELECT SINGLE *
    FROM sflight
* INTO CORRESPONDING FIELDS OF sdyn_conn 	" direct read
    INTO wa_sflight         " Read into internal structure
    WHERE carrid = sdyn_conn-carrid AND
          connid = sdyn_conn-connid AND
          fldate = sdyn_conn-fldate.
  CHECK sy-subrc <> 0.
  CLEAR wa_sflight.
  MESSAGE e007(bc410).

ENDMODULE.                 " check_sflight  INPUT
*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       process user command
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

* display time on add'l screen
    WHEN 'TIME'.
      CALL SCREEN 150
        STARTING AT 10 10
        ENDING   AT 50 20.

  ENDCASE.
ENDMODULE.                 " user_command_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  exit  INPUT
*&---------------------------------------------------------------------*
*       process EXIT functions (type 'E')
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.
      CLEAR wa_sflight.
      SET PARAMETER ID:
        'CAR' FIELD wa_sflight-carrid,
        'CON' FIELD wa_sflight-connid,
        'DAY' FIELD wa_sflight-fldate.
      LEAVE TO SCREEN 100.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " exit  INPUT
