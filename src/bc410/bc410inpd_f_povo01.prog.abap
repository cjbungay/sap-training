*----------------------------------------------------------------------*
***INCLUDE BC410D_TEMPLATE1O01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
  SET TITLEBAR 'TITLE_100'.

ENDMODULE.                             " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'STATUS_200'.
  SET TITLEBAR 'TITLE_200' WITH sdyn_conn00-carrid sdyn_conn00-connid.
ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  GET_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_data OUTPUT.
  SELECT SINGLE * INTO CORRESPONDING FIELDS OF sdyn_conn00
    FROM spfli JOIN sflight
      ON spfli~carrid = sflight~carrid
      AND spfli~connid = sflight~connid
      WHERE spfli~carrid = wa_conn-carrid
        AND spfli~connid = wa_conn-connid
        AND sflight~fldate = wa_conn-fldate.
ENDMODULE.                             " GET_DATA  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  CHECK NOT fieldname IS INITIAL..
  LOOP AT SCREEN.
    CHECK screen-name = fieldname.
    screen-input = 1.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                             " MODIFY_SCREEN  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                             " clear_ok_code  OUTPUT
