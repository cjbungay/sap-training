*&---------------------------------------------------------------------*
*& Report SAPBC402_SQLD_COPY_SBOOK                                     *
*&                                                                     *
*& Duplicate The content of original table SBOOK                       *
*&
*&---------------------------------------------------------------------*

REPORT sapbc402_sqld_copy_sbook.

SELECTION-SCREEN BEGIN OF BLOCK control WITH FRAME.
PARAMETERS: tab(20) DEFAULT 'Z##SBOOK'.
SELECTION-SCREEN END OF BLOCK control.

DATA: wa_dd02l TYPE dd02l.
DATA: itab TYPE STANDARD TABLE OF sbook.

SELECT SINGLE * FROM  dd02l INTO wa_dd02l
       WHERE  tabname  = tab.
IF sy-subrc <> 0.
  MESSAGE e002(00).
*   wrong table, please input correct value !
 endif.

SELECT * FROM sbook INTO TABLE itab
              WHERE carrid = 'LH'.

* Filling the table
INSERT (tab) FROM TABLE itab.
WRITE: /,'INSERT RETURNCODE = ', sy-subrc.
