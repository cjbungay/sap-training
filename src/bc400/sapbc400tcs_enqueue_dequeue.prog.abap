*&---------------------------------------------------------------------*
*& Report  SAPBC400TCS_ENQUEUE_DEQUEUE                                 *
*&---------------------------------------------------------------------*

REPORT  sapbc400tcs_enqueue_dequeue  MESSAGE-ID bc400.

PARAMETERS pa_anum TYPE sbook-agencynum.

CONSTANTS: actvt_display TYPE activ_auth VALUE '03',
           actvt_change TYPE activ_auth VALUE '02'.

* workarea for list
DATA wa_booking TYPE sbc400_booking.

* workarea for single booking to be changed
DATA wa_sbook TYPE sbook.

* workarea for screen
TABLES sdyn_book.

* variable for function code
DATA ok_code LIKE sy-ucomm.



START-OF-SELECTION.

  SET PF-STATUS 'LIST'.

* selecting data from sbook and scustom using a dictionary view
  SELECT carrid connid fldate bookid customid name
         FROM sbc400_booking
         INTO CORRESPONDING FIELDS OF wa_booking
         WHERE agencynum = pa_anum.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
        ID 'CARRID' FIELD wa_booking-carrid
        ID 'ACTVT'  FIELD actvt_display.

    IF sy-subrc = 0.
      WRITE: / wa_booking-carrid,
               wa_booking-connid,
               wa_booking-fldate,
               wa_booking-bookid,
               wa_booking-name.
      HIDE: wa_booking-carrid,
            wa_booking-connid,
            wa_booking-fldate,
            wa_booking-bookid,
            wa_booking-name.
    ENDIF.

  ENDSELECT.

  CLEAR wa_booking.



AT LINE-SELECTION.

  IF sy-lsind = 1.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
         ID 'CARRID' FIELD wa_booking-carrid
         ID 'ACTVT'  FIELD actvt_change.

    IF sy-subrc = 0.

      CALL FUNCTION 'ENQUEUE_ESBOOK'
           EXPORTING
                carrid         = wa_booking-carrid
                connid         = wa_booking-connid
                fldate         = wa_booking-fldate
                bookid         = wa_booking-bookid
           EXCEPTIONS
                foreign_lock   = 1
                system_failure = 2
                OTHERS         = 3.

      IF sy-subrc <> 0.
        MESSAGE ID     sy-msgid
                TYPE   sy-msgty
                NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      SELECT SINGLE * FROM sbook INTO wa_sbook
             WHERE carrid = wa_booking-carrid
              AND  connid = wa_booking-connid
              AND  fldate = wa_booking-fldate
              AND  bookid = wa_booking-bookid.

      IF sy-subrc = 0.
        MOVE-CORRESPONDING wa_sbook TO sdyn_book.
        MOVE wa_booking-name TO sdyn_book-name.
        CALL SCREEN 100.
        CALL FUNCTION 'DEQUEUE_ESBOOK'
             EXPORTING
               carrid = wa_booking-carrid
               connid = wa_booking-connid
               fldate = wa_booking-fldate
               bookid = wa_booking-bookid.
      ENDIF.

    ELSE .
      MESSAGE ID 'BC400' TYPE 'S' NUMBER '047' WITH wa_booking-carrid.
    ENDIF.

  ENDIF.

  CLEAR: wa_sbook, wa_booking.



  INCLUDE bc400tcs_enqueue_dequeueo01.
*  INCLUDE bc400uds_dynpro_do01.

  INCLUDE bc400tcs_enqueue_dequeuei01.
*  INCLUDE bc400uds_dynpro_di01.
