*----------------------------------------------------------------------*
*   INCLUDE BC414S_BOOKINGS_04F04
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SAVE_MODIFIED_BOOKING
*&---------------------------------------------------------------------*
FORM save_modified_booking.
  CALL FUNCTION 'UPDATE_SBOOK' IN UPDATE TASK
       EXPORTING
            itab_sbook = itab_sbook_modify.
* no exception handling when using asynchronous update technique
  PERFORM update_sflight.
ENDFORM.                               " SAVE_MODIFIED_BOOKING

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT
*&---------------------------------------------------------------------*
FORM update_sflight.
  CALL FUNCTION 'UPDATE_SFLIGHT' IN UPDATE TASK
       EXPORTING
            carrier    = wa_sflight-carrid
            connection = wa_sflight-connid
            date       = wa_sflight-fldate.
* no exception handling when using asynchronous update technique
ENDFORM.                               " UPDATE_SFLIGHT

*&---------------------------------------------------------------------*
*&      Form  SAVE_NEW_BOOKING
*&---------------------------------------------------------------------*
FORM save_new_booking.
  PERFORM convert_to_loc_currency USING wa_sbook.
* lock booking on DB table sbook to be created
  PERFORM enq_sbook.
  CALL FUNCTION 'INSERT_SBOOK' IN UPDATE TASK
       EXPORTING
            wa_sbook = wa_sbook.
* no exception handling when using asynchronous update technique
  PERFORM update_sflight.
ENDFORM.                               " SAVE_NEW_BOOKING
