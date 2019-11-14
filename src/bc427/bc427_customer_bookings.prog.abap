REPORT  bc427_customer_bookings.

PARAMETERS customid TYPE scustom-id.

DATA wa_booking TYPE sbook.


START-OF-SELECTION.

  sy-tvar1 = customid.

  SELECT * FROM sbook
    INTO wa_booking
    WHERE  customid = customid.

    WRITE: / wa_booking-carrid,
             wa_booking-connid,
          11 wa_booking-fldate,
          24 wa_booking-bookid,
          35 wa_booking-order_date.

  ENDSELECT.

  IF sy-subrc NE 0.
    WRITE text-nbf.
  ENDIF.
