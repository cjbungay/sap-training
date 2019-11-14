*&---------------------------------------------------------------------*
*&      Module  check_sflight  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_sflight INPUT.

  DATA lv_counter TYPE i.

  SELECT COUNT( * )
      FROM  sflight15
      INTO lv_counter
      WHERE carrid      = sflight15-carrid AND
            connid      = sflight15-connid AND
            fldate      = sflight15-fldate .

  IF sy-subrc NE 0.
    MESSAGE e007.
*D:  Tabelleneintrag zum eingegebenen Schlüssel nicht vorhanden
*E:  No table entry for selected key
  ENDIF.

ENDMODULE.                 " check_sflight  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Set next screen                                                *
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE save_ok.

    WHEN 'CREA'.                 "Create
      gv_change_mode = c_true.
      SET SCREEN 200.

    WHEN 'CHNG'.                 "Change
      gv_change_mode = c_true.
      SET SCREEN 200.

    WHEN 'MORE'.                 "Display
      gv_change_mode = c_false.
      SET SCREEN 200.

    WHEN 'BACK'.                 "Back
      SET SCREEN 0.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND  INPUT

*&---------------------------------------------------------------------*
*&      Module  CANCEL_EXIT  INPUT
*&---------------------------------------------------------------------*
*       Set next screen for cancel and exit command of user            *
*----------------------------------------------------------------------*
MODULE cancel_exit INPUT.

  DATA:
      lv_answer TYPE c.

  CASE sy-dynnr.

** Screen 0100:
    WHEN '0100'.
      LEAVE TO SCREEN 0.

** Screen 0200:
    WHEN '0200'.
      CASE ok_code.
        WHEN 'EXIT'.
          CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
            EXPORTING
              textline1 = text-sav
              titel     = text-svd
            IMPORTING
              answer    = lv_answer.

          CASE lv_answer.
            WHEN 'J'.                  " J = Yes
* Not save here, but during "normal" ok-code processing because all
* screen checks will be executed after this module.
* Saving and LEAVE TO SCREEN 0 is coded after all checks!

            WHEN 'N'.                  " N = No
* ... release all database locks
              CALL FUNCTION 'DEQUEUE_ALL'
*           EXPORTING
*             _SYNCHRON       = ' '
                        .
              LEAVE TO SCREEN 0.

            WHEN OTHERS.               " Cancel cancelled :-)
              CLEAR ok_code.

          ENDCASE.

        WHEN 'CANC'.
          CALL FUNCTION 'POPUP_TO_CONFIRM_LOSS_OF_DATA'
            EXPORTING
              textline1 = text-003
              titel     = text-004
            IMPORTING
              answer    = lv_answer.

          IF lv_answer = 'J'.             " J = Yes
* ... release all database locks
            CALL FUNCTION 'DEQUEUE_ALL'
*           EXPORTING
*             _SYNCHRON       = ' '
                      .
            LEAVE TO SCREEN 100.
          ENDIF.
      ENDCASE.

* ... Add any subsequent screens

  ENDCASE.


ENDMODULE.                             " CANCEL_EXIT  INPUT
*&---------------------------------------------------------------------*
*&      Module  SAVE_OK_CODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE save_ok_code INPUT.

  save_ok = ok_code.
  CLEAR ok_code.

ENDMODULE.                             " SAVE_OK_CODE  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

*  DATA:
*      lv_answer TYPE c.

  CASE save_ok.

    WHEN 'BACK'.

      CASE sy-datar.

        WHEN space.
          LEAVE TO SCREEN 100.

        WHEN OTHERS.
          CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
            EXPORTING
*           DEFAULTOPTION        = 'Y'
              textline1            = text-dlo
              textline2            = text-sav
              titel                = text-bck
*           START_COLUMN         = 25
*           START_ROW            = 6
*           CANCEL_DISPLAY       = 'X'
           IMPORTING
             answer               = lv_answer
                    .
          IF lv_answer = 'J' OR lv_answer = 'Y'.
            PERFORM save_flights.
            LEAVE TO SCREEN 100.
          ELSEIF lv_answer = 'N'.
            LEAVE TO SCREEN 100.
          ENDIF.

      ENDCASE.

    WHEN 'EXIT'.            "only processed if user chooses YES, save!

      PERFORM save_flights.
      LEAVE PROGRAM.

    WHEN 'SAVE'.

      PERFORM save_flights.
      LEAVE TO SCREEN 100.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0200  INPUT

*&---------------------------------------------------------------------*
*&      Module  move_data_from_screen  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE move_data_from_screen INPUT.

  MOVE:
      sflight15-price      TO gs_flight-price,
      sflight15-currency   TO gs_flight-currency,
      sflight15-planetype  TO gs_flight-planetype,
      sflight15-seatsmax   TO gs_flight-seatsmax,
      sflight15-seatsocc   TO gs_flight-seatsocc
      .

ENDMODULE.                 " move_data_from_screen  INPUT

*&---------------------------------------------------------------------*
*&      Module  data_from_subscreen  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE data_from_subscreen INPUT.

  CALL METHOD gr_badi_reference->get_data
    IMPORTING
      e_flight = gs_flight_hlp.
  .
  IF gs_flight_hlp-carrid IS NOT INITIAL.
    MOVE gs_flight_hlp TO gs_flight.
  ENDIF.

ENDMODULE.                 " data_from_subscreen  INPUT
