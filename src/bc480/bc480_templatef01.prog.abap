*&---------------------------------------------------------------------*
*&  Include           BC480_TEMPLATEF01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  select_business_data
*&---------------------------------------------------------------------*
FORM select_business_data .
  SELECT * "#EC CI_SGLSELECT
    FROM scustom
    INTO TABLE gt_customers
    WHERE id IN so_cusid.
  CHECK sy-subrc = 0.

  SELECT *
    FROM sbook
    INTO TABLE gt_all_bookings
    FOR ALL ENTRIES IN gt_customers
    WHERE customid = gt_customers-id AND
          carrid   IN so_car
    ORDER BY PRIMARY KEY.
  SORT gt_bookings BY carrid connid fldate.
ENDFORM.                    " select_business_data

*&---------------------------------------------------------------------*
*&      Form  find_bookings_for_customer
*&---------------------------------------------------------------------*
FORM find_bookings_for_customer .
  CLEAR: gt_bookings, gt_sums.

* build internal table that contains only the bookings for the
* current customer
  LOOP AT gt_all_bookings
    INTO gs_booking
    WHERE customid = gs_customer-id.
    APPEND gs_booking TO gt_bookings.

* currency key dependent summing
    gs_sums-price  = gs_booking-forcuram.
    gs_sums-currency = gs_booking-forcurkey.
    COLLECT gs_sums INTO gt_sums.
  ENDLOOP.

ENDFORM.                    " find_bookings_for_customer
