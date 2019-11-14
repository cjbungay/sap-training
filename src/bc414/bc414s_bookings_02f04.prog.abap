*----------------------------------------------------------------------*
*   INCLUDE BC414S_BOOKINGS_02F04
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SAVE_MODIFIED_BOOKING
*&---------------------------------------------------------------------*
FORM save_modified_booking.
* Modify data on database tables sbook and sflight
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
*********************** TO BE IMPLEMENTED LATER ************************
ENDFORM.                               " SAVE_NEW_BOOKING
