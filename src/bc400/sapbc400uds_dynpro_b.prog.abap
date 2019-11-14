*&---------------------------------------------------------------------*
*& Report  SAPBC400UDS_DYNPRO_B                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400uds_dynpro_b.

CONSTANTS: actvt_display TYPE activ_auth VALUE '03',
           actvt_change TYPE activ_auth VALUE '02'.

PARAMETERS pa_anum TYPE sbook-agencynum.

DATA wa_booking TYPE sbc400_booking.

* workarea for single booking to be changed
DATA wa_sbook TYPE sbook.

* workarea for dynpro
TABLES sdyn_book.



START-OF-SELECTION.

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
