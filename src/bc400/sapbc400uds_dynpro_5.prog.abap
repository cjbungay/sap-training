*&---------------------------------------------------------------------*
*& Report  SAPBC400UDS_DYNPRO_5                                        *
*&---------------------------------------------------------------------*

REPORT  sapbc400uds_dynpro_5 .

CONSTANTS: actvt_display TYPE activ_auth VALUE '03',
           actvt_change TYPE activ_auth VALUE '02'.

PARAMETERS pa_anum TYPE sbook-agencynum.

* workarea for SELECT
DATA wa_sbook TYPE sbook.

* workarea for data communication with screen
TABLES sdyn_book.

* variable for function code of user action
DATA ok_code LIKE sy-ucomm.

* flag for answer from standard popup
DATA answer(1) TYPE c.



START-OF-SELECTION.

  SET TITLEBAR 'LIST'.
  SET PF-STATUS 'LIST'.

  SELECT carrid connid fldate bookid
         FROM sbook
         INTO CORRESPONDING FIELDS OF wa_sbook
           WHERE agencynum = pa_anum.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
        ID 'CARRID' FIELD wa_sbook-carrid
        ID 'ACTVT'  FIELD actvt_display.

    IF sy-subrc = 0.
      WRITE: / wa_sbook-carrid COLOR col_key,
               wa_sbook-connid COLOR col_key,
               wa_sbook-fldate COLOR col_key,
               wa_sbook-bookid COLOR col_key.
      HIDE: wa_sbook-carrid,
            wa_sbook-connid,
            wa_sbook-fldate,
            wa_sbook-bookid.
    ENDIF.

  ENDSELECT.

  CLEAR wa_sbook.



AT LINE-SELECTION.

  AUTHORITY-CHECK OBJECT 'S_CARRID'
       ID 'CARRID' FIELD wa_sbook-carrid
       ID 'ACTVT'  FIELD actvt_change.

  IF sy-subrc = 0.

    SELECT SINGLE * FROM sbook INTO wa_sbook
       WHERE carrid = wa_sbook-carrid
        AND  connid = wa_sbook-connid
        AND  fldate = wa_sbook-fldate
        AND  bookid = wa_sbook-bookid.

    IF sy-subrc = 0.
      MOVE-CORRESPONDING wa_sbook TO sdyn_book.
      CALL SCREEN 100.
    ELSE.
      MESSAGE s176(bc400).
    ENDIF.

  ELSE .
    MESSAGE s047(bc400) WITH wa_sbook-carrid.
  ENDIF.

  CLEAR wa_sbook.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT                                    *
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET TITLEBAR 'DYNPRO'.
  SET PF-STATUS 'DYNPRO'.
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
      SET SCREEN 0.

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

ENDMODULE.                  " USER_COMMAND_0100  INPUT
