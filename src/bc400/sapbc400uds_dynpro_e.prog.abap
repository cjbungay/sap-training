*&---------------------------------------------------------------------*
*& Report  SAPBC400UDS_DYNPRO_E                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400uds_dynpro_e MESSAGE-ID bc400.

CONSTANTS: actvt_display TYPE activ_auth VALUE '03',
           actvt_change TYPE activ_auth VALUE '02'.

PARAMETERS pa_anum TYPE sbook-agencynum.

DATA wa_booking TYPE sbc400_booking.

DATA wa_sbook TYPE sbook.

TABLES sdyn_book.

DATA: ok_code LIKE sy-ucomm.

* flag for answer from standard popup
DATA  answer(1) TYPE c.


START-OF-SELECTION.

  SET PF-STATUS 'LIST'.
  SET TITLEBAR 'LIST'.

* selecting data using a dictionary view to get the data from sbook and
* the customer name from scustom
  SELECT carrid connid fldate bookid customid name
         FROM sbc400_booking
         INTO CORRESPONDING FIELDS OF wa_booking
           WHERE agencynum = pa_anum.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
        ID 'CARRID' FIELD wa_booking-carrid
        ID 'ACTVT'  FIELD actvt_display.
    IF sy-subrc = 0.
* Output
      WRITE: / wa_booking-carrid COLOR COL_KEY,
               wa_booking-connid COLOR COL_KEY,
               wa_booking-fldate COLOR COL_KEY,
               wa_booking-bookid COLOR COL_KEY,
               wa_booking-name.

      HIDE:    wa_booking-carrid,
               wa_booking-connid,
               wa_booking-fldate,
               wa_booking-bookid,
               wa_booking-name.

    ENDIF.
  ENDSELECT.
  CLEAR wa_booking.


AT LINE-SELECTION.

  AUTHORITY-CHECK OBJECT 'S_CARRID'
       ID 'CARRID' FIELD wa_booking-carrid
        ID 'ACTVT'  FIELD actvt_change.
  IF sy-subrc = 0.

    SELECT SINGLE *
           FROM sbook
           INTO wa_sbook
           WHERE carrid = wa_booking-carrid
             AND connid = wa_booking-connid
             AND fldate = wa_booking-fldate
             AND bookid  = wa_booking-bookid.
    IF sy-subrc = 0.
      MOVE-CORRESPONDING wa_sbook TO sdyn_book.
      MOVE wa_booking-name TO sdyn_book-name.
      CALL SCREEN 100.
    ENDIF.
  ELSE .
    MESSAGE ID 'BC400' TYPE 'S' NUMBER '047' WITH wa_booking-carrid.
  ENDIF.

  CLEAR: wa_sbook, wa_booking.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT                                    *
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYNPRO'.
  SET TITLEBAR 'DYNPRO'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  CLEAR_OK_CODE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " CLEAR_OK_CODE  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT                               *
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'RW'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = text-002
          text_question         = text-001
          display_cancel_button = space
        IMPORTING
          answer                = answer.
      CASE answer.
        WHEN '1'.
          LEAVE TO SCREEN 0.
        WHEN '2'.
          LEAVE TO SCREEN 100.
      ENDCASE.

    WHEN 'SAVE'.
      MOVE-CORRESPONDING sdyn_book TO wa_sbook.
      CALL FUNCTION 'BC400_UPDATE_BOOK'
        EXPORTING
          iv_book                   = wa_sbook
        EXCEPTIONS
          book_not_found            = 1
          update_sbook_rejected     = 2
          book_locked               = 3
          currency_conversion_error = 4
          OTHERS                    = 5.
      IF sy-subrc = 0.
        MESSAGE s148(bc400).
        SET SCREEN 0.
      ELSE.
        MESSAGE e149(bc400).
      ENDIF.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0100  INPUT
