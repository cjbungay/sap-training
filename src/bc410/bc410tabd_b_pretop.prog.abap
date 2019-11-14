*&---------------------------------------------------------------------*
*& Include BC410LISD_LIST_ON_DYNPROTOP                                 *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  BC410LISD_LIST_ON_DYNPROTOP           .

DATA: ok_code LIKE sy-ucomm.

DATA: wa_spfli TYPE spfli.
TABLES sdyn_conn.
