*----------------------------------------------------------------------*
***INCLUDE BC414S_CREATE_CUSTOMER_02F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  NUMBER_GET_NEXT
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*      -->P_WA_SCUSTOM  text
*----------------------------------------------------------------------*
FORM number_get_next USING p_scustom LIKE scustom.
  DATA: return TYPE inri-returncode.
  CALL FUNCTION 'NUMBER_GET_NEXT'
       EXPORTING
            nr_range_nr = '01'
            object      = 'SBUSPID'
       IMPORTING
            number      = p_scustom-id
            returncode  = return
       EXCEPTIONS
            OTHERS      = 1.
  CASE sy-subrc.
    WHEN 0.
      CASE return.
        WHEN 1.
          MESSAGE s070.
        WHEN 2.
          MESSAGE s071.
        WHEN 3.
          MESSAGE a072.
      ENDCASE.
    WHEN 1.
      MESSAGE a073 WITH sy-subrc.
  ENDCASE.
ENDFORM.                               " NUMBER_GET_NEXT

*&---------------------------------------------------------------------*
*&      Form  ASK_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ANSWER  text
*----------------------------------------------------------------------*
FORM ask_save USING p_answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
       EXPORTING
            textline1 = 'Data has been changed.'(001)
            textline2 = 'Save before leaving transaction?'(002)
            titel     = 'Create Customer'(003)
       IMPORTING
            answer    = p_answer.
ENDFORM.                               " ASK_SAVE

*&---------------------------------------------------------------------*
*&      Form  ASK_LOSS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ANSWER  text
*----------------------------------------------------------------------*
FORM ask_loss USING p_answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM_LOSS_OF_DATA'
       EXPORTING
            textline1 = 'Continue?'(004)
            titel     = 'Create Customer'(003)
       IMPORTING
            answer    = p_answer.
ENDFORM.                               " ASK_LOSS

*&---------------------------------------------------------------------*
*&      Form  ENQ_SCUSTOM
*&---------------------------------------------------------------------*
FORM enq_scustom.
  CALL FUNCTION 'ENQUEUE_ESCUSTOM'
       EXPORTING
            id             = scustom-id
       EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
  CASE sy-subrc.
    WHEN 0.
    WHEN 1.
      MESSAGE e060.
    WHEN OTHERS.
      MESSAGE e063 WITH sy-subrc.
  ENDCASE.
ENDFORM.                               " ENQ_SCUSTOM

*&---------------------------------------------------------------------*
*&      Form  DEQ_ALL
*&---------------------------------------------------------------------*
FORM deq_all.
  CALL FUNCTION 'DEQUEUE_ALL'.
ENDFORM.                               " DEQ_ALL

*&---------------------------------------------------------------------*
*&      Form  SAVE
*&---------------------------------------------------------------------*
FORM save.
* get new number for SCUSTOM-ID
  PERFORM number_get_next USING scustom.
* lock dataset
  PERFORM enq_scustom.
* save new customer
  PERFORM save_scustom.
* unlock dataset
  PERFORM deq_all.
ENDFORM.                               " SAVE

*&---------------------------------------------------------------------*
*&      Form  SAVE_SCUSTOM
*&---------------------------------------------------------------------*
FORM save_scustom.
  INSERT INTO scustom VALUES scustom.
  IF sy-subrc <> 0.
    MESSAGE a048.
  ELSE.
    MESSAGE s015 WITH scustom-id.
  ENDIF.
ENDFORM.                               " SAVE_SCUSTOM
