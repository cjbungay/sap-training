*&---------------------------------------------------------------------*
*& Report  SAPBC402_TABD_STANDARD                                      *
*&                                                                     *
*&---------------------------------------------------------------------*
*& creates and maintains a waiting list                                *
*& (only "quick and dirty"-dialogs!)                                   *
*&---------------------------------------------------------------------*

REPORT  sapbc402_tabd_standard.

DATA:
  BEGIN OF wa_cust,
    id       TYPE scustom-id,
    name     TYPE scustom-name,
    street   TYPE scustom-street,
    city     TYPE scustom-city,
    app_date TYPE sy-datum,
  END OF wa_cust,

  wait_list LIKE STANDARD TABLE OF wa_cust
            WITH NON-UNIQUE KEY id.


* for user dialog:
******************
TABLES scustom.

DATA:
  position TYPE i,
  new_pos  TYPE i.

DATA:
  ok_code TYPE sy-ucomm,
  save_ok LIKE ok_code.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET TITLEBAR 'T100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE trans_to_0100 OUTPUT.
  MOVE-CORRESPONDING wa_cust TO scustom.
ENDMODULE.                             " TRANS_TO_0100  OUTPUT




*&---------------------------------------------------------------------*
*&      Module  TRANS_FROM_0100  INPUT
*&---------------------------------------------------------------------*
*&      database access necessary to avoid inconsistent customer data
*&---------------------------------------------------------------------*
MODULE trans_from_0100 INPUT.
  SELECT SINGLE id name city FROM scustom
                             INTO CORRESPONDING FIELDS OF wa_cust
                             WHERE id = scustom-id.
ENDMODULE.                             " TRANS_FROM_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.

* add a waiting customer:
*************************
    WHEN 'ADD'.
      APPEND wa_cust TO wait_list.
      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 20.

* delete a waiting customer:
****************************
    WHEN 'DEL'.
      DELETE wait_list WHERE id = wa_cust-id.
      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 20.

* delete customers who have been waiting too long:
**************************************************
    WHEN 'DELNT'.
      DELETE wait_list WHERE app_date < sy-datum.
      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 20.

* get the first waiting customer:
*********************************
    WHEN 'FIRST'.
      CLEAR wa_cust.
      READ TABLE wait_list INTO wa_cust INDEX 1.
      IF sy-subrc = 0.
        DELETE wait_list INDEX 1.
      ELSE.
        MESSAGE i200(bc402).           "no waiters
      ENDIF.

* get position of a waiting customer:
*************************************
    WHEN 'POS'.
      READ TABLE wait_list FROM wa_cust
                           TRANSPORTING NO FIELDS.
      position = sy-tabix.
      MESSAGE i201(bc402) WITH position.

* move a waiting customer:
**************************
    WHEN 'SHIFT'.
      READ TABLE wait_list FROM wa_cust INTO wa_cust.
      DELETE wait_list INDEX sy-tabix.
      INSERT wa_cust INTO wait_list INDEX new_pos.
      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 20.

* display the waiting list:
***************************
    WHEN 'SHOW'.
      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 20.

    WHEN 'EXIT'.
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
  LOOP AT wait_list INTO wa_cust.
    WRITE: / wa_cust-id,
             wa_cust-name,
             wa_cust-city,
             wa_cust-app_date.
  ENDLOOP.
  IF sy-subrc <> 0.
    WRITE 'The list is empty.'(emp).
  ENDIF.
ENDMODULE.                             " DISPLAY_LIST_0200  OUTPUT



