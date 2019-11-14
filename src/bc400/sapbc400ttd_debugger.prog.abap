*&---------------------------------------------------------------------*
*& Report  SAPBC400TTD_DEBUGGER                                        *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  Test the Debugger                                                  *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc400ttd_debugger .

DATA: diff TYPE p,
      date LIKE sy-datum,
      BEGIN OF daterec,
        year(4)  TYPE c,
        month(2) TYPE c,
        day(2)   TYPE c,
      END OF daterec.

daterec = sy-datum.

* Begin of month
daterec-day = '01'.

date = daterec.

* Last day of premonth
date = date - 1.

diff = sy-datum - date.

WRITE: / 'DATE    ', 15 date,
       / 'SY-DATUM', 15 sy-datum,
       / 'DIFF    ',    diff.
