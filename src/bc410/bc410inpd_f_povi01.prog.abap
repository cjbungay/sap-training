*----------------------------------------------------------------------*
***INCLUDE BC410D_TEMPLATE1I01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.
      CLEAR ok_code.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " EXIT  INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CLEAR fieldname.
  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 100.
    WHEN 'PICK'.
      GET CURSOR FIELD fieldname.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0200  INPUT


*&---------------------------------------------------------------------*
*&      Module  TRANS_FROM_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_100 INPUT.
  MOVE-CORRESPONDING sdyn_conn00 TO wa_conn.
ENDMODULE.                             " TRANS_FROM_100  INPUT

*&---------------------------------------------------------------------*
*&      Module  CALL_SHL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE call_shl INPUT.
  repid = sy-repid.
  CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
       EXPORTING
            tabname             = 'SDYN_CONN00'
            fieldname           = 'FLDATE'
            searchhelp          = 'SDYN_CONN_FLDATE'
            shlpparam           = 'FLDATE'
            dynpprog            =  repid
            dynpnr              = '0100'
            dynprofield         = 'SDYN_CONN00-FLDATE'
*            STEPL               = 0
            value               = ' '
*            MULTIPLE_CHOICE     = ' '
*            DISPLAY             = ' '
*            SUPPRESS_RECORDLIST = ' '
            callback_program    =  repid
            callback_form       = 'SHL_IF_FORM'
*       TABLES
*            RETURN_TAB          =
*       EXCEPTIONS
*            FIELD_NOT_FOUND     = 1
*            NO_HELP_FOR_FIELD   = 2
*            INCONSISTENT_HELP   = 3
*            NO_VALUES_FOUND     = 4
*            OTHERS              = 5
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDMODULE.                             " CALL_SHL  INPUT
