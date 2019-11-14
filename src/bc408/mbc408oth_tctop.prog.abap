*&---------------------------------------------------------------------*
*& Include MBC408OTH_TCTOP
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapmMBC408OTH_TC MESSAGE-ID bc410         .
* Counter for table control lines
DATA  loopc LIKE sy-loopc.

* flag to mark changed booking data
DATA  bookings_changed.

* Structures for table control
CONTROLS my_table_control TYPE TABLEVIEW USING SCREEN 130.
TABLES sdyn_book.

* Working area for column description in table controls
DATA  wa_cols LIKE LINE OF my_table_control-cols.

* Internal table for table control
DATA: wa_sdyn_book TYPE sdyn_book,
      it_sdyn_book LIKE TABLE OF wa_sdyn_book.

* Structure for tabstrip control
CONTROLS my_tabstrip TYPE TABSTRIP.

* Dynpro number for subscreen
DATA  dynnr LIKE sy-dynnr.                                  "#EC NEEDED

* Dynpro structure for planes
TABLES saplane.

* Dynpro structure for flights
TABLES sdyn_conn.

* Structure for radiobutton group

DATA: BEGIN OF mode,
        view VALUE 'X',                "selected
        maintain_flights,
        maintain_bookings,
      END OF mode.

* command field for dynpros
DATA ok_code LIKE sy-ucomm.

* workarea and internal table for flights
DATA wa_sflight TYPE sflight.

* workarea and internal table for bookings
DATA: wa_sbook TYPE sbook,
      it_sbook LIKE TABLE OF wa_sbook.

* constant for form interface
CONSTANTS not_cancelled VALUE space.

* sflight key for testing changes
DATA: BEGIN OF key_sflight,
        carrid LIKE wa_sflight-carrid,
        connid LIKE wa_sflight-connid,
        fldate LIKE wa_sflight-fldate,
      END OF key_sflight.

* field name for GET CURSOR
DATA  fieldname(50).
