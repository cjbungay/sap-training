*----------------------------------------------------------------------*
***INCLUDE BC425_BOOKING_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DATA_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data_output.

* First Exit: Position vertical line
  CALL METHOD exit_book->change_vline
           CHANGING
               c_pos = pos.

  ULINE AT /(pos).

  SORT itab_book BY carrid connid fldate.

* Display list using group levels
  LOOP AT itab_book INTO wa_book.

    AT NEW connid.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.
      WRITE: /         sy-vline,
                       wa_book-carrid,
                       wa_book-connid,
                AT pos sy-vline.
    ENDAT.

    AT NEW fldate.
      FORMAT COLOR COL_HEADING INTENSIFIED OFF.
      WRITE: /        sy-vline,
                      wa_book-fldate,
               AT pos sy-vline.
    ENDAT.

    FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

    WRITE: /    sy-vline,
                wa_book-bookid,
             13 wa_book-order_date,
             25 wa_book-customid.

* Second Exit: Possibility to display additional fields
    CALL METHOD exit_book->output
             EXPORTING
                 i_booking = wa_book.

    WRITE AT pos sy-vline.

  ENDLOOP.
  ULINE AT /(pos).

ENDFORM.                               " DATA_OUTPUT

