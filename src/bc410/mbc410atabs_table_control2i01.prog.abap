*----------------------------------------------------------------------*
***INCLUDE MBC410ADIAS_DYNPROI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  check_sflight  INPUT
*&---------------------------------------------------------------------*
*       Read flight record from database
*----------------------------------------------------------------------*
MODULE check_sflight INPUT.
  SELECT SINGLE *
    FROM sflight
* INTO CORRESPONDING FIELDS OF sdyn_conn 	" direct read
    INTO wa_sflight         " Read into internal structure
    WHERE carrid = sdyn_conn-carrid AND
          connid = sdyn_conn-connid AND
          fldate = sdyn_conn-fldate.
  CHECK sy-subrc <> 0.
  CLEAR wa_sflight.
  MESSAGE e007(bc410).

ENDMODULE.                 " check_sflight  INPUT
*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       process user command
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'FC1' OR 'FC2' OR 'FC3'.
      my_tabstrip-activetab = ok_code.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

* display time on add'l screen
    WHEN 'TIME'.
      CALL SCREEN 150
        STARTING AT 10 10
        ENDING   AT 50 20.

* save changes to database
    WHEN 'SAVE'.
      UPDATE sflight
      FROM wa_sflight.
      IF sy-subrc <> 0.
        MESSAGE a008(bc410).
      ENDIF.
      MESSAGE s009(bc410).

  ENDCASE.
ENDMODULE.                 " user_command_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  exit  INPUT
*&---------------------------------------------------------------------*
*       process EXIT functions (type 'E')
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.
      CLEAR: wa_sflight,
             sdyn_conn,
             saplane.
      SET PARAMETER ID:
        'CAR' FIELD wa_sflight-carrid,
        'CON' FIELD wa_sflight-connid,
        'DAY' FIELD wa_sflight-fldate.
      LEAVE TO SCREEN 100.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " exit  INPUT
*&---------------------------------------------------------------------*
*&      Module  check_planetype  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_planetype INPUT.
  IF sdyn_conn-planetype IS INITIAL.
    MESSAGE e555(bc410) WITH 'Plane type needed'(plt).
  ENDIF.

  SELECT SINGLE seatsmax
    FROM saplane
    INTO sdyn_conn-seatsmax
    WHERE planetype = sdyn_conn-planetype.

  IF sdyn_conn-seatsocc > sdyn_conn-seatsmax.
    MESSAGE e109(bc410).
*   Number of seats booked exceeds aircraft capacity
  ELSE.
    MOVE-CORRESPONDING sdyn_conn TO wa_sflight.
  ENDIF.

ENDMODULE.                 " check_planetype  INPUT
*&---------------------------------------------------------------------*
*&      Module  trans_from_tc  INPUT
*&---------------------------------------------------------------------*
*       copy booking data from TABLES structure to work area
*       and modify internal table
*----------------------------------------------------------------------*
MODULE trans_from_tc INPUT.
  MOVE sdyn_book-mark TO wa_sdyn_book-mark.
  MODIFY it_sdyn_book INDEX my_table_control-current_line
  FROM wa_sdyn_book TRANSPORTING mark.
ENDMODULE.                 " trans_from_tc  INPUT
*&---------------------------------------------------------------------*
*&      Module  user_command_0130  INPUT
*&---------------------------------------------------------------------*
*       process commands from subscreen 0130
*----------------------------------------------------------------------*
MODULE user_command_0130 INPUT.
  CASE ok_code.
    WHEN 'SELE'.
      LOOP AT it_sdyn_book INTO wa_sdyn_book
        WHERE mark = space.
        wa_sdyn_book-mark = 'X'.
        MODIFY it_sdyn_book FROM wa_sdyn_book TRANSPORTING mark.
      ENDLOOP.
    WHEN 'DSELE'.
      LOOP AT it_sdyn_book INTO wa_sdyn_book
        WHERE mark = 'X'.
        wa_sdyn_book-mark = space.
        MODIFY it_sdyn_book FROM wa_sdyn_book TRANSPORTING mark.
      ENDLOOP.
    WHEN 'SRTU'.
      READ TABLE my_table_control-cols INTO wa_cols
        WITH KEY selected = 'X'.
      IF sy-subrc = 0.
        SORT it_sdyn_book
          BY (wa_cols-screen-name+10) ASCENDING.
      ENDIF.
    WHEN 'SRTD'.
      READ TABLE my_table_control-cols INTO wa_cols
        WITH KEY selected = 'X'.
      IF sy-subrc = 0.
        SORT it_sdyn_book
          BY (wa_cols-screen-name+10) DESCENDING.
      ENDIF.  ENDCASE.
ENDMODULE.                 " user_command_0130  INPUT
