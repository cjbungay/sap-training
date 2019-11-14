*----------------------------------------------------------------------*
***INCLUDE BC414S_BOOKINGS_05O01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN_100'.
  SET TITLEBAR 'DYN_100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS 'DYN_200'.
  SET TITLEBAR 'DYN_200' WITH sdyn_conn-carrid sdyn_conn-connid
                              sdyn_conn-fldate.
ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0300  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS 'DYN_300'.
  SET TITLEBAR 'DYN_300' WITH sdyn_conn-carrid sdyn_conn-connid
                              sdyn_conn-fldate.
ENDMODULE.                             " STATUS_0300  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_DETAILS  OUTPUT
*&---------------------------------------------------------------------*
MODULE trans_details OUTPUT.
  MOVE-CORRESPONDING: wa_spfli   TO sdyn_conn,
                      wa_sflight TO sdyn_conn,
                      wa_sbook   TO sdyn_book.
ENDMODULE.                             " TRANS_DETAILS  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_TC  OUTPUT
*&---------------------------------------------------------------------*
MODULE trans_to_tc OUTPUT.
  MOVE-CORRESPONDING wa_book TO sdyn_book.
ENDMODULE.                             " TRANS_TO_TC  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  LOOP AT SCREEN.
    CHECK screen-name = 'SDYN_BOOK-CANCELLED'.
    CHECK ( NOT sdyn_book-cancelled IS INITIAL ) AND
          ( sdyn_book-mark IS INITIAL ).
    screen-input = 0.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                             " MODIFY_SCREEN  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TABSTRIP_INIT  OUTPUT
*&---------------------------------------------------------------------*
MODULE tabstrip_init OUTPUT.
  CHECK tab-activetab IS INITIAL.
  tab-activetab = 'BOOK'.
  screen_no = '0301'.
ENDMODULE.                             " TABSTRIP_INIT  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  HIDE_BOOKID  OUTPUT
*&---------------------------------------------------------------------*
MODULE hide_bookid OUTPUT.
* hide field displaying customer number when working with number range
* object BS_SCUSTOM
  LOOP AT SCREEN.
    CHECK screen-name = 'SDYN_BOOK-BOOKID'.
    screen-active = 0.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.                             " HIDE_BOOKID  OUTPUT
