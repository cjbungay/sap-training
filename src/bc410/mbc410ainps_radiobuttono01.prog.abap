*----------------------------------------------------------------------*
***INCLUDE MBC410ADIAS_DYNPROO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  move_to_dynp  OUTPUT
*&---------------------------------------------------------------------*
*       copy data to screen structure
*----------------------------------------------------------------------*
MODULE move_to_dynp OUTPUT.
  MOVE-CORRESPONDING wa_sflight TO sdyn_conn.
ENDMODULE.                 " move_to_dynp  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  status_0100  OUTPUT
*&---------------------------------------------------------------------*
*       set status and title for screen 100
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  CASE 'X'.
    WHEN view.
      SET TITLEBAR 'TITLE_100' WITH 'Display'(vie).
    WHEN maintain_flights.
      SET TITLEBAR 'TITLE_100' WITH 'Maintain Flights'(fli).
    WHEN maintain_bookings.
      SET TITLEBAR 'TITLE_100' WITH 'Maintain Bookings'(boo).
  ENDCASE.

ENDMODULE.                 " status_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  status_0150  OUTPUT
*&---------------------------------------------------------------------*
*       set status and title for screen 150
*----------------------------------------------------------------------*
MODULE status_0150 OUTPUT.
  SET PF-STATUS 'STATUS_150'.
  SET TITLEBAR  'TITLE_150' WITH text-vie.
ENDMODULE.                 " status_0150  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       initialize ok_code
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  modify_screen  OUTPUT
*&---------------------------------------------------------------------*
*       change elements dynamically
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  IF maintain_flights = 'X'.
    SET PF-STATUS 'STATUS_100'.
    LOOP AT SCREEN.
      IF screen-name = 'SDYN_CONN-PLANETYPE'.
        screen-input = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    SET PF-STATUS 'STATUS_100' EXCLUDING 'SAVE'.
  ENDIF.

ENDMODULE.                 " modify_screen  OUTPUT
