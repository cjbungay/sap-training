*----------------------------------------------------------------------*
***INCLUDE BC414S_CREATE_FLIGHTO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'DYN_100' EXCLUDING 'SAVE'.
  SET TITLEBAR 'DYN_100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
  SET PF-STATUS 'DYN_100' EXCLUDING 'DETS'.
  SET TITLEBAR 'DYN_100'.
ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  INIT  OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT OUTPUT.
  CLEAR: SDYN_CONN, MARK_CHANGED.
ENDMODULE.                             " INIT  OUTPUT
