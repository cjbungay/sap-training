*----------------------------------------------------------------------*
***INCLUDE MBC410ADIAS_DYNPROI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  check_sflight  INPUT
*&---------------------------------------------------------------------*
*       read flight data
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
  MESSAGE i007(bc410).

ENDMODULE.                 " check_sflight  INPUT
*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       process user command
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE io_command.
    WHEN 'X'.
      LEAVE TO SCREEN 0.

    WHEN 'T'.
      CALL SCREEN 150
        STARTING AT 10 10
        ENDING   AT 50 20.
      CLEAR io_command.

  ENDCASE.
ENDMODULE.                 " user_command_0100  INPUT
