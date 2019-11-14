FUNCTION bapi_contact_update.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(CONTACT) TYPE  BAPI0417_2-PARNR
*"     VALUE(CUSTOMER) TYPE  BAPI0417_2-KUNNR
*"     VALUE(TELEPHONE) TYPE  BAPI0417_2-TELF1
*"     VALUE(ENTERED) TYPE  BAPI0417_2-ERNAM
*"  EXPORTING
*"     VALUE(RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------
  CLEAR: message.

  CALL FUNCTION 'ENQUEUE_ESKNVK'
       EXPORTING
            mode_sknvk     = 'E'
            mandt          = sy-mandt
            parnr          = contact
            _wait          = 'X'
       EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 2.

  IF sy-subrc NE 0.
    CASE sy-subrc.
      WHEN 1.
        message-msgty = 'E'.
        message-msgid = 'BC417'.
        message-msgno = 004.  "Record already locked by another user
      WHEN 2.
        message-msgty = 'E'.
        message-msgid = 'BC417'.
        message-msgno = 005.  "lock could not be set (system error)
    ENDCASE.

    PERFORM bapireturn_fill USING message-msgty
                                message-msgid
                                message-msgno
                                message-msgv1
                                message-msgv2
                                message-msgv3
                                message-msgv4
                           CHANGING return.
    .
  ELSE.
    .
    SELECT SINGLE * FROM sknvk INTO sknvk
                WHERE parnr = contact.

    IF sy-subrc NE 0.
      CLEAR message.
      message-msgty = 'E'.
      CONCATENATE 'Customer contact' contact 'does not exist'
        INTO message-msgv1
        SEPARATED BY space.

      PERFORM bapireturn_fill USING message-msgty
                                message-msgid
                                message-msgno
                                message-msgv1
                                message-msgv2
                                message-msgv3
                                message-msgv4
                           CHANGING return.
      .
    ELSE.

      IF NOT telephone IS INITIAL.
        MOVE telephone TO sknvk-telf1.
      ENDIF.

      IF NOT entered IS INITIAL.
        MOVE entered TO sknvk-ernam.
      ENDIF.

      CALL FUNCTION 'CONTACT_UPDATE' IN UPDATE TASK
           EXPORTING
                contact_info = sknvk.

      IF sy-subrc NE 0.
        CLEAR message.
        message-msgty = 'E'.
        message-msgid = 'BC417'.
        message-msgno = 006.       "Error during update

      ELSE.
        CLEAR message.
        message-msgty = 'S'.
        message-msgid = 'BC417'.
        message-msgno = 007.       "Changes successfully made
      ENDIF.
      PERFORM bapireturn_fill USING message-msgty
                             message-msgid
                             message-msgno
                             message-msgv1
                             message-msgv2
                             message-msgv3
                             message-msgv4
                        CHANGING return.



    ENDIF.
  ENDIF.

ENDFUNCTION.
