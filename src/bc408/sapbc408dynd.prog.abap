*&---------------------------------------------------------------------*
*& Report  SAPBC408DYND
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408dynd.

* work area plus internal table for ALV data and color information
DATA:
  wa_sbook TYPE sbook,
  it_sbook LIKE TABLE OF wa_sbook.

DATA:
  ok_code    LIKE sy-ucomm.

SELECT-OPTIONS: so_car FOR wa_sbook-carrid MEMORY ID car,
                so_con FOR wa_sbook-connid MEMORY ID con,
                so_dat FOR wa_sbook-fldate MEMORY ID dat.

START-OF-SELECTION.
  SELECT * FROM sbook
    INTO CORRESPONDING FIELDS OF TABLE it_sbook
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.

  CALL SCREEN 100.

************************************************************************
*PBO modules
************************************************************************
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.
ENDMODULE.                 " STATUS_0100  OUTPUT


************************************************************************
*PAI Modules
************************************************************************
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT
