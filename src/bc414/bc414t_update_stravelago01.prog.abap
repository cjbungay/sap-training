*----------------------------------------------------------------------*
***INCLUDE BC414S_UPDATE_STRAVELAGO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYNPRO'.
  SET TITLEBAR 'DYNPRO'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_DYNPRO  OUTPUT
*&---------------------------------------------------------------------*
MODULE trans_to_dynpro OUTPUT.
* Field transport to screen
  MOVE-CORRESPONDING wa_travel TO stravelag.
ENDMODULE.                             " TRANS_TO_DYNPRO  OUTPUT
