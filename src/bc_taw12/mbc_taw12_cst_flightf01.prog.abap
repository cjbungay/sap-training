*----------------------------------------------------------------------*
***INCLUDE  MBC410TABS_TABLE_CONTROL3F01
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  READ_BOOKINGS
*&---------------------------------------------------------------------*
*       selects booking data of the given flight
*----------------------------------------------------------------------*
*      -->p_carrid flight carrier
*      -->p_connid connection id
*      -->p_fldate flight date
*      -->p_cancelled cancelled = 'X' / not cancelled = ' '
*      <--p_it_sbook table of the corresponding bookings
*----------------------------------------------------------------------*
FORM read_bookings USING    p_carrid    TYPE sbook-carrid
                            p_connid    TYPE sbook-connid
                            p_fldate    TYPE  sbook-fldate
                            p_cancelled TYPE sbook-cancelled
                   CHANGING p_it_sbook LIKE it_sbook.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE p_it_sbook FROM sbook
    WHERE carrid = p_carrid
      AND connid = p_connid
      AND fldate = p_fldate
      AND cancelled = p_cancelled.

ENDFORM.                               " READ_BOOKINGS
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_BOOKINGS
*&---------------------------------------------------------------------*
*       displays all bookings from table it_sbook
*       new page for every new flight
*----------------------------------------------------------------------*
FORM display_bookings.

  LOOP AT it_sbook INTO wa_sbook.

    WRITE: / wa_sbook-bookid,
             wa_sbook-customid,
             wa_sbook-custtype,
             wa_sbook-luggweight UNIT wa_sbook-wunit,
             wa_sbook-wunit,
             wa_sbook-class,
             wa_sbook-order_date,
             wa_sbook-cancelled.
    HIDE : wa_sbook-bookid.
  ENDLOOP.
  CLEAR : wa_sbook-bookid.
ENDFORM.                               " DISPLAY_BOOKINGS
*&---------------------------------------------------------------------*
*&      Form  update_sflight
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM update_sflight.
  UPDATE sflight FROM wa_sflight.
  IF sy-subrc NE 0.
    MESSAGE a008.
*   Fehler beim Ändern
  ENDIF.
  MESSAGE s009.
*   Ändern erfolgreich durchgeführt
ENDFORM.                               " update_sflight
*&---------------------------------------------------------------------*
*&      Form  cancel_bookings
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM cancel_bookings.
  DATA: wa_sbook_upd TYPE sbook,
        it_sbook_upd LIKE TABLE OF wa_sbook_upd.
  CONSTANTS cancelled VALUE 'X'.

  LOOP AT it_sdyn_book INTO wa_sdyn_book WHERE mark = 'X'.
    MOVE-CORRESPONDING wa_sdyn_book TO wa_sbook_upd.
    MOVE cancelled TO wa_sbook_upd-cancelled.
    APPEND wa_sbook_upd TO it_sbook_upd.
  ENDLOOP.

  CALL FUNCTION 'BC_GLOBAL_UPDATE_BOOK'
       TABLES
            booking_tab     = it_sdyn_book
            booking_tab_upd = it_sbook_upd.

* No exception no return code

    MESSAGE s009.
*   Ändern erfolgreich durchgeführt
    bookings_changed = 'X'.

ENDFORM.                               " cancel_bookings
