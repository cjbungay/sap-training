*----------------------------------------------------------------------*
***INCLUDE BC414S_BOOKINGSI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.
      CASE sy-dynnr.
        WHEN '0100'.
          LEAVE PROGRAM.
        WHEN '0200'.
          PERFORM deq_all.
          LEAVE TO SCREEN '0100'.
        WHEN '0300'.
          PERFORM deq_all.
          LEAVE TO SCREEN '0100'.
        WHEN OTHERS.
      ENDCASE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                             " EXIT  INPUT

*&---------------------------------------------------------------------*
*&      Module  SAVE_OK_CODE  INPUT
*&---------------------------------------------------------------------*
MODULE save_ok_code INPUT.
  save_ok = ok_code.
  CLEAR ok_code.
ENDMODULE.                             " SAVE_OK_CODE  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE save_ok.
******************************CANCEL BOOKING****************************
    WHEN 'BOOKC'.
      PERFORM enq_sflight_sbook.
      PERFORM read_sflight USING wa_sflight sysubrc.
* process returncode - if flight does not exist: e-message
      PERFORM process_sysubrc_bookc.
      PERFORM read_spfli USING wa_spfli.
      PERFORM read_sbook USING itab_book itab_cd.
      REFRESH CONTROL 'TC_SBOOK' FROM SCREEN '0200'.
******************************CREATE BOOKING****************************
    WHEN 'BOOKN'.
      PERFORM enq_sflight.
      PERFORM read_sflight USING wa_sflight sysubrc.
* process returncode - if flight does not exist: e-message
      PERFORM process_sysubrc_bookn.
      PERFORM read_spfli USING wa_spfli.
      PERFORM initialize_sbook USING wa_sbook.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN OTHERS.
      SET SCREEN '0100'.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE save_ok.
    WHEN 'SAVE'.
* collect marked (changed) data sets in seperate internal table
      PERFORM collect_modified_data USING itab_sbook_modify.
* perform database changes
      PERFORM save_modified_booking.
* create change documents
      PERFORM create_change_documents.
      COMMIT WORK.
* Unlocking data sets is executed by the update program !!
      SET SCREEN '0100'.
    WHEN 'BACK'.
      PERFORM deq_all.
      SET SCREEN '0100'.
    WHEN OTHERS.
      SET SCREEN '0200'.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0200  INPUT

*&---------------------------------------------------------------------*
*&      Module  MODIFY_ITAB  INPUT
*&---------------------------------------------------------------------*
MODULE modify_itab INPUT.
  wa_book-cancelled = sdyn_book-cancelled.
  wa_book-mark = 'X'.
  MODIFY itab_book FROM wa_book INDEX tc_sbook-current_line.
ENDMODULE.                             " MODIFY_ITAB  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0300  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0300 INPUT.
  PERFORM tabstrip_set.
  CASE save_ok.
    WHEN 'NEW_CUSTOM'.
      PERFORM create_new_customer.
      SET SCREEN '0300'.
    WHEN 'SAVE'.
      PERFORM save_new_booking.
      COMMIT WORK.
* Unlocking data sets is executed by the update program !!
      SET SCREEN '0100'.
    WHEN 'BACK'.
      PERFORM deq_all.
      SET SCREEN '0100'.
    WHEN OTHERS.
      SET SCREEN '0300'.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0300  INPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_FROM_0300  INPUT
*&---------------------------------------------------------------------*
MODULE trans_from_0300 INPUT.
  MOVE-CORRESPONDING sdyn_book TO wa_sbook.
ENDMODULE.                             " TRANS_FROM_0300  INPUT
