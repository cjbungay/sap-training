*&---------------------------------------------------------------------*
*& Include BC405_SSCD_F4TOP                                            *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT   SAPBC405_SSCD_F4             .

NODES: SPFLI, SFLIGHT, SBOOK.

DATA: DYNPROFIELD(30).

DATA: ID   LIKE SCUSTOM-ID,
      NAME LIKE SCUSTOM-NAME.

CONSTANTS: POS_LINSZ TYPE I VALUE 83.

SELECTION-SCREEN BEGIN OF BLOCK SCUST WITH FRAME TITLE TEXT-001.
 SELECT-OPTIONS: SCUST FOR SBOOK-CUSTOMID.
SELECTION-SCREEN END OF BLOCK SCUST.
