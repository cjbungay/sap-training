FUNCTION BAPI_CONTACT_GETDETAIL.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(CUSTOMER) TYPE  BAPI0417_2-KUNNR
*"  EXPORTING
*"     VALUE(RETURN) TYPE  BAPIRET2
*"  TABLES
*"      CONTACT_DETAIL STRUCTURE  BAPI0417_2
*"----------------------------------------------------------------------
  clear: contact_detail, return, sknvk.

  select * from sknvk into corresponding fields of table itab
      where kunnr = customer.

  if sy-subrc ne 0.

    clear message.
    message-msgty = 'E'.
    concatenate 'Customer' customer 'does not exist' into message-msgv1
              separated by space.

    perform bapireturn_fill using message-msgty
                                    message-msgid
                                    message-msgno
                                    message-msgv1
                                    message-msgv2
                                    message-msgv3
                                    message-msgv4
                               changing return.

  endif.

  check return is initial.
  contact_detail[] = itab[].

ENDFUNCTION.
