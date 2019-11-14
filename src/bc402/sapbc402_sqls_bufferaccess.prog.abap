*&--------------------------------------------------------*
*& Report  SAPBC402_SQLS_BUFFERACCESS                     *
*&--------------------------------------------------------*
*& Accessing the tablebuffers                             *
*& Single record / generic / full table buffer            *
*&--------------------------------------------------------*

REPORT  sapbc402_sqls_bufferaccess.


DATA: wa_t100  TYPE t100.
DATA: it_tcurr TYPE STANDARD TABLE OF tcurr.
DATA: it_t005  TYPE STANDARD TABLE OF t005.

START-OF-SELECTION.
***********************************************************

*  single record buffer access
***********************************************************
  SELECT SINGLE * FROM t100
                  INTO wa_t100
                  WHERE sprsl = 'D'
                  AND   arbgb = '00'
                  AND msgnr = '100'.

*  generic buffer access - there is one generic key field
***********************************************************
  SELECT * FROM tcurr INTO TABLE it_tcurr.

*  complete tablebuffer access
***********************************************************
  SELECT * FROM t005 INTO TABLE it_t005.
