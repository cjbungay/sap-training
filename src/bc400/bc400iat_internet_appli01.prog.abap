*----------------------------------------------------------------------*
***INCLUDE BC400IAT_INTERNET_APPLI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE okcode.
    WHEN 'DISP'.
      SELECT SINGLE * FROM spfli INTO CORRESPONDING FIELDS OF sdyn_conn
                      WHERE carrid = sdyn_conn-carrid
                      AND   connid = sdyn_conn-connid.
    WHEN 'SAVE'.
      CALL FUNCTION 'BC400_UPDATE_FLTIME'
           EXPORTING
                iv_carrid             = sdyn_conn-carrid
                iv_connid             = sdyn_conn-connid
                iv_fltime             = sdyn_conn-fltime
                iv_deptime            = sdyn_conn-deptime
           EXCEPTIONS
                flight_not_found      = 1
                update_spfli_rejected = 2
                flight_locked         = 3
                OTHERS                = 4.
      IF sy-subrc = 0.
        MESSAGE s148(bc400).
*   Änderung erfolgreich!
      ELSE.
        MESSAGE e147(bc400).
*   Änderung Flugverbindung konnte nicht gespeichert werden
      ENDIF.

    WHEN 'ENDE'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                 " user_command_0100  INPUT
