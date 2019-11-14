*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 15.10.1999 at 16:49:07 by user LECHNERI
*---------------------------------------------------------------------*
*...processing: SPARTNER........................................*
TABLES: SPARTNER, *SPARTNER. "view work areas
CONTROLS: TCTRL_SPARTNER
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_SPARTNER. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_SPARTNER.
* Table for entries selected to show on screen
DATA: BEGIN OF SPARTNER_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE SPARTNER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF SPARTNER_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF SPARTNER_TOTAL OCCURS 0010.
INCLUDE STRUCTURE SPARTNER.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF SPARTNER_TOTAL.

*.........table declarations:.................................*
TABLES: SBUSPART                       .
TABLES: STRAVELAG                      .
