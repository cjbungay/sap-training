*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 01.12.2002 at 16:44:09 by user GOEBEL
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: SPECIALS........................................*
DATA:  BEGIN OF STATUS_SPECIALS                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_SPECIALS                      .
CONTROLS: TCTRL_SPECIALS
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: SPECIALS_ASSIGN.................................*
DATA:  BEGIN OF STATUS_SPECIALS_ASSIGN               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_SPECIALS_ASSIGN               .
CONTROLS: TCTRL_SPECIALS_ASSIGN
            TYPE TABLEVIEW USING SCREEN '0003'.
*.........table declarations:.................................*
TABLES: *SPECIALS                      .
TABLES: *SPECIALST                     .
TABLES: *SPECIALS_ASSIGN               .
TABLES: SPECIALS                       .
TABLES: SPECIALST                      .
TABLES: SPECIALS_ASSIGN                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
