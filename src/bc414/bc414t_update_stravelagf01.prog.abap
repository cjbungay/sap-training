*----------------------------------------------------------------------*
***INCLUDE BC414T_UPDATE_STRAVELAGF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  READ_DATA
*&---------------------------------------------------------------------*
*      -->P_ITAB_STRAVELAG  text
*----------------------------------------------------------------------*
FORM read_data USING p_itab_stravelag LIKE itab_stravelag.
  SELECT * FROM stravelag
           INTO CORRESPONDING FIELDS OF TABLE p_itab_stravelag.
ENDFORM.                               " READ_DATA

*&---------------------------------------------------------------------*
*&      Form  WRITE_DATA
*&---------------------------------------------------------------------*
FORM write_data.
  LOOP AT itab_stravelag INTO wa_stravelag.
    WRITE AT: /pos1 mark AS CHECKBOX,
               pos2 wa_stravelag-agencynum COLOR COL_KEY,
               pos3 wa_stravelag-name,
               pos4 wa_stravelag-street,
               pos5 wa_stravelag-postcode,
               pos6 wa_stravelag-city,
               pos7 wa_stravelag-country.
    HIDE: wa_stravelag.
  ENDLOOP.
ENDFORM.                               " WRITE_DATA

*&---------------------------------------------------------------------*
*&      Form  WRITE_HEADER
*&---------------------------------------------------------------------*
FORM write_header.
  WRITE: / 'Travel agency data'(007), AT sy-linsz sy-pagno.
  ULINE.
  FORMAT COLOR COL_HEADING.
  WRITE AT: /pos2 'Agency'(001),
             pos3 'Name'(002),
             pos4 'Street'(003),
             pos5 'Postal Code'(004),
             pos6 'City'(005),
             pos7 'Country'(006).
  ULINE.
ENDFORM.                               " WRITE_HEADER

*&---------------------------------------------------------------------*
*&      Form  LOOP_AT_LIST
*&---------------------------------------------------------------------*
*      -->P_ITAB_AGNECYNUM  text
*----------------------------------------------------------------------*
FORM loop_at_list USING p_itab_travel LIKE itab_travel.
  DO.
    CLEAR: mark.
    READ LINE sy-index FIELD VALUE mark.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
    CHECK NOT mark IS INITIAL.
    APPEND wa_stravelag TO p_itab_travel.
  ENDDO.
ENDFORM.                               " LOOP_AT_LIST

*&---------------------------------------------------------------------*
*&      Form  CALL_SCREEN
*&---------------------------------------------------------------------*
FORM call_screen.
* Initialize table control on screen
  REFRESH CONTROL 'TC_STRAVELAG' FROM SCREEN '0100'.
* Show screen in modal dialog box.
  CALL SCREEN 100 STARTING AT  5  5
                  ENDING   AT 80 15.
ENDFORM.                               " CALL_SCREEN

*&---------------------------------------------------------------------*
*&      Form  POPUP_TO_CONFIRM_LOSS_OF_DATA
*&---------------------------------------------------------------------*
FORM popup_to_confirm_loss_of_data.
  DATA answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM_LOSS_OF_DATA'
       EXPORTING
            textline1 = 'Cancel processing of travel agencies?'(008)
            titel     = 'Cancel processing'(009)
       IMPORTING
            answer    = answer.
  CASE answer.
    WHEN 'J'.
      LEAVE TO SCREEN 0.
    WHEN 'N'.
      LEAVE TO SCREEN '0100'.
  ENDCASE.
ENDFORM.                               " POPUP_TO_CONFIRM_LOSS_OF_DATA

*&---------------------------------------------------------------------*
*&      Form  SAVE_CHANGES
*&---------------------------------------------------------------------*
FORM save_changes.
************************************************************************
* a) Update table stravelag.
* b) Handle returncode (messages s030 and i048)
* Modified data are buffered in the internal table itab_travel.
* The last field contains an 'X', if the dataset has been changed
* in the table control, otherwise it is initial.
************************************************************************
  modify_list = 'X'.
ENDFORM.                               " SAVE_CHANGES
