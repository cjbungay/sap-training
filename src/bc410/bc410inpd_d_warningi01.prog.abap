*----------------------------------------------------------------------*
***INCLUDE BC410D_TEMPLATE1I01 .
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
*&      Module  TRANS_FROM_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_100 INPUT.
  MOVE-CORRESPONDING sdyn_conn00 TO wa_conn.
ENDMODULE.                             " TRANS_FROM_100  INPUT

*&---------------------------------------------------------------------*
*&      Module  GET_SFLIGHT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_sflight INPUT.

  SELECT SINGLE * INTO CORRESPONDING FIELDS OF sdyn_conn00
           FROM sflight WHERE carrid = sdyn_conn00-carrid
                          AND connid = sdyn_conn00-connid
                          AND fldate = sdyn_conn00-fldate.
  CHECK sy-subrc NE 0.
  MESSAGE e047.

ENDMODULE.                             " GET_SFLIGHT  INPUT

*&---------------------------------------------------------------------*
*&      Module  CHECK_CARRID  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_carrid INPUT.
  SELECT COUNT( * ) FROM scarr WHERE carrid = sdyn_conn00-carrid.
  CHECK sy-subrc NE 0.
  MESSAGE e049 WITH sdyn_conn00-carrid.

ENDMODULE.                             " CHECK_CARRID  INPUT

*&---------------------------------------------------------------------*
*&      Module  CHECK_CONNECTION  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_connection INPUT.
  SELECT COUNT( * ) FROM spfli WHERE carrid = sdyn_conn00-carrid
                                 AND connid = sdyn_conn00-connid.
  CHECK sy-subrc NE 0.
  MESSAGE e171.

ENDMODULE.                             " CHECK_CONNECTION  INPUT

*&---------------------------------------------------------------------*
*&      Module  CHECK_PLANETYPE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_planetype INPUT.
  SELECT SINGLE seatsmax INTO sdyn_conn00-seatsmax FROM saplane
      WHERE planetype = sdyn_conn00-planetype.
  CHECK sdyn_conn00-seatsmax < sdyn_conn00-seatsocc.
  MESSAGE w109.
ENDMODULE.                             " CHECK_PLANETYPE  INPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_FROM_200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_200 INPUT.
  MOVE-CORRESPONDING sdyn_conn00 TO wa_conn.
ENDMODULE.                             " TRANS_FROM_200  INPUT
