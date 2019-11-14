*&---------------------------------------------------------------------*
*& Report  SAPBC406CALT_CONN                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
*& a "quick-and-dirty"-dialog to call some other programs              *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapBC406calt_conn MESSAGE-ID BC406.

TABLES sdyn_conn.

DATA:
  ok_code LIKE sy-ucomm,
  save_ok LIKE ok_code.


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET TITLEBAR 'NAVI'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.
    WHEN 'DETL'.
      SELECT SINGLE countryfr cityfrom countryto cityto
                    distance distid fltime
                    FROM spfli
                    INTO CORRESPONDING FIELDS OF sdyn_conn
                    WHERE carrid = sdyn_conn-carrid
                    AND   connid = sdyn_conn-connid.
      IF sy-subrc <> 0.
        MESSAGE e107 WITH sdyn_conn-carrid sdyn_conn-connid.
      ELSE.
        SET SCREEN 200.
      ENDIF.

    WHEN 'EXIT'.
      LEAVE PROGRAM.

    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT


*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET TITLEBAR 'DET'.
ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.
    WHEN 'COORDFR'.

    WHEN 'COORDTO'.

    WHEN 'DATE'.


    WHEN 'BACK'.
      SET SCREEN 100.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0200  INPUT
