REPORT SAPBC460S_04 .
TABLES: SCUSTOM.

*&---------------------------------------------------------------------*
*&      Form  GET_NAME
*&---------------------------------------------------------------------*
FORM GET_NAME TABLES INTTAB STRUCTURE ITCSY
                        OUTTAB STRUCTURE ITCSY.

* read first line of inttab
READ TABLE INTTAB INDEX 1.

* select from scustom and modify outtab with new data
SELECT SINGLE * FROM SCUSTOM
    WHERE ID = INTTAB-VALUE(8).
IF SY-SUBRC = 0.
   READ TABLE OUTTAB INDEX 1.
   MOVE SCUSTOM-NAME TO OUTTAB-VALUE.
   MODIFY OUTTAB INDEX SY-TABIX.
ELSE.
   READ TABLE OUTTAB INDEX 1.
   MOVE 'no name' TO OUTTAB-VALUE.
   MODIFY OUTTAB INDEX SY-TABIX.
ENDIF.

ENDFORM.                       " GET_NAME
