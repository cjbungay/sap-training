*&---------------------------------------------------------------------*
*& Report  SAPBC400TCD_ENQUEUE_DEQUEUE                                 *
*&---------------------------------------------------------------------*

REPORT  sapbc400tcd_enqueue_dequeue  MESSAGE-ID bc400.

CONSTANTS: actvt_display TYPE activ_auth VALUE '03',
           actvt_change TYPE activ_auth VALUE '02'.

TABLES  sdyn_conn.

DATA: ok_code LIKE sy-ucomm,
      wa_spfli LIKE spfli.



START-OF-SELECTION.

  SET PF-STATUS 'LIST'.

  SELECT carrid connid airpfrom cityfrom airpto cityto
         FROM spfli
         INTO CORRESPONDING FIELDS OF wa_spfli.

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
    ELSE.
      WRITE / 'Missing authority for current entry !'.
    ENDIF.

  ENDSELECT.

  CLEAR wa_spfli.



AT LINE-SELECTION.

  CHECK NOT wa_spfli-carrid IS INITIAL.
  CHECK sy-lsind = 1.

* authority check
  AUTHORITY-CHECK OBJECT 'S_CARRID'
           ID 'CARRID' FIELD wa_spfli-carrid
           ID 'ACTVT' FIELD actvt_change.

  IF sy-subrc NE 0.
    MESSAGE e047(bc400) WITH wa_spfli-carrid.
  ENDIF.

  CALL FUNCTION 'ENQUEUE_ESSPFLI'
       EXPORTING
            carrid         = wa_spfli-carrid
            connid         = wa_spfli-connid
       EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.

  IF sy-subrc <> 0.
    MESSAGE ID     sy-msgid
            TYPE   sy-msgty
            NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  SELECT SINGLE * FROM spfli
                  INTO wa_spfli
                  WHERE carrid = wa_spfli-carrid
                   AND  connid = wa_spfli-connid.

  IF sy-subrc NE 0.
    MESSAGE e007(bc400).
  ENDIF.

  MOVE-CORRESPONDING wa_spfli TO sdyn_conn.

  CALL SCREEN 100.

  CALL FUNCTION 'DEQUEUE_ESSPFLI'
       EXPORTING
            mode_spfli = 'E'
            mandt      = sy-mandt
            carrid     = wa_spfli-carrid
            connid     = wa_spfli-connid.

  CLEAR wa_spfli-carrid.



*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT                               *
*&---------------------------------------------------------------------*
*       setting follow-up dynpro dynamically                           *
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 0.
    WHEN 'SAVE'.
      MOVE-CORRESPONDING sdyn_conn TO wa_spfli.
      CALL FUNCTION 'BC400_UPDATE_FLTIME'
           EXPORTING
                iv_carrid             = wa_spfli-carrid
                iv_connid             = wa_spfli-connid
                iv_fltime             = wa_spfli-fltime
                iv_deptime            = wa_spfli-deptime
           EXCEPTIONS
                flight_not_found      = 1
                update_spfli_rejected = 1
                flight_locked         = 1
                OTHERS                = 1.
      IF sy-subrc NE 0.
        MESSAGE a149(bc400).
      ELSE.
        MESSAGE s148(bc400).
        SET SCREEN 0.
      ENDIF.
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
*&      Module  CLEAR_OK_CODE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                             " CLEAR_OK_CODE  INPUT
