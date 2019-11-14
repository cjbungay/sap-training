*----------------------------------------------------------------------*
***INCLUDE BC414D_CALLTECHNIQUESI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  save_ok_code = ok_code.
  clear ok_code.

  case save_ok_code.
    when 'EXEC_SUBMIT'.  " radio button group for type 1 program calls
      case c_marked.
        when submit_1.      " SUBMIT
          submit sapbc414D_program.
        when submit_2.      " SUBMIT VIA SELECTION-SCREEN
          submit sapbc414D_program via selection-screen.
        when submit_3.      " SUBMIT AND RETURN
          submit sapbc414D_program and RETURN.
        when submit_4.      " SUBMIT VIA SELECTION-SCREEN AND RETURN
          submit sapbc414D_program via selection-screen
                                   and return.
      endcase.
    when 'EXEC_CALL'.
      case c_marked.     " radio button group for transaction calls
        when leave_1.       " LEAVE TO TRANSACTION
          leave to transaction 'BC414D_TRANSACTION'.
        when leave_2.       " LEAVE TO TRANSACTION AND SKIP FIRST SCREEN
          leave to transaction 'BC414D_TRANSACTION'
            and skip first screen.
        when call_1.        " CALL TRANSACTION
          call transaction 'BC414D_TRANSACTION'.
        when call_2.        " CALL TRANSACTION AND SKIP FIRST SCREEN
          call transaction 'BC414D_TRANSACTION'
            and skip first screen.
      endcase.
    when 'EXEC_CF'.
       CALL FUNCTION 'READ_SPFLI'
            EXPORTING
                 carrid      = 'LH'
                 connid      = '0400'
*           EXCEPTIONS
*                INVALID_KEY = 1
*                OTHERS      = 2
                 .
       IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
       ENDIF.

    when 'BACK'.
      leave to screen 0.
  endcase.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_COMMAND_0100 INPUT.
  case ok_code.
    when 'EXIT'.
      leave program.
    when 'CANCEL'.
      leave to screen 0.
  endcase.
ENDMODULE.                 " EXIT_COMMAND_0100  INPUT
