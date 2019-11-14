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
          SUBMIT sapbc414d_program
                  with pa_carr eq sflight-carrid
                  with so_conn eq sflight-connid.

        when submit_2.      " SUBMIT VIA SELECTION-SCREEN
          submit sapbc414D_program via selection-screen
                   with pa_carr eq sflight-carrid
                   with so_conn eq sflight-connid.
        when submit_3.      " SUBMIT AND RETURN
          submit sapbc414D_program and RETURN
                    with pa_carr eq sflight-carrid
                    with so_conn eq sflight-connid.
        when submit_4.      " SUBMIT VIA SELECTION-SCREEN AND RETURN
          submit sapbc414D_program via selection-screen
                                   and return
                    with pa_carr eq sflight-carrid
                    with so_conn eq sflight-connid.
      endcase.
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      import read_number to number_of_flights from memory id 'BC414'.
      if sy-subrc = 0.
        message s110(bc414) with number_of_flights.
      else.
        message s111(bc414).
      endif.
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    when 'EXEC_CALL'.
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
* move current values for carrid and connid into set/get parameters
      set parameter ID 'CAR' field sflight-carrid.
      set parameter ID 'CON' field sflight-connid.
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
                 carrid      = sflight-carrid
                 connid      = sflight-connid
            EXCEPTIONS
                 INVALID_KEY = 1
                 OTHERS      = 2
                 .
       IF sy-subrc <> 0.
         message e022(BC414) with sflight-carrid sflight-connid.
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
