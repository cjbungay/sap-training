*----------------------------------------------------------------------*
***INCLUDE BC414S_BOOKINGS_02I01 .
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
* remove all database locks
          PERFORM deq_all.
          LEAVE TO SCREEN '0100'.
        WHEN '0300'.
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
* set database lock for selected flight and depending bookings
      PERFORM enq_sflight_sbook.
      PERFORM read_sflight USING wa_sflight sysubrc.
      PERFORM process_sysubrc_bookc.
      PERFORM read_spfli USING wa_spfli.
      PERFORM read_sbook USING itab_book itab_cd.
      REFRESH CONTROL 'TC_SBOOK' FROM SCREEN '0200'.
******************************CREATE BOOKING****************************
    WHEN 'BOOKN'.
      PERFORM read_sflight USING wa_sflight sysubrc.
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
      PERFORM collect_modified_data USING itab_sbook_modify.
      PERFORM save_modified_booking.
* remove all database locks
      PERFORM deq_all.
      SET SCREEN '0100'.
    WHEN 'BACK'.
* remove all database locks
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
      SET SCREEN '0100'.
    WHEN 'BACK'.
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
