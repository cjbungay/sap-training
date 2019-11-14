*&---------------------------------------------------------------------*
*& Include BC414S_BOOKINGS_06TOP                                       *
*&---------------------------------------------------------------------*

PROGRAM  sapbc414s_bookings_06 MESSAGE-ID bc414.

* change documents: data definitions
INCLUDE fbc414_cdocscdt.

* line type of internal table itab_book, used to display bookings in
* table control
TYPES: BEGIN OF wa_book_type.
INCLUDE: STRUCTURE sbook.
TYPES:   name TYPE scustom-name,
         mark,
       END OF wa_book_type.

* work area and internal table used to display bookings in table control
DATA: wa_book TYPE wa_book_type,
      itab_book TYPE TABLE OF wa_book_type.
* bookings to be modified on database table
DATA: itab_sbook_modify TYPE TABLE OF sbook,
* change documents: bookings before changes are performed
      itab_cd TYPE TABLE OF sbook WITH NON-UNIQUE KEY
      carrid connid fldate bookid customid.

* work areas for database tables spfli, sflight, sbook.
DATA: wa_sbook TYPE sbook, wa_sflight TYPE sflight, wa_spfli TYPE spfli.

* complex transactions: number of the customer created in the called
* transaction
DATA: scust_id(20).

* transport function codes from screens
DATA: ok_code TYPE sy-ucomm, save_ok LIKE ok_code.
* define subscreen screen number on tabstrip, screen 300
DATA: screen_no TYPE sy-dynnr.
* used to handle sy-subrc, which is determined in form
DATA  sysubrc LIKE sy-subrc.

* transporting fields to/from screen
TABLES: sdyn_conn, sdyn_book.
* table control declaration (display bookings),
* tabstrip declaration (create booking)
CONTROLS: tc_sbook TYPE TABLEVIEW USING SCREEN '0200',
          tab TYPE TABSTRIP.


DATA:
 pb_specials(20)    TYPE c,
 gr_badi_reference  TYPE REF TO IF_EX_TAW12_00,
 gv_dynnr           TYPE sydynnr,
 gv_program         TYPE syrepid.
