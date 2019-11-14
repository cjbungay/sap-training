REPORT BC430_DATA_COPY.

DATA: ERRORS TYPE BC430_ERROR OCCURS 20 WITH HEADER LINE.

***********************************************************************
* Selection-Screen                                                    *
***********************************************************************

SELECTION-SCREEN COMMENT /2(80) TEXT-001.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK BL1
                          WITH FRAME TITLE TEXT-002.

PARAMETERS: QUELLTAB TYPE TABNAME DEFAULT 'SCARGO',
            ZIELTAB TYPE TABNAME.

SELECTION-SCREEN END OF BLOCK BL1.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN COMMENT /2(80) TEXT-003.
SELECTION-SCREEN COMMENT /2(80) TEXT-004.

***********************************************************************
* Main Program                                                        *
***********************************************************************

* Aufruf des FUBA zum Strukturvergleich
CALL FUNCTION 'BC430_COMP_AND_FILL'
     EXPORTING
          T_TAB               = ZIELTAB
          M_TAB               = QUELLTAB
          FILL                = 'Y'
     TABLES
          ERRORS              = ERRORS
     EXCEPTIONS
          T_TAB_NOT_EXIST     = 1
          T_TAB_NOT_ACTIVE    = 2
          M_TAB_NOT_ACTIVE    = 3
          SYSTEM_INCONSISTENT = 4
          OTHERS              = 5.

IF SY-SUBRC <> 0.
  MESSAGE ID 'BC430' TYPE 'I' NUMBER '002'.
ELSE.
  MESSAGE ID 'BC430' TYPE 'I' NUMBER '003'.
ENDIF.


