*----------------------------------------------------------------------*
***INCLUDE BC414S_BOOKINGS_06F01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  COLLECT_MODIFIED_DATA
*&---------------------------------------------------------------------*
*      -->P_ITAB_SBOOK_MODIFY  text
*----------------------------------------------------------------------*
FORM collect_modified_data USING p_itab_sbook_modify
                                 LIKE itab_sbook_modify.
  DATA: wa_book LIKE LINE OF itab_book,
        wa_sbook_modify LIKE LINE OF p_itab_sbook_modify.
  CLEAR: p_itab_sbook_modify.
  LOOP AT itab_book INTO wa_book
       WHERE    mark = 'X'
       AND cancelled = 'X'.
    MOVE-CORRESPONDING wa_book TO wa_sbook_modify.
    APPEND wa_sbook_modify TO p_itab_sbook_modify.
  ENDLOOP.
ENDFORM.                               " COLLECT_MODIFIED_DATA

*&---------------------------------------------------------------------*
*&      Form  INITIALIZE_SBOOK
*&---------------------------------------------------------------------*
*      -->P_WA_SBOOK  text
*----------------------------------------------------------------------*
FORM initialize_sbook USING p_wa_sbook TYPE sbook.
  CLEAR p_wa_sbook.
  MOVE-CORRESPONDING wa_sflight TO p_wa_sbook.
  move: wa_sflight-price    to p_wa_sbook-forcuram,
        wa_sflight-currency to p_wa_sbook-forcurkey,
        sy-datum            to p_wa_sbook-order_date.
ENDFORM.                               " INITIALIZE_SBOOK

*&---------------------------------------------------------------------*
*&      Form  PROCESS_SYSUBRC_BOOKC
*&---------------------------------------------------------------------*
FORM process_sysubrc_bookc.
  CASE sysubrc.
    WHEN 0.
      SET SCREEN '0200'.
    WHEN OTHERS.
      PERFORM deq_all.
      MESSAGE e023 WITH sdyn_conn-carrid sdyn_conn-connid
                        sdyn_conn-fldate.
  ENDCASE.
ENDFORM.                               " PROCESS_SYSUBRC_BOOKC

*&---------------------------------------------------------------------*
*&      Form  PROCESS_SYSUBRC_BOOKN
*&---------------------------------------------------------------------*
FORM process_sysubrc_bookn.
  CASE sysubrc.
    WHEN 0.
      SET SCREEN '0300'.
    WHEN OTHERS.
* remove all database locks
      PERFORM deq_all.
      MESSAGE e023 WITH sdyn_conn-carrid sdyn_conn-connid
                        sdyn_conn-fldate.
  ENDCASE.
ENDFORM.                               " PROCESS_SYSUBRC_BOOKN

*&---------------------------------------------------------------------*
*&      Form  TABSTRIP_SET
*&---------------------------------------------------------------------*
FORM tabstrip_set.
  IF save_ok = 'BOOK' OR save_ok = 'DETCON' OR save_ok = 'DETFLT'
  OR save_ok = 'SPECIALS' .
    tab-activetab = save_ok.
  ENDIF.
  CASE save_ok.
    WHEN 'BOOK'.
      screen_no = '0301'.
    WHEN 'DETCON'.
      screen_no = '0302'.
    WHEN 'DETFLT'.
      screen_no = '0303'.
    WHEN 'SPECIALS'.
      screen_no = '0304'.
  ENDCASE.
ENDFORM.                               " TABSTRIP_SET

*&---------------------------------------------------------------------*
*&      Form  CREATE_NEW_CUSTOMER
*&---------------------------------------------------------------------*
FORM create_new_customer.
   CALL TRANSACTION 'BC414S_CREATE_CUST'.
   GET PARAMETER ID 'CSM' field wa_sbook-customid.
* alternative solution using the GET function of
* the screen field for customer ID
*  CLEAR wa_sbook-customid.
ENDFORM.                               " CREATE_NEW_CUSTOMER

*&---------------------------------------------------------------------*
*&      Form  NUMBER_GET_NEXT
*&---------------------------------------------------------------------*
FORM number_get_next USING p_wa_sbook LIKE sbook.
  DATA: return TYPE inri-returncode.
* get next free number in the number range '01' of number object
* 'SBOOKID'
  CALL FUNCTION 'NUMBER_GET_NEXT'
       EXPORTING
            nr_range_nr = '01'
            object      = 'SBOOKID'
            subobject   = p_wa_sbook-carrid
            toyear      = p_wa_sbook-order_date(4)
       IMPORTING
            number      = p_wa_sbook-bookid
            returncode  = return
       EXCEPTIONS
            OTHERS      = 1.
  CASE sy-subrc.
    WHEN 0.
      CASE return.
        WHEN 1.
* number of remaining numbers critical
          MESSAGE s070.
        WHEN 2.
* last number
          MESSAGE s071.
        WHEN 3.
* no free number left over
          MESSAGE a072.
      ENDCASE.
    WHEN 1.
* internal error
      MESSAGE a073 WITH sy-subrc.
  ENDCASE.
ENDFORM.                               " NUMBER_GET_NEXT
