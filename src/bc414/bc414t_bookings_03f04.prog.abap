*----------------------------------------------------------------------*
*   INCLUDE BC414T_BOOKINGS_03F04
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SAVE_MODIFIED_BOOKING
*&---------------------------------------------------------------------*
FORM save_modified_booking.
************************************************************************
* a) Change modification of bookings and corresponding flight
*    to asynchronous update technique
************************************************************************
  CALL FUNCTION 'UPDATE_SBOOK'
       EXPORTING
            itab_sbook     = itab_sbook_modify
       EXCEPTIONS
            update_failure = 1
            OTHERS         = 2.
  CASE sy-subrc.
    WHEN 0.
      PERFORM update_sflight.
    WHEN OTHERS.
      MESSAGE a044 WITH wa_sflight-carrid wa_sflight-connid
                        wa_sflight-fldate.
  ENDCASE.
ENDFORM.                               " SAVE_MODIFIED_BOOKING

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT
*&---------------------------------------------------------------------*
FORM update_sflight.
************************************************************************
* a) Change modification of bookings and corresponding flight
*    to asynchronous update technique
************************************************************************
  CALL FUNCTION 'UPDATE_SFLIGHT'
       EXPORTING
            carrier          = wa_sflight-carrid
            connection       = wa_sflight-connid
            date             = wa_sflight-fldate
       EXCEPTIONS
            update_failure   = 1
            flight_full      = 2
            flight_not_found = 3
            OTHERS           = 4.
  CASE sy-subrc.
    WHEN 0.
      MESSAGE s034 WITH wa_sflight-carrid wa_sflight-connid
                        wa_sflight-fldate.
    WHEN 1.
      MESSAGE a044 WITH wa_sflight-carrid wa_sflight-connid
                        wa_sflight-fldate.
    WHEN 2.
      MESSAGE a045.
    WHEN 3.
      MESSAGE a046.
    WHEN OTHERS.
      MESSAGE a048.
  ENDCASE.
ENDFORM.                               " UPDATE_SFLIGHT

*&---------------------------------------------------------------------*
*&      Form  SAVE_NEW_BOOKING
*&---------------------------------------------------------------------*
FORM save_new_booking.
  PERFORM convert_to_loc_currency USING wa_sbook.
************************************************************************
* a) lock dataset to be created
* b) Insert new booking (wa_sbook) in DB table SBOOK using
*    asynchronous update technique. Call Function INSERT_SBOOK
* c) Modify coresponding flight using asynchronous update technique
************************************************************************
ENDFORM.                               " SAVE_NEW_BOOKING
