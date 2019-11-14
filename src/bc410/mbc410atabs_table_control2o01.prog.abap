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
  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR  'TITLE_100' WITH text-vie.

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
*&---------------------------------------------------------------------*
*&      Module  fill_dynnr  OUTPUT
*&---------------------------------------------------------------------*
*       determine subscreen number
*----------------------------------------------------------------------*
MODULE fill_dynnr OUTPUT.
  CASE my_tabstrip-activetab.
    WHEN 'FC1'.
      dynnr = 110.
    WHEN 'FC2'.
      dynnr = 120.
    WHEN 'FC3'.
      dynnr = 130.
    WHEN OTHERS.
      my_tabstrip-activetab = 'FC1'.
      dynnr = 110.
  ENDCASE.
ENDMODULE.                 " fill_dynnr  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  get_spfli  OUTPUT
*&---------------------------------------------------------------------*
*       read SPFLI data from database
*----------------------------------------------------------------------*
MODULE get_spfli OUTPUT.
  ON CHANGE OF wa_sflight-carrid
            OR wa_sflight-connid.
    SELECT SINGLE * INTO CORRESPONDING FIELDS OF
    sdyn_conn FROM spfli
    WHERE carrid = wa_sflight-carrid
    AND connid = wa_sflight-connid.
  ENDON.
ENDMODULE.                 " get_spfli  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  get_saplane  OUTPUT
*&---------------------------------------------------------------------*
*       read SAPLANE data from database
*----------------------------------------------------------------------*
MODULE get_saplane OUTPUT.
  ON CHANGE OF wa_sflight-planetype.
    SELECT SINGLE * FROM saplane
    WHERE planetype = wa_sflight-planetype.
  ENDON.
ENDMODULE.                 " get_saplane  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  get_sbook  OUTPUT
*&---------------------------------------------------------------------*
*       read bookings of this flight
*----------------------------------------------------------------------*
MODULE get_sbook OUTPUT.
  ON CHANGE OF wa_sflight-carrid OR
               wa_sflight-connid OR
               wa_sflight-fldate .
    SELECT * FROM sbook
      INTO CORRESPONDING FIELDS OF TABLE it_sdyn_book
      WHERE carrid    = wa_sflight-carrid
        AND connid    = wa_sflight-connid
        AND fldate    = wa_sflight-fldate
        AND cancelled = not_cancelled.

    my_table_control-lines = LINES( it_sdyn_book ).
  ENDON.
ENDMODULE.                 " get_sbook  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  trans_to_tc  OUTPUT
*&---------------------------------------------------------------------*
*       copy booking data to TABLES structure
*----------------------------------------------------------------------*
MODULE trans_to_tc OUTPUT.
  MOVE wa_sdyn_book TO sdyn_book.
ENDMODULE.                 " trans_to_tc  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  modify_tc_line  OUTPUT
*&---------------------------------------------------------------------*
*       highlite smokers if wanted
*----------------------------------------------------------------------*
MODULE modify_tc_line OUTPUT.
  CHECK wa_sdyn_book-smoker = 'X' AND smoker = 'X'.

  LOOP AT SCREEN.
    screen-intensified = 1.
    MODIFY SCREEN.
  ENDLOOP.

ENDMODULE.                 " modify_tc_line  OUTPUT
