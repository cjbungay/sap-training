*----------------------------------------------------------------------*
***INCLUDE TAW10_CST_WAITLIST_I01 .
*----------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Module  check_cust  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_cust INPUT.
  SELECT SINGLE name street city FROM scustom
                                INTO CORRESPONDING FIELDS OF scustom
                                WHERE id = scustom-id.
  IF sy-subrc <> 0.
    CLEAR: scustom-name, scustom-city.
    MESSAGE e000(taw10) WITH scustom-id.
*   Kundennummer & ist nicht vorhanden. Bitte Eingabe korrigieren!
  ENDIF.
ENDMODULE.                 " check_cust  INPUT


*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'CREATE'.
*     ...


    WHEN 'SHOW'.
*     ...


    WHEN 'DELETE'.
*     ...


    WHEN 'FIRST'.
*     ...


    WHEN 'ADD'.
*     ...


    WHEN 'DEL'.
*     ...


    WHEN 'POS'.
*     ...


    WHEN 'STATWL' OR 'STATCU' OR 'STATPR'.
*     ...


    WHEN 'LOG'.
*     ...


  ENDCASE.


ENDMODULE.                 " user_command_0100  INPUT


*&---------------------------------------------------------------------*
*&      Module  check_flight  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_flight INPUT.
  SELECT SINGLE * FROM sflight INTO wa_sflight
      WHERE      carrid = sdyn_conn-carrid
            AND  connid = sdyn_conn-connid
            AND  fldate = sdyn_conn-fldate.

  IF sy-subrc <> 0.
    MESSAGE e004(taw10).
*   Bitte einen gültigen Flug auswählen
  ENDIF.
ENDMODULE.                 " check_flight  INPUT


*&---------------------------------------------------------------------*
*&      Module  exit  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

  CASE ok_code.
    WHEN 'CANCEL'.
      CLEAR: scustom, sdyn_conn.
      LEAVE TO SCREEN 100.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.                 " exit  INPUT
