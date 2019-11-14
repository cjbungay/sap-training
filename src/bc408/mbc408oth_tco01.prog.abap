*----------------------------------------------------------------------*
***INCLUDE MBC408OTH_TCO01
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF my_tabstrip-activetab = 'FC3'.
    SET PF-STATUS 'STATUS_100_PAGING'.
  ELSE.
    SET PF-STATUS 'STATUS_100'.
  ENDIF.
  CASE 'X'.
    WHEN mode-view.
      SET TITLEBAR 'TITLE_100' WITH 'Display'(ti1). "#EC *
    WHEN mode-maintain_flights.
      SET TITLEBAR 'TITLE_100' WITH 'Maintain Flights'(ti2). "#EC *
    WHEN mode-maintain_bookings.
      SET TITLEBAR 'TITLE_100' WITH 'Maintain Bookings'(ti3). "#EC *
  ENDCASE.
ENDMODULE.                             " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                             " clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  get_sflight_date  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_sflight_date OUTPUT.
  MOVE-CORRESPONDING wa_sflight TO sdyn_conn.
ENDMODULE.                             " get_sflight_date  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  modify_screen  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  CHECK NOT mode-maintain_flights IS INITIAL.
  LOOP AT SCREEN.
    IF screen-group1 = 'ADM'.
      screen-input = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.                             " modify_screen  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  GET_SPFLI  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_spfli OUTPUT.
  ON CHANGE OF wa_sflight-carrid OR wa_sflight-connid.
    SELECT SINGLE * INTO CORRESPONDING FIELDS OF sdyn_conn FROM spfli
      WHERE carrid = wa_sflight-carrid
        AND connid = wa_sflight-connid.
  ENDON.
ENDMODULE.                             " GET_SPFLI  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  GET_SAPLANE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_saplane OUTPUT.
  ON CHANGE OF wa_sflight-planetype.
    SELECT SINGLE * FROM saplane WHERE planetype = wa_sflight-planetype.
  ENDON.
ENDMODULE.                             " GET_SAPLANE  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  set_dynnr  OUTPUT
*&---------------------------------------------------------------------*
*       text
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
ENDMODULE.                             " set_dynnr  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  get_sbook  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_sbook OUTPUT.
  IF wa_sflight-carrid <> key_sflight-carrid OR
     wa_sflight-connid <> key_sflight-connid OR
     wa_sflight-fldate <> key_sflight-fldate OR
     bookings_changed = 'X'.
    CLEAR bookings_changed.
    MOVE-CORRESPONDING wa_sflight TO key_sflight.

    SELECT * FROM sbook INTO CORRESPONDING FIELDS OF TABLE it_sdyn_book
         WHERE carrid = wa_sflight-carrid
           AND connid = wa_sflight-connid
           AND fldate = wa_sflight-fldate
           AND cancelled = not_cancelled.

    DESCRIBE TABLE it_sdyn_book LINES my_table_control-lines.
  ENDIF.
ENDMODULE.                             " get_sbook  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  trans_to_dynp  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_to_tc OUTPUT.
  MOVE wa_sdyn_book TO sdyn_book.
ENDMODULE.                             " trans_to_dynp  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  modify_screen_130  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen_130 OUTPUT.
  CHECK NOT mode-maintain_bookings IS INITIAL.
  LOOP AT SCREEN.
    IF screen-name = 'P_DELETE'.
      screen-invisible = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDMODULE.                             " modify_screen_130  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  get_looplines  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_looplines OUTPUT.
  ON CHANGE OF sy-loopc.
    loopc = sy-loopc.
  ENDON.
ENDMODULE.                             " get_looplines  OUTPUT
