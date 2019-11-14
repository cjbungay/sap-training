FUNCTION BC406_FMDD_WAIT_SHIFT.
*"----------------------------------------------------------------------
*"*"Local interface:
*"       IMPORTING
*"             REFERENCE(IP_ID) TYPE  S_CUSTOMER
*"             REFERENCE(IP_NEW_POS) TYPE  SY-TABIX
*"       EXCEPTIONS
*"              NOT_IN_LIST
*"----------------------------------------------------------------------
  DATA:
    last_pos LIKE sy-tabix.

  READ TABLE wait_list WITH KEY id = ip_id INTO wa_cust.
  IF sy-subrc = 0.
    DELETE wait_list INDEX sy-tabix.

    IF ip_new_pos > 0.
      DESCRIBE TABLE wait_list LINES last_pos.
      IF ip_new_pos > last_pos.
        APPEND wa_cust TO wait_list.
      ELSE.
        INSERT wa_cust INTO wait_list INDEX ip_new_pos.
      ENDIF.
    ELSE.
      INSERT wa_cust INTO wait_list INDEX 1.
    ENDIF.

  ELSE.
    MESSAGE e203(bc402) RAISING not_in_list.
  ENDIF.

ENDFUNCTION.
