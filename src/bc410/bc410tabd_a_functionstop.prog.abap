*&---------------------------------------------------------------------*
*& Include BC410LISD_LIST_ON_DYNPROTOP                                 *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  bc410lisd_list_on_dynprotop           .

DATA: ok_code LIKE sy-ucomm.

DATA: wa_spfli TYPE spfli.
TABLES sdyn_conn.

DATA:  BEGIN OF wa_sflight.
        INCLUDE STRUCTURE sflight.
DATA:  mark,
       END OF wa_sflight,
       it_sflight LIKE TABLE OF wa_sflight.


CONTROLS my_table_control TYPE TABLEVIEW USING SCREEN '0200'.

DATA wa_cols LIKE LINE OF my_table_control-cols.

DATA:  wa_sbook TYPE sbook,
       it_sbook LIKE TABLE OF wa_sbook.
