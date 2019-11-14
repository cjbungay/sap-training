*&-----------------------------------------------
*& Report  SAPBC408DYNS_1
*&-----------------------------------------------

REPORT  sapbc408dyns_1.

* work area and internal table for ALV data
DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight.
DATA  ok_code    LIKE sy-ucomm.

SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.

*************************************************
*ABAP events
*************************************************
START-OF-SELECTION.
  SELECT * FROM sflight
    INTO TABLE it_sflight
    WHERE carrid IN so_car
    AND   connid IN so_con.

  CALL SCREEN 100.

*************************************************
*PBO Modules
*************************************************
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.               " clear_ok_code  OUTPUT

*------------------------------------------------
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT

*************************************************
*PAI Modules
*************************************************
*------------------------------------------------
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.             " USER_COMMAND_0100  INPUT
