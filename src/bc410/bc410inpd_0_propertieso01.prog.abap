*----------------------------------------------------------------------*
***INCLUDE BC410INPD_0_PROPERTIESO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYNPRO'.
  SET TITLEBAR 'T_DYNPRO'.

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
*&      Module  init  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init OUTPUT.
  CHECK initialised IS INITIAL.
  initialised = 'X'.
  sdyn_conn-cityfrom = 'Frankfurt'.
  LOOP AT SCREEN.
    CHECK screen-name = 'SDYN_CONN-CITYFROM'.
    new_screen = screen.
  ENDLOOP.
ENDMODULE.                             " init  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  modify_screen  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  LOOP AT SCREEN.
    CHECK screen-name = 'SDYN_CONN-CITYFROM'.
    screen = new_screen.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                             " modify_screen  OUTPUT
