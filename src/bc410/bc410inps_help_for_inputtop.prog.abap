*----------------------------------------------------------------------*
*   INCLUDE BC410INPS_HELP_FOR_INPUTTOP                                *
*----------------------------------------------------------------------*
PROGRAM sapbc410inps_help_for_input.

* workarea and internal table for flights
DATA: mark,
      wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight.

* workarea and internal tables for bookings
DATA: wa_sbook TYPE sbook,
      it_sbook_read LIKE TABLE OF wa_sbook,
      it_sbook LIKE TABLE OF wa_sbook.

* sflight key for testing changes
DATA: BEGIN OF key_sflight,
        carrid LIKE wa_sflight-carrid,
        connid LIKE wa_sflight-connid,
        fldate LIKE wa_sflight-fldate,
      END OF key_sflight.
* field name for GET CURSOR
DATA  fieldname(50).

* fields for ok_code processing
DATA: ok_code LIKE sy-ucomm,
      save_ok LIKE ok_code.

* structures for dynpro processing
TABLES  sdyn_conn.

* selection screen for choosing connections
SELECTION-SCREEN BEGIN OF BLOCK conn WITH FRAME TITLE text-001.
SELECT-OPTIONS: so_car FOR wa_sflight-carrid,
                so_con FOR wa_sflight-connid.
SELECTION-SCREEN END OF BLOCK conn.
