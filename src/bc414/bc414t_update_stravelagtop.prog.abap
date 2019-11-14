*&---------------------------------------------------------------------*
*& Include BC414S_UPDATE_STRAVELAGTOP                                  *
*&---------------------------------------------------------------------*

PROGRAM  sapbc414s_update_stravelag NO STANDARD PAGE HEADING
                                    LINE-SIZE 120
                                    LINE-COUNT 10
                                    MESSAGE-ID bc414.

* Line type definition for internal table itab_travel
TYPES: BEGIN OF stravel_type.
        INCLUDE STRUCTURE stravelag.
TYPES:            mark_changed,
       END OF stravel_type.

* Standard internal table for travel agency data buffering and
* corresponding workarea
DATA: itab_stravelag LIKE STANDARD TABLE OF stravelag
      WITH NON-UNIQUE KEY agencynum,
      wa_stravelag TYPE stravelag.

* Workarea for transport of field values from/to screen 100
TABLES: stravelag.

* transport function code from screen 100
DATA: ok_code TYPE sy-ucomm, save_ok LIKE ok_code.

* Table control structure on screen 100
CONTROLS: tc_stravelag TYPE TABLEVIEW USING SCREEN '0100'.

* Internal table to collect marked list entries, corresponding workarea
DATA: itab_travel TYPE STANDARD TABLE OF stravel_type
      WITH NON-UNIQUE KEY agencynum,
      wa_travel TYPE stravel_type.

* Mark field displayed as checkbox on list
DATA: mark.

* Flags:
DATA: flag,         "changes performed on table control
      modify_list.  "modification of list buffer is neccessary

* Positions of fields on list
CONSTANTS: pos1 TYPE i VALUE   1,
           pos2 TYPE i VALUE   3,
           pos3 TYPE i VALUE  14,
           pos4 TYPE i VALUE  40,
           pos5 TYPE i VALUE  71,
           pos6 TYPE i VALUE  82,
           pos7 TYPE i VALUE 108.
