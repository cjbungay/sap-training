*----------------------------------------------------------------------*
***INCLUDE BC412_UDCS_EXERCISE_1I01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  exit_command_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type 'E'.
*----------------------------------------------------------------------*
MODULE exit_command_0100 INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.        " cancel current screen processing
      CLEAR l_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
*               DEFAULTOPTION  = 'Y'
                textline1      = text-004
                textline2      = text-005
                titel          = text-006
                cancel_display = ' '
           IMPORTING
                answer         = l_answer.
      CASE l_answer.
        WHEN 'J'.
          PERFORM free_control_ressources.
          LEAVE TO SCREEN 0.
        WHEN 'N'.
          CLEAR ok_code.
          SET SCREEN sy-dynnr.
      ENDCASE.

    WHEN 'EXIT'.                       " leave program
      CLEAR l_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
*               DEFAULTOPTION  = 'Y'
                textline1      = text-001
                textline2      = text-002
                titel          = text-003
                cancel_display = 'X'
           IMPORTING
                answer         = l_answer.
      CASE l_answer.
        WHEN 'J' OR 'N'.               " no data to update
          PERFORM free_control_ressources.
          LEAVE PROGRAM.
        WHEN 'A'.
          CLEAR ok_code.
          SET SCREEN sy-dynnr.
      ENDCASE.
  ENDCASE.
ENDMODULE.                 " exit_command_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type ' ':
*       - push buttons on the screen
*       - GUI functions
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  copy_ok_code = ok_code.
  CLEAR ok_code.

  CASE copy_ok_code.
    WHEN 'UNDO'.
      IF NOT undo_node_key IS INITIAL.
        CLEAR l_answer.
        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
             EXPORTING
*               DEFAULTOPTION  = 'Y'
                  textline1      = text-008
*               TEXTLINE2      =
                  titel          = text-009
                  cancel_display = ' '
             IMPORTING
                  answer         = l_answer.
        IF l_answer = 'J'.
          CALL METHOD ref_tree_model->delete_node
            EXPORTING
              node_key       = undo_node_key
            EXCEPTIONS
              node_not_found = 1
              OTHERS         = 2.
          IF sy-subrc <> 0.
            MESSAGE a012.
          ENDIF.
          CLEAR undo_node_key.

        ENDIF.
      ENDIF.

    WHEN 'BACK'.
      CLEAR l_answer.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
           EXPORTING
*               DEFAULTOPTION  = 'Y'
                textline1      = text-004
                textline2      = text-005
                titel          = text-007
                cancel_display = ' '
           IMPORTING
                answer         = l_answer.

      CASE l_answer.
        WHEN 'J'.
          PERFORM free_control_ressources.
          LEAVE TO SCREEN 0.
        WHEN 'N'.
          SET SCREEN sy-dynnr.
      ENDCASE.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                 " user_command_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       back to screen 100
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  copy_ok_code = ok_code.
  CLEAR ok_code.
ENDMODULE.                 " USER_COMMAND_0200  INPUT
