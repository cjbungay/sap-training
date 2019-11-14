*&---------------------------------------------------------------------*
*& Report  SAPBC400UDT_DYNPRO_A                                        *
*&---------------------------------------------------------------------*

REPORT  sapbc400udt_dynpro_a.

CONSTANTS actvt_display TYPE activ_auth VALUE '03'.

PARAMETERS pa_anum TYPE sbook-agencynum.

DATA  wa_booking TYPE sbc400_booking.


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

    ENDIF.

  ENDSELECT.
