*----------------------------------------------------------------------*
***INCLUDE BC401_CALD_CREATE_CUSTOMERI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  NUMBER_GET_NEXT
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*      -->P_WA_SCUSTOM  text
*----------------------------------------------------------------------*
FORM number_get_next USING p_scustom LIKE scustom.
  DATA: return TYPE inri-returncode.
* get next free number in the number range '01'
* of number object'BC_SCUSTOM'
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
    WHEN 1.
* dataset allready locked
      MESSAGE e090.
    WHEN 2 OR 3.
* locking of dataset not possible for other reasons
      MESSAGE e093 WITH sy-subrc.
  ENDCASE.
ENDFORM.                               " ENQ_SCUSTOM

*&---------------------------------------------------------------------*
*&      Form  deq_all
*&---------------------------------------------------------------------*
FORM deq_all.
  CALL FUNCTION 'DEQUEUE_ALL'.
ENDFORM.                               " DEQ_ALL


*&---------------------------------------------------------------------*
*&      Form  SAVE_SCUSTOM
*&---------------------------------------------------------------------*
FORM save_scustom.
  INSERT INTO scustom VALUES scustom.
  IF sy-subrc <> 0.
* initialize SCUSTOM-ID in SAP-MEMORY
    SET PARAMETER ID 'CSM' FIELD space.
* insertion of dataset in DB-table not possible
    MESSAGE a096 WITH sy-subrc.
  ELSE.
* write SCUSTOM-ID back to SAP-MEMORY
    SET PARAMETER ID 'CSM' FIELD scustom-id.
* insertion successful
    CLEAR sbuspart.
    sbuspart-mandant    = scustom-mandt.
    sbuspart-buspartnum = scustom-id.
    sbuspart-buspatyp   = 'FC'.        " flight customer

    INSERT INTO sbuspart VALUES sbuspart.
    IF sy-subrc <> 0.
* insertion of dataset in DB-table not possible
      MESSAGE a096 WITH sy-subrc.
    ELSE.
      MESSAGE s110 WITH scustom-id.
    ENDIF.
  ENDIF.
ENDFORM.                               " SAVE_SCUSTOM

*&---------------------------------------------------------------------*
*&      Form  SAVE
*&---------------------------------------------------------------------*
FORM save.
* lock dataset
  PERFORM enq_scustom.
* get SCUSTOM-ID from number range object BC_SCUSTOM
  PERFORM number_get_next USING scustom.
* save new customer
  PERFORM save_scustom.
* unlock dataset
  PERFORM deq_all.
ENDFORM.                               " SAVE
