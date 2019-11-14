*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 19.11.1997 at 16:15:35 by user SCHREPPM
*---------------------------------------------------------------------*
*...processing: SBUSPARTS.......................................*
TABLES: SBUSPARTS, *SBUSPARTS. "view work areas
CONTROLS: TCTRL_SBUSPARTS
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_SBUSPARTS. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_SBUSPARTS.
* Table for entries selected to show on screen
DATA: BEGIN OF SBUSPARTS_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE SBUSPARTS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF SBUSPARTS_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF SBUSPARTS_TOTAL OCCURS 0010.
INCLUDE STRUCTURE SBUSPARTS.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF SBUSPARTS_TOTAL.

*.........table declarations:.................................*
TABLES: SBUSPART                       .
TABLES: STRAVELAG                      .
