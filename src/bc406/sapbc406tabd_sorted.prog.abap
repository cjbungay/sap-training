*&---------------------------------------------------------------------*
*& Report  SAPBC406TABD_SORTED                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*& copies the content of database table SFLIGHT into a sorted table,   *
*& modifies some data sets and updates the database table afterwards   *
*& only "quick and dirty"-dialogs                                      *
*&---------------------------------------------------------------------*



REPORT  sapBC406tabd_sorted.

* for user-dialog:
******************
DATA:
  ok_code LIKE sy-ucomm,
  save_ok LIKE ok_code,
  pop_ans.

TABLES sdyn_conn.



TYPES:
  t_flight TYPE sflight,

  t_flight_list TYPE SORTED TABLE OF t_flight
                WITH UNIQUE KEY carrid
                                connid
                                fldate.

DATA:
  wa_flight   TYPE t_flight,
  flight_list TYPE t_flight_list.





*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET TITLEBAR 'T100'.
  CLEAR wa_flight-price.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.

* display list:
***************
    WHEN 'DISP'.
      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 30.

* add another flight date:
**************************
    WHEN 'ADD_DATE'.
      CLEAR wa_flight.
      MOVE-CORRESPONDING sdyn_conn TO wa_flight.
      wa_flight-mandt    = sy-mandt.
      INSERT wa_flight INTO TABLE flight_list.

      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 30.

* set a new price:
******************
    WHEN 'NEW_PRICE'.
      CLEAR wa_flight.
      MOVE-CORRESPONDING sdyn_conn TO wa_flight.
      MODIFY flight_list FROM wa_flight TRANSPORTING price currency
                         WHERE carrid = wa_flight-carrid
                         AND   connid = wa_flight-connid.

      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 30.

* ask whether to save and exit:
*******************************
    WHEN 'EXIT'.
      CLEAR pop_ans.
      CALL FUNCTION 'POPUP_TO_CONFIRM_LOSS_OF_DATA'
           EXPORTING
                textline1 = 'Do you want to save?'(sav)
                titel     = 'Close program!'(cls)
           IMPORTING
                answer    = pop_ans.
      IF pop_ans = 'J'.
        MODIFY sflight FROM TABLE flight_list.
      ENDIF.

      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS space.
  SET TITLEBAR 'T200'.
ENDMODULE.                             " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  DISPLAY_LIST_0200  OUTPUT
*&---------------------------------------------------------------------*
MODULE display_list_0200 OUTPUT.
  SUPPRESS DIALOG.
  LEAVE TO LIST-PROCESSING AND RETURN TO SCREEN 0.
  LOOP AT flight_list INTO wa_flight.
    WRITE: / wa_flight-carrid,
             wa_flight-connid,
             wa_flight-fldate,
             wa_flight-price CURRENCY wa_flight-currency,
             wa_flight-currency,
             wa_flight-seatsocc.
  ENDLOOP.
ENDMODULE.                             " DISPLAY_LIST_0200  OUTPUT

LOAD-OF-PROGRAM.
  SELECT * FROM sflight
           INTO CORRESPONDING FIELDS OF TABLE flight_list.
