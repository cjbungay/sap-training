*----------------------------------------------------------------------*
***INCLUDE BC405SSCD_I_F4O01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR '100'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  LISTE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE LISTE OUTPUT.
* PBO-Module for dynpro 100, display of possible entries
  SUPPRESS DIALOG.
  LEAVE TO LIST-PROCESSING AND RETURN TO SCREEN 0.
  NEW-PAGE NO-TITLE NO-HEADING.                  "suppress report header
  SELECT ID NAME FROM SCUSTOM INTO (ID, NAME).
    WRITE: / ID, NAME.
    HIDE ID.
  ENDSELECT.
ENDMODULE.                 " LISTE  OUTPUT
