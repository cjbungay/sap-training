*&---------------------------------------------------------------------*
*& Include BC405_SSCD_PBOTOP                                           *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT   SAPBC405_SSCD_PBO .

INCLUDE <ICON>.
NODES: SPFLI, SFLIGHT, SBOOK.                      " logical database
TABLES SSCRFIELDS.                                 " Push button
DATA: SAVE_OK_CODE LIKE SY-UCOMM VALUE 'COMPRESS'.

* Push buttons at the selection screen
SELECTION-SCREEN PUSHBUTTON  POS_LOW(20) E_BUTTON USER-COMMAND EXP.
SELECTION-SCREEN PUSHBUTTON /POS_LOW(20) C_BUTTON USER-COMMAND COM.
