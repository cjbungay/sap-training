*----------------------------------------------------------------------*
*  INCLUDE BC400TCS_ENQUEUE_DEQUEUEI01                                 *
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT                               *
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      MESSAGE ID 'BC400' TYPE 'S' NUMBER '057'.
      SET SCREEN 0.
    WHEN 'SAVE'.
      MOVE-CORRESPONDING sdyn_book TO wa_sbook.
      CALL FUNCTION 'BC400_UPDATE_BOOK'
           EXPORTING
             iv_book = wa_sbook
           EXCEPTIONS
             OTHERS  = 5.
      IF sy-subrc <> 0.
        MESSAGE a150(bc400) WITH wa_sbook-carrid wa_sbook-connid
                                 wa_sbook-fldate wa_sbook-bookid.
      ELSE.
        MESSAGE s148(bc400).
        SET SCREEN 0.
      ENDIF.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0100  INPUT
