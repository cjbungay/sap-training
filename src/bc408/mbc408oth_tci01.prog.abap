*----------------------------------------------------------------------*
***INCLUDE MBC408OTH_TCI01
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'FC1' OR 'FC2' OR 'FC3'.
      my_tabstrip-activetab = ok_code.
    WHEN 'MODE'.
      IF mode-view IS INITIAL.
        AUTHORITY-CHECK OBJECT 'S_CARRID'
                 ID 'CARRID' FIELD wa_sflight-carrid
                 ID 'ACTVT' FIELD '02'.
        IF sy-subrc NE 0.
          MESSAGE e045 WITH wa_sflight-carrid.
*   Keine Berechtigung für Fluggesellschaft &
        ENDIF.
      ENDIF.
    WHEN 'SAVE'.
      PERFORM update_sflight.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  trans_from_dynp  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_dynp INPUT.
  MOVE-CORRESPONDING sdyn_conn TO wa_sflight.
ENDMODULE.                             " trans_from_dynp  INPUT
*&---------------------------------------------------------------------*
*&      Module  check_sflight  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_sflight INPUT.
  CHECK sdyn_conn-carrid NE wa_sflight-carrid
     OR sdyn_conn-connid NE wa_sflight-connid
     OR sdyn_conn-fldate NE wa_sflight-fldate
* New value for seatsocc in case of booking cancelation
     OR bookings_changed = 'X'.
  SELECT SINGLE * INTO CORRESPONDING FIELDS OF sdyn_conn FROM sflight
    WHERE carrid = sdyn_conn-carrid
      AND connid = sdyn_conn-connid
      AND fldate = sdyn_conn-fldate.
  CHECK sy-subrc NE 0.
  MESSAGE e007.
*   Tabelleneintrag zum eingegebenen Schlüssel ist nicht vorhanden
ENDMODULE.                             " check_sflight  INPUT
*&---------------------------------------------------------------------*
*&      Module  exit  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      CLEAR wa_sflight.
      LEAVE TO SCREEN 100.
  ENDCASE.
ENDMODULE.                             " exit  INPUT
*&---------------------------------------------------------------------*
*&      Module  check_planetype  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_planetype INPUT.
  SELECT SINGLE seatsmax INTO sdyn_conn-seatsmax FROM saplane
  WHERE planetype = sdyn_conn-planetype.
  CHECK sdyn_conn-seatsmax < sdyn_conn-seatsocc.
  MESSAGE e109(bc410).
ENDMODULE.                             " check_planetype  INPUT
*&---------------------------------------------------------------------*
*&      Module  trans_from_tc  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE trans_from_tc INPUT.
  MOVE sdyn_book-mark TO wa_sdyn_book-mark.
  MODIFY it_sdyn_book INDEX my_table_control-current_line
  FROM wa_sdyn_book TRANSPORTING mark.
ENDMODULE.                             " trans_from_tc  INPUT


*&---------------------------------------------------------------------*
*&      Module  user_command_0130  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0130 INPUT.
  CASE ok_code.
    WHEN 'P++' OR 'P+' OR 'P-' OR 'P--'.
      CALL FUNCTION 'SCROLLING_IN_TABLE'
        EXPORTING
          entry_act                   = my_table_control-top_line
          entry_to                    = my_table_control-lines
          loops                       = loopc            "#EC DOM_EQUAL
          ok_code                     = ok_code
       IMPORTING
          entry_new                   = my_table_control-top_line
        EXCEPTIONS
          OTHERS                      = 4
                .
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

    WHEN 'SRTU'.
      READ TABLE my_table_control-cols INTO wa_cols
                                       WITH KEY selected = 'X'.
      IF sy-subrc = 0.
        SORT it_sdyn_book BY (wa_cols-screen-name+10) ASCENDING.
      ENDIF.
*  second method
*     LOOP AT MY_TABLE_CONTROL-COLS INTO WA_COLS WHERE SELECTED = 'X'.
*       SORT IT_SDYN_BOOK BY (WA_COLS-SCREEN-NAME+10) ASCENDING.
*     ENDLOOP.

* determine fieldname dynamically
* 1. 'slower' version
*         DATA SORTFIELD LIKE SCREEN-NAME.
*         IF WA_COLS-SCREEN-NAME CS '-'.
*            POS = SY-FDPOS + 1.
*            SORTFIELD = TC_COL-SCREEN-NAME+POS.
*            SORT IT_SDYN_BOOK BY (SORTFIELD).
*         ENDIF.
* 2. 'faster' version
*         FIELD_SYMBOLS <sort_field>.
*         IF WA_COLS-SCREEN-NAME CS '-'.
*            POS = SY-FDPOS + 1.
*            ASSIGN WA_COLS-SCREEN-NAME+POS(*) TO <SORT_FIELD>.
*            SORT IT_SDYN_BOOK BY (<SORT_FIELD>).
*         ENDIF.
    WHEN 'SRTD'.

      READ TABLE my_table_control-cols INTO wa_cols
                                       WITH KEY selected = 'X'.
      IF sy-subrc = 0.
        SORT it_sdyn_book BY (wa_cols-screen-name+10) DESCENDING.
      ENDIF.
    WHEN 'DELE'.
      PERFORM cancel_bookings.
    WHEN 'SELE'.
      LOOP AT it_sdyn_book INTO wa_sdyn_book WHERE mark = space.
        wa_sdyn_book-mark = 'X'.
        MODIFY it_sdyn_book FROM wa_sdyn_book TRANSPORTING mark.
      ENDLOOP.
    WHEN 'DSELE'.
      LOOP AT it_sdyn_book INTO wa_sdyn_book WHERE mark = 'X'.
        wa_sdyn_book-mark = space.
        MODIFY it_sdyn_book FROM wa_sdyn_book TRANSPORTING mark.
      ENDLOOP.
  ENDCASE.
ENDMODULE.                             " user_command_0130  INPUT
