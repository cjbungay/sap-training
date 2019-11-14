*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_EXAMPLE_E                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&   Setting the user interface of the program                         *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_example_e MESSAGE-ID bc400.

CONSTANTS: actvt_display TYPE activ_auth VALUE '03',
           actvt_change  TYPE activ_auth VALUE '02'.

* Workarea for the screen
TABLES  sdyn_conn.

DATA: ok_code LIKE sy-ucomm,
      wa_spfli LIKE spfli.


START-OF-SELECTION.

  SET PF-STATUS 'LIST'.

  SELECT carrid connid airpfrom cityfrom airpto cityto
         INTO CORRESPONDING FIELDS OF wa_spfli
         FROM spfli.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
             ID 'CARRID' FIELD wa_spfli-carrid
             ID 'ACTVT'  FIELD actvt_display.

    IF sy-subrc = 0.
      WRITE: / wa_spfli-carrid COLOR COL_KEY,
               wa_spfli-connid COLOR COL_KEY,
               wa_spfli-airpfrom COLOR COL_NORMAL,
               wa_spfli-cityfrom COLOR COL_NORMAL,
               wa_spfli-airpto COLOR COL_NORMAL,
               wa_spfli-cityto COLOR COL_NORMAL.
*     Buffering key fields
      HIDE: wa_spfli-carrid, wa_spfli-connid.
    ENDIF.

  ENDSELECT.

  CLEAR wa_spfli.


AT LINE-SELECTION.

  IF sy-lsind = 1.

    AUTHORITY-CHECK OBJECT 'S_CARRID'
          ID 'CARRID' FIELD wa_spfli-carrid
          ID 'ACTVT'  FIELD actvt_change.

    IF sy-subrc = 0.

      CHECK NOT wa_spfli-carrid IS INITIAL.

      SELECT SINGLE * FROM spfli
                      INTO wa_spfli
                      WHERE carrid = wa_spfli-carrid
                       AND  connid = wa_spfli-connid.

      MOVE-CORRESPONDING wa_spfli TO sdyn_conn.

      CALL SCREEN 100.

      CLEAR wa_spfli.

    ENDIF.

  ENDIF.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT                               *
*&---------------------------------------------------------------------*
*       setting follow-up dynpro dynamically                           *
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.

    WHEN 'BACK'.
      MESSAGE s057(bc400).
      SET SCREEN 0.

    WHEN 'SAVE'.
      MOVE-CORRESPONDING sdyn_conn TO wa_spfli.

*     calling a function module to save changes to the database

      SET SCREEN 0.
      MESSAGE s058(bc400).

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT                                    *
*&---------------------------------------------------------------------*
*       text                                                           *
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'SCREEN'.
  SET TITLEBAR '100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  CLEAR_OK_CODE  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                             " CLEAR_OK_CODE  INPUT
