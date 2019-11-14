*----------------------------------------------------------------------*
***INCLUDE BC414S_CREATE_FLIGHTF01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  ENQ_SFLIGHT
*&---------------------------------------------------------------------*
FORM ENQ_SFLIGHT.
  CALL FUNCTION 'ENQUEUE_ESFLIGHT'
       EXPORTING
            CARRID         = SDYN_CONN-CARRID
            CONNID         = SDYN_CONN-CONNID
            FLDATE         = SDYN_CONN-FLDATE
       EXCEPTIONS
            FOREIGN_LOCK   = 1
            SYSTEM_FAILURE = 2
            OTHERS         = 3.
  IF SY-SUBRC <> 0.
* Dataset allready locked
    MESSAGE E060 WITH SDYN_CONN-CARRID SDYN_CONN-CONNID
                      SDYN_CONN-FLDATE.
  ENDIF.
ENDFORM.                               " ENQ_SFLIGHT

*&---------------------------------------------------------------------*
*&      Form  DEQ_SFLIGHT
*&---------------------------------------------------------------------*
FORM DEQ_SFLIGHT.
  CALL FUNCTION 'DEQUEUE_ESFLIGHT'
       EXPORTING
            CARRID = SDYN_CONN-CARRID
            CONNID = SDYN_CONN-CONNID
            FLDATE = SDYN_CONN-FLDATE.
ENDFORM.                               " DEQ_SFLIGHT

*&---------------------------------------------------------------------*
*&      Form  READ_DETAILS
*&---------------------------------------------------------------------*
FORM READ_DETAILS.
  SELECT SINGLE CARRNAME CURRCODE FROM SCARR
         INTO (SDYN_CONN-CARRNAME, SDYN_CONN-CURRENCY)
                  WHERE CARRID = SDYN_CONN-CARRID.
ENDFORM.                               " READ_DETAILS

*&---------------------------------------------------------------------*
*&      Form  READ_SEATSMAX
*&---------------------------------------------------------------------*
FORM READ_SEATSMAX.
* refresh seatsmax corresponding to chosen planetype
  SELECT SINGLE SEATSMAX FROM SAPLANE INTO SDYN_CONN-SEATSMAX
         WHERE PLANETYPE = SDYN_CONN-PLANETYPE.
ENDFORM.                               " READ_SEATSMAX

*&---------------------------------------------------------------------*
*&      Form  READ_FLIGHT
*&---------------------------------------------------------------------*
FORM READ_FLIGHT.
  SELECT SINGLE * FROM SFLIGHT INTO CORRESPONDING FIELDS OF SDYN_CONN
         WHERE CARRID = SDYN_CONN-CARRID
         AND   CONNID = SDYN_CONN-CONNID
         AND   FLDATE = SDYN_CONN-FLDATE.
  IF SY-SUBRC = 0.
* flight is allready created
* remove logical database lock
    PERFORM DEQ_SFLIGHT.
    MESSAGE E057 WITH SDYN_CONN-CARRID SDYN_CONN-CONNID
                      SDYN_CONN-FLDATE.
  ENDIF.
ENDFORM.                               " READ_FLIGHT

*&---------------------------------------------------------------------*
*&      Form  POPUP_TO_CONFIRM_STEP_EXIT
*&---------------------------------------------------------------------*
FORM POPUP_TO_CONFIRM_STEP_EXIT.
  DATA: ANSWER.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
       EXPORTING
            TEXTLINE1 = 'Unsaved data will be lost.'(001)
            TEXTLINE2 = 'Save data before exiting?'(002)
            TITEL     = 'Exit program'(003)
       IMPORTING
            ANSWER    = ANSWER.
  CASE ANSWER.
    WHEN 'J'.
* save before exiting
      OK_CODE = 'SAVE_EXIT'.
    WHEN 'N'.
* exiting directly (without further checks)
      LEAVE PROGRAM.
    WHEN 'A'.
* stay on screen
      CLEAR OK_CODE.
  ENDCASE.
ENDFORM.                               " POPUP_TO_CONFIRM_STEP_EXIT

*&---------------------------------------------------------------------*
*&      Form  POPUP_TO_CONFIRM_LOSS_OF_DATA
*&---------------------------------------------------------------------*
FORM POPUP_TO_CONFIRM_LOSS_OF_DATA.
  DATA: ANSWER.
  CALL FUNCTION 'POPUP_TO_CONFIRM_LOSS_OF_DATA'
       EXPORTING
            TEXTLINE1 = 'Cancel processing of flight?'(004)
            TITEL     = 'Cancel processing'(005)
       IMPORTING
            ANSWER    = ANSWER.
  CASE ANSWER.
    WHEN 'J'.
* proceed with screen 100 (without further checks)
* remove logical database lock
      PERFORM DEQ_SFLIGHT.
      CLEAR OK_CODE.
      LEAVE TO SCREEN '0100'.
    WHEN 'N'.
* stay on screen (without further checks)
      CLEAR OK_CODE.
      LEAVE TO SCREEN '0200'.
  ENDCASE.
ENDFORM.                               " POPUP_TO_CONFIRM_LOSS_OF_DATA

*&---------------------------------------------------------------------*
*&      Form  POPUP_TO_CONFIRM_STEP_BACK
*&---------------------------------------------------------------------*
FORM POPUP_TO_CONFIRM_STEP_BACK.
  DATA: ANSWER.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
       EXPORTING
            TEXTLINE1 = 'Unsaved data will be lost.'(001)
            TEXTLINE2 = 'Save data?'(006)
            TITEL     = 'Back'(007)
       IMPORTING
            ANSWER    = ANSWER.
  CASE ANSWER.
    WHEN 'J'.
* proceed with screen 100 after having saved data
      PERFORM SAVE_DATA.
* remove logical database lock
      PERFORM DEQ_SFLIGHT.
      SET SCREEN '0100'.
    WHEN 'N'.
* remove logical database lock
      PERFORM DEQ_SFLIGHT.
      SET SCREEN '0100'.
    WHEN 'A'.
      CLEAR OK_CODE.
  ENDCASE.
ENDFORM.                               " POPUP_TO_CONFIRM_STEP_BACK

*&---------------------------------------------------------------------*
*&      Form  SAVE_DATA
*&---------------------------------------------------------------------*
FORM SAVE_DATA.
* fill workarea, that fits to structure of database table
  MOVE-CORRESPONDING SDYN_CONN TO WA_SFLIGHT.
  INSERT INTO SFLIGHT VALUES WA_SFLIGHT.
  IF SY-SUBRC <> 0.
* insertion not successful -> rollback
    MESSAGE A051.
  ELSE.
* insertion successful
    MESSAGE S013 WITH SDYN_CONN-CARRID SDYN_CONN-CONNID
                      SDYN_CONN-FLDATE.
  ENDIF.
ENDFORM.                               " SAVE_DATA
