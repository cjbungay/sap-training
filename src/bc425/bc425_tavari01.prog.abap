*----------------------------------------------------------------------*
*& Include BC425_TAVARI01
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       Process "exit" ok codes for all screens
*----------------------------------------------------------------------*
MODULE exit_command INPUT.

  CASE sy-dynnr.
    WHEN '0100'.
      LEAVE TO SCREEN 0.

    WHEN '0200'.
      CASE ok_code.
        WHEN 'EXIT'.
          LEAVE PROGRAM.

        WHEN 'CANCEL'.
          LEAVE TO SCREEN 100.

        WHEN 'STEP_BACK'.
          LEAVE TO SCREEN 100.

      ENDCASE.

    WHEN '0210'.
      CASE ok_code.
        WHEN 'EXIT'.
          LEAVE PROGRAM.

        WHEN 'CANCEL'.
          LEAVE TO SCREEN 100.

        WHEN 'STEP_BACK'.
          LEAVE TO SCREEN 100.

      ENDCASE.

    WHEN '0300'.
      CASE ok_code.
        WHEN 'EXIT'.
          LEAVE PROGRAM.

        WHEN 'CANCEL'.
          LEAVE TO SCREEN 100.

        WHEN 'STEP_BACK'.
          LEAVE TO SCREEN list_screen.

      ENDCASE.

    WHEN '0400'.
      CASE ok_code.
        WHEN 'EXIT'.
          LEAVE PROGRAM.

        WHEN 'CANCEL'.
          LEAVE TO SCREEN 100.

        WHEN 'STEP_BACK'.
          LEAVE TO SCREEN 300.

      ENDCASE.

  ENDCASE.

ENDMODULE.                             " EXIT_COMMAND  INPUT

*&---------------------------------------------------------------------*
*&      Module  COPY_OK_CODE  INPUT
*&---------------------------------------------------------------------*
* Copy ok code to internal data field
*----------------------------------------------------------------------*
MODULE copy_ok_code INPUT.

  save_ok = ok_code.
  CLEAR ok_code.

ENDMODULE.                             " COPY_OK_CODE  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Process ok codes for screen 100
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE save_ok.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'TC' OR 'SL'.
      PERFORM fill_itab.

      IF save_ok = 'TC'.
        SET SCREEN 200.
      ELSE.
        SET SCREEN 210.
      ENDIF.

      LEAVE SCREEN.

    WHEN OTHERS.
      PERFORM special_ok_code.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0210  INPUT
*&---------------------------------------------------------------------*
*       Process ok codes for screen 210
*----------------------------------------------------------------------*
MODULE user_command_0210 INPUT.

  PERFORM process_back.                " Same coding for all screens

  CASE save_ok.

    WHEN 'EXIT'.               " User want's to leave after saving
      LEAVE PROGRAM.

* ---
* Implement step loop paging here!
* ---

    WHEN 'PICK'.
      PERFORM read_itab.

    WHEN 'STEP_BACK'.
      LEAVE TO SCREEN 100.

    WHEN OTHERS.
      PERFORM special_ok_code.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0210  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       Process ok codes for screen 200
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  PERFORM process_back.                " Same coding for all screens

  CASE save_ok.

    WHEN 'EXIT'.               " User want's to leave after saving
      LEAVE PROGRAM.

    WHEN 'PICK'.
      PERFORM read_itab.

    WHEN 'STEP_BACK'.
      LEAVE TO SCREEN 100.

    WHEN OTHERS.
      PERFORM special_ok_code.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0200  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
*       Process ok codes for screen 300
*----------------------------------------------------------------------*
MODULE user_command_0300 INPUT.

  PERFORM process_back.                " Same coding for all screens

  CASE save_ok.

    WHEN 'EXIT'.               " User want's to leave after saving
      LEAVE PROGRAM.

    WHEN 'BOOK'.
      LEAVE TO SCREEN 400.

    WHEN 'STEP_BACK'.
      LEAVE TO SCREEN list_screen.

    WHEN OTHERS.
      PERFORM special_ok_code.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0300  INPUT


*&---------------------------------------------------------------------*
*&      Module  GET_MARKED_LINE  INPUT
*&---------------------------------------------------------------------*
*       Save selected line from TableControl
*----------------------------------------------------------------------*
MODULE get_marked_line INPUT.

if SDYN_CONN-MARK = 'X'.
  line_itab = my_tc-current_line.
  endif.

ENDMODULE.                             " GET_MARKED_LINE  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0400  INPUT
*&---------------------------------------------------------------------*
*       Process ok codes for screen 400
*----------------------------------------------------------------------*
MODULE user_command_0400 INPUT.
  PERFORM process_back.                " Same coding for all screens

  CASE save_ok.

    WHEN 'EXIT'.               " User want's to leave after saving
      LEAVE PROGRAM.

    WHEN 'LOGON'.
      PERFORM logon_and_book.

    WHEN 'STEP_BACK'.
      LEAVE TO SCREEN 300.

    WHEN OTHERS.
      PERFORM special_ok_code.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0400  INPUT
