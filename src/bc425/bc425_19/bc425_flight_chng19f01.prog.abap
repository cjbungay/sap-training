*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_CHNG19F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM save_flights.

  PERFORM update_flight ON COMMIT.

  COMMIT WORK.

  CALL FUNCTION 'DEQUEUE_ESFLIGHT19'
    EXPORTING
      mode_sflight19 = 'E'
      mandt          = sy-mandt
      carrid         = sflight19-carrid
      connid         = sflight19-connid
      fldate         = sflight19-fldate.

ENDFORM.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM update_flight.

  UPDATE sflight19 FROM gs_flight.

  IF sy-subrc = 0.
    MESSAGE s008.
*   Daten erfolgreich verbucht
  ENDIF.

ENDFORM.                    " UPDATE_sflight
*&---------------------------------------------------------------------*
*&      Form  set_screen_status
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_screen_status .

  CLEAR: gs_excl_tab,
         gt_excl_tab.
  APPEND 'MORE' TO gt_excl_tab.
  APPEND 'CHNG' TO gt_excl_tab.
  APPEND 'CREA' TO gt_excl_tab.

  CASE save_ok.

    WHEN 'MORE'.
      APPEND 'SAVE' TO gt_excl_tab.

    WHEN 'CHNG' OR 'CREA'.

    WHEN OTHERS.
  ENDCASE.

  LOOP AT SCREEN.
    IF screen-group1 = 'MOD' AND gv_change_mode = c_false.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " set_screen_status
