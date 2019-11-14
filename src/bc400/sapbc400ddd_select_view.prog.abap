*&---------------------------------------------------------------------*
*& Report  SAPBC400DDD_SELECT_VIEW                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400ddd_select_view .

PARAMETERS pa_anum TYPE s_agncynum.

DATA wa_sbc400_booking TYPE sbc400_booking.


SELECT mandt carrid connid fldate bookid
       customid class
       name street city country
       agencynum
       FROM sbc400_booking
       INTO wa_sbc400_booking
       WHERE agencynum = pa_anum.

  WRITE: / wa_sbc400_booking-carrid,
           wa_sbc400_booking-connid,
           wa_sbc400_booking-fldate,
           wa_sbc400_booking-bookid,
           wa_sbc400_booking-customid,
           wa_sbc400_booking-class,
           wa_sbc400_booking-name,
           wa_sbc400_booking-street,
           wa_sbc400_booking-city,
           wa_sbc400_booking-country,
           wa_sbc400_booking-agencynum.

ENDSELECT.
