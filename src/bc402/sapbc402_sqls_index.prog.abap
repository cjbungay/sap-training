*&---------------------------------------------------------------------*
*& Report  SAPBC402_SQLS_INDEX                                         *
*&---------------------------------------------------------------------*
*& Read data using secondary index (if index exists!)                  *
*& Index should be creeated on : MANDT / CUSTOMID                      *
*&---------------------------------------------------------------------*
REPORT SAPBC402_SQLS_INDEX.

* Data Declaration
DATA: 	wa TYPE sbook,
       itab TYPE STANDARD TABLE OF bc402_sbook.

PARAMETERS: par TYPE bc402_sbook-customid default '00000022'.

* Data selection
SELECT carrid connid fldate bookid customid
   FROM bc402_sbook
   INTO CORRESPONDING FIELDS OF TABLE itab
    WHERE customid = par.

* Data Output
FORMAT COLOR COL_NORMAL.
LOOP AT itab INTO wa.
  ULINE.
  WRITE:  wa-carrid, wa-connid, wa-fldate, wa-bookid, wa-customid.
ENDLOOP.
