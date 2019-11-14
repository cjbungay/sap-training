*----------------------------------------------------------------------*
*   INCLUDE BC414T_BOOKINGS_05F04
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SAVE_MODIFIED_BOOKING
*&---------------------------------------------------------------------*
FORM save_modified_booking.
  CALL FUNCTION 'UPDATE_SBOOK' IN UPDATE TASK
       EXPORTING
            itab_sbook = itab_sbook_modify.
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
ENDFORM.                               " UPDATE_SFLIGHT

*&---------------------------------------------------------------------*
*&      Form  SAVE_NEW_BOOKING
*&---------------------------------------------------------------------*
FORM save_new_booking.
  PERFORM convert_to_loc_currency USING wa_sbook.
* number ranges: Get next free number. Details are encapsulated in the
* form NUMBER_GET_NEXT
  PERFORM number_get_next USING wa_sbook.
  PERFORM enq_sbook.
  CALL FUNCTION 'INSERT_SBOOK' IN UPDATE TASK
       EXPORTING
            wa_sbook = wa_sbook.
  PERFORM update_sflight.
ENDFORM.                               " SAVE_NEW_BOOKING
