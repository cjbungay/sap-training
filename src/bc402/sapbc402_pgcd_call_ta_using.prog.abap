*&---------------------------------------------------------------------*
*& Report  SAPBC402_PGCD_CALL_TA_USING                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*& creates and maintains a waiting list                                *
*& (only "quick and dirty"-dialogs!)                                   *
*& calls a transaction using bdcdata-itab                              *
*&---------------------------------------------------------------------*

REPORT  sapbc402_cald_call_ta_using.

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
  popans.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'ST100'.
  SET TITLEBAR 'T100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  status_0150  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0150 OUTPUT.
  SET PF-STATUS 'ST150'.
  SET TITLEBAR 'T150'.
ENDMODULE.                 " status_0150  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE trans_to_0100 OUTPUT.
  MOVE-CORRESPONDING wa_cust TO scustom.
ENDMODULE.                             " TRANS_TO_0100  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  clear_scustom_150  OUTPUT
*&---------------------------------------------------------------------*
MODULE clear_scustom_150 OUTPUT.
  CLEAR scustom.
ENDMODULE.                 " clear_scustom_150  OUTPUT



*&---------------------------------------------------------------------*
*&      Module  leave_programm  INPUT
*&---------------------------------------------------------------------*
*       handle interface exit commands
*----------------------------------------------------------------------*
MODULE leave INPUT.

  CASE ok_code.
    WHEN 'CANCEL'.

      CLEAR popans.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
        EXPORTING
          textline1      = text-dml
          textline2      = text-rcn
          titel          = text-cnc
          cancel_display = ' '
        IMPORTING
          answer         = popans.
      CASE popans.
        WHEN 'J'.
          LEAVE PROGRAM.
        WHEN 'N'.
          CLEAR ok_code.
      ENDCASE.

  ENDCASE.

ENDMODULE.                    "leave_program INPUT


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
*&      Module  trans_from_150  INPUT
*&---------------------------------------------------------------------*
MODULE trans_from_150 INPUT.
  MOVE-CORRESPONDING scustom TO wa_cust.
ENDMODULE.                 " trans_from_150  INPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      CLEAR popans.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
        EXPORTING
          textline1      = text-dml
          textline2      = text-rbk
          titel          = text-bak
          cancel_display = ' '
        IMPORTING
          answer         = popans.
      IF popans = 'J'.
        LEAVE TO SCREEN 0.
      ENDIF.

    WHEN 'EXIT'.
      CLEAR popans.
      CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
        EXPORTING
          textline1      = text-dml
          textline2      = text-rex
          titel          = text-ext
          cancel_display = ' '
        IMPORTING
          answer         = popans.
      IF popans = 'J'.
        LEAVE PROGRAM.
      ENDIF.



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
      IF sy-subrc <> 0.
        MESSAGE i232(bc401).
      ENDIF.
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
        MESSAGE s233(bc401).
      ELSE.
        MESSAGE i230(bc401).           "no waiters
      ENDIF.

* get position of a waiting customer:
*************************************
    WHEN 'POS'.
      READ TABLE wait_list FROM wa_cust
                           TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        position = sy-tabix.
        MESSAGE i231(bc401) WITH position.
      ELSE.
        MESSAGE i232(bc401).
      ENDIF.

* move a waiting customer:
**************************
    WHEN 'SHIFT'.
      READ TABLE wait_list FROM wa_cust INTO wa_cust.
      IF sy-subrc = 0.
        DELETE wait_list INDEX sy-tabix.
        INSERT wa_cust INTO wait_list INDEX new_pos.
        CALL SCREEN 200 STARTING AT   5  5
                        ENDING   AT 120 20.
      ELSE.
        MESSAGE i232(bc401).
      ENDIF.

* display the waiting list:
***************************
    WHEN 'SHOW'.
      CALL SCREEN 200 STARTING AT   5  5
                      ENDING   AT 120 20.

    WHEN 'NEW'.
      CALL SCREEN 150 STARTING AT  5  5
                      ENDING   AT 60 10.

  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0100  INPUT


*&---------------------------------------------------------------------*
*&      Module  user_command_0150  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0150 INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN 'CREATE'.
*     create a new entry for a customer (database table!)
*     ****************************************************
      PERFORM create_customer USING wa_cust.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                 " user_command_0150  INPUT


*&---------------------------------------------------------------------*
*&      Module  clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*       initialize command input field for screen
*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT

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



*&---------------------------------------------------------------------*
*&      Form  CREATE_CUSTOMER
*&---------------------------------------------------------------------*
*       calls a transaction using an internal bdcdata table
*----------------------------------------------------------------------*
*      -->P_WA_CUST  customer data to create
*----------------------------------------------------------------------*
FORM create_customer USING value(p_wa_cust) LIKE wa_cust.

  DATA:
    wa_bdcdata TYPE bdcdata,
    it_bdcdata LIKE TABLE OF wa_bdcdata.

* fill the bdcdata table:
*************************
  wa_bdcdata-program  = 'SAPBC402_CALD_CREATE_CUSTOMER'.
  wa_bdcdata-dynpro   = 100.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO it_bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = 'SCUSTOM-NAME'.
  wa_bdcdata-fval = p_wa_cust-name.
  APPEND wa_bdcdata TO it_bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = 'SCUSTOM-CITY'.
  wa_bdcdata-fval = p_wa_cust-city.
  APPEND wa_bdcdata TO it_bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = 'BDC_OKCODE'.
  wa_bdcdata-fval = 'SAVE'.
  APPEND wa_bdcdata TO it_bdcdata.

  CALL TRANSACTION 'BC402_CALD_CRE_CUST'
                   USING it_bdcdata
                   MODE 'N'.
  IF sy-subrc <> 0.
    MESSAGE i510(bc401) WITH 'BC402_CALD_CRE_CUS' sy-subrc.
  ENDIF.
ENDFORM.                               " CREATE_CUSTOMER
