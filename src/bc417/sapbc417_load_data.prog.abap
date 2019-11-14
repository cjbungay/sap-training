*&---------------------------------------------------------------------*
*& Report  SAPBC417_LOAD_DATA                                          *
*&                                                                     *
*& This is a setup program for BC417. It copies data from table KNA1   *
*& to SKNA1 and from table KNVK to SKNVK.                              *
*&---------------------------------------------------------------------*

REPORT  SAPBC417_LOAD_DATA.
TABLES: KNA1, SKNA1, KNVK, SKNVK.
DATA: IKNA1 LIKE KNA1 OCCURS 0 WITH HEADER LINE,
      IKNVK LIKE KNVK OCCURS 0 WITH HEADER LINE.

* Load the customer master table
SELECT * FROM KNA1 INTO TABLE IKNA1.
INSERT SKNA1 FROM TABLE IKNA1.
IF SY-SUBRC NE 0.
WRITE: 'Insert line failure during customer master load'.
ENDIF.
WRITE: / 'Finished inserting', SY-DBCNT, 'lines into SKNA1'.

* Load the customer contact table
SELECT * FROM KNVK INTO TABLE IKNVK.
INSERT SKNVK FROM TABLE IKNVK.
IF SY-SUBRC NE 0.
WRITE: 'Insert line failure during customer contact load'.
ENDIF.
WRITE: / 'Finished inserting', SY-DBCNT, 'lines into SKNVK'.
