*----------------------------------------------------------------------*
***INCLUDE BC414S_CREATE_FLIGHTI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.
  LEAVE PROGRAM.
ENDMODULE.                             " EXIT_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  EXIT_0200  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0200 INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      IF SY-DATAR IS INITIAL AND MARK_CHANGED IS INITIAL.
* field values have not been changed on screen 200.
        LEAVE PROGRAM.
      ELSE.
* at least one field value has been changed on screen 200 ->
* ask user if changes should be saved.
        PERFORM POPUP_TO_CONFIRM_STEP_EXIT.
      ENDIF.
    WHEN 'CANCEL'.
      IF SY-DATAR IS INITIAL AND MARK_CHANGED IS INITIAL.
* field values have not been changed on screen 200.
* remove logical database lock.
        PERFORM DEQ_SFLIGHT.
        CLEAR OK_CODE.
* do not perform further checks of field types / field values
        LEAVE TO SCREEN '0100'.
      ELSE.
* at least one field value has been changed on screen 200 ->
* ask user if changes should be saved.
        PERFORM POPUP_TO_CONFIRM_LOSS_OF_DATA.
      ENDIF.
  ENDCASE.
ENDMODULE.                             " EXIT_0200  INPUT

*&---------------------------------------------------------------------*
*&      Module  SAVE_OK_CODE  INPUT
*&---------------------------------------------------------------------*
MODULE SAVE_OK_CODE INPUT.
  SAVE_OK = OK_CODE.
  CLEAR OK_CODE.
ENDMODULE.                             " SAVE_OK_CODE  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE SAVE_OK.
    WHEN 'DETS'.
      PERFORM READ_DETAILS.
      SET SCREEN '0200'.
    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN OTHERS.
      SET SCREEN '0100'.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.
  PERFORM READ_SEATSMAX.
  CASE SAVE_OK.
    WHEN 'SAVE_EXIT'.
* save data before exiting program.
      PERFORM SAVE_DATA.
      LEAVE PROGRAM.
    WHEN 'SAVE'.
      PERFORM SAVE_DATA.
* remove logical database lock
      PERFORM DEQ_SFLIGHT.
      SET SCREEN '0000'.
    WHEN 'BACK'.
      IF MARK_CHANGED IS INITIAL.
* field values have not been changed on screen 200.
* remove logical database lock
        PERFORM DEQ_SFLIGHT.
        SET SCREEN '0100'.
      ELSE.
* at least one field value has been changed on screen 200 ->
* ask user if changes should be saved.
        PERFORM POPUP_TO_CONFIRM_STEP_BACK.
      ENDIF.
    WHEN OTHERS.
      SET SCREEN '0200'.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0200  INPUT

*&---------------------------------------------------------------------*
*&      Module  CHECK_FLIGHT  INPUT
*&---------------------------------------------------------------------*
MODULE CHECK_FLIGHT INPUT.
* set logical database lock
  PERFORM ENQ_SFLIGHT.
* check if flight aalready exists
  PERFORM READ_FLIGHT.
ENDMODULE.                             " CHECK_FLIGHT  INPUT

*&---------------------------------------------------------------------*
*&      Module  MARK_CHANGED  INPUT
*&---------------------------------------------------------------------*
MODULE MARK_CHANGED INPUT.
* set flag if at least one field value is changed on screen 200.
  MARK_CHANGED = 'X'.
ENDMODULE.                             " MARK_CHANGED  INPUT
