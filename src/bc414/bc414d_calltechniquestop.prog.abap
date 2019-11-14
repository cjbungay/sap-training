*&---------------------------------------------------------------------*
*& Include BC414D_CALLTECHNIQUESTOP                                    *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  SAPBC414D_CALLTECHNIQUES      .
* Screen fields
* User code processing
DATA:  OK_CODE      type sy-ucomm,
       save_ok_code like ok_code.

* radio buttons
Data:
*  group 1
      submit_1,  " SUBMIT
      submit_2,  " SUBMIT VIA SELECTION-SCREEN
      submit_3,  " SUBMIT AND RETURN
      submit_4,  " SUBMIT VIA SELECTION-SCREEN AND RETURN
*  group 2
      leave_1,   " LEAVE TO TRANSACTION
      leave_2,   " LEAVE TO TRANSACTION AND SKIP FIRST SCREEN
      call_1,    " CALL TRANSACTION
      call_2.    " CALL TRANSACTION AND SKIP FIRST SCREEN

* costants
constants:
      c_marked value 'X'.
