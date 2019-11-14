*&---------------------------------------------------------------------*
*& Include BC410LISD_LIST_ON_DYNPROTOP                                 *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  BC410LISD_LIST_ON_DYNPROTOP           .

DATA: ok_code LIKE sy-ucomm.

DATA: wa_spfli TYPE spfli.
TABLES sdyn_conn.

DATA:  begin of WA_SFLIGHT.
       include structure sflight.
data:  mark,
       end of wa_sflight,
       it_sflight like table of wa_sflight.


controls my_table_control type tableview using screen '0200'.
