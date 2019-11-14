*----------------------------------------------------------------------*
*   INCLUDE MBC410DIAD_MODIFY_SCREENI01                                *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  TRANS_FROM_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_100 INPUT.
  MOVE-CORRESPONDING sdyn_conn TO wa_spfli.
ENDMODULE.                             " TRANS_FROM_100  INPUT

*&---------------------------------------------------------------------*
*&      Module  CHECK_SPFLI  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_spfli INPUT.

  SELECT SINGLE * FROM spfli
        INTO CORRESPONDING FIELDS OF sdyn_conn
        WHERE carrid = sdyn_conn-carrid
          AND connid = sdyn_conn-connid .
  CHECK sy-subrc NE 0.
  MESSAGE e171(bc410).

ENDMODULE.                             " CHECK_SPFLI  INPUT


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
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 0.
  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0100  INPUT
