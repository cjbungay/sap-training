*----------------------------------------------------------------------*
*& Include BC425_TAVARO01
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set status and titlebar for screen 100
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS '0100_MAIN'.
  SET TITLEBAR  '0100'.

ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0210  OUTPUT
*&---------------------------------------------------------------------*
*       Set status and titlebar for screen 210
*----------------------------------------------------------------------*
MODULE status_0210 OUTPUT.

  SET PF-STATUS '0210_MAIN'.
  SET TITLEBAR  '0210'.

ENDMODULE.                             " STATUS_0210  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  ITAB_TO_STEPLOOP  OUTPUT
*&---------------------------------------------------------------------*
*       Fill one step-loop line from internal table
*----------------------------------------------------------------------*
MODULE itab_to_steploop OUTPUT.

  line_itab = line_first + sy-stepl - 1.

  READ TABLE itab INDEX line_itab INTO wa.
  IF sy-subrc <> 0.
    EXIT FROM STEP-LOOP.
  ELSE.
    MOVE-CORRESPONDING wa TO sdyn_conn.
  ENDIF.

ENDMODULE.                             " ITAB_TO_STEPLOOP  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.

  SET PF-STATUS '0200_MAIN'.
  SET TITLEBAR '0200'.

ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  ITAB_TO_TABLECONTROL  OUTPUT
*&---------------------------------------------------------------------*
*       Fill one TableControl line from internal table
*----------------------------------------------------------------------*
MODULE itab_to_tablecontrol OUTPUT.

  MOVE-CORRESPONDING wa TO sdyn_conn.

ENDMODULE.                             " ITAB_TO_TABLECONTROL  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
*       Set status and titlebar for screen 300
*----------------------------------------------------------------------*
MODULE status_0300 OUTPUT.

  SET PF-STATUS '0300_MAIN'.
  SET TITLEBAR '0300'.

ENDMODULE.                             " STATUS_0300  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  PRESET_CITIES  OUTPUT
*&---------------------------------------------------------------------*
*       Set default values for cities
*       Set list of cities to ITS
*----------------------------------------------------------------------*
MODULE preset_cities OUTPUT.

  IF cities_initial = checked.
    CLEAR cities_initial.
    sdyn_conn-countryfr = 'DE'.        "#EC NOTEXT
    sdyn_conn-cityfrom  = 'WALLDORF'.  "#EC NOTEXT
    sdyn_conn-countryto = 'US'.        "#EC NOTEXT
    sdyn_conn-cityto    = 'NEW YORK'.  "#EC NOTEXT
  ENDIF.

  PERFORM send_cities_to_its.

ENDMODULE.                             " PRESET_CITIES  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  RESET_LINE_ITAB  OUTPUT
*&---------------------------------------------------------------------*
*       Initialize line selector
*----------------------------------------------------------------------*
MODULE reset_line_itab OUTPUT.

  CLEAR line_itab.

ENDMODULE.                             " RESET_LINE_ITAB  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0400  OUTPUT
*&---------------------------------------------------------------------*
*       Set status and titlebar for screen 400
*----------------------------------------------------------------------*
MODULE status_0400 OUTPUT.

  SET PF-STATUS '0400_MAIN'.
  SET TITLEBAR '0400'.

ENDMODULE.                             " STATUS_0400  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  CLEAR_PASSWORD  OUTPUT
*&---------------------------------------------------------------------*
*       Initialize password
*----------------------------------------------------------------------*
MODULE clear_password OUTPUT.

  CLEAR password.

ENDMODULE.                             " CLEAR_PASSWORD  OUTPUT
