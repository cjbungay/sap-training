*&---------------------------------------------------------------------*
*& Report  SAPBC408DYND_ONE_SCREEN_TC                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408dynd_one_screen_tc                                  .
DATA:
  wa_sflight TYPE sflight,
  it_sflight LIKE TABLE OF wa_sflight,
  ok_code    TYPE sy-ucomm,
  first_time VALUE 'X'.

TABLES: sflight.
CONTROLS: my_control TYPE TABLEVIEW USING SCREEN '0102'.

SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.
SELECTION-SCREEN END OF SCREEN 101.

*----------------------------------------------------------------------*
START-OF-SELECTION.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
*PBO modules
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE move_to_tc OUTPUT.
  MOVE wa_sflight TO sflight.
ENDMODULE.                 " move_to_tc  OUTPUT

*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
*PAI modules
*----------------------------------------------------------------------*

MODULE trans_from_tc INPUT.
  MOVE sflight TO wa_sflight.
  MODIFY it_sflight INDEX my_control-current_line
  FROM wa_sflight TRANSPORTING seatsmax seatsocc.
ENDMODULE.                 " trans_from_tc  INPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'READ'.
      SELECT * FROM sflight
        INTO TABLE it_sflight
        WHERE carrid IN so_car
        AND   connid IN so_con.
      my_control-lines = sy-dbcnt.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT


*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANC'.
      CLEAR: so_car, so_con.
      REFRESH: so_car, so_con.
      REFRESH it_sflight.
      LEAVE TO SCREEN 100.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                 " exit  INPUT
