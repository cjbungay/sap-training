FUNCTION BAPI_CONTACT_GETLIST2.
*"----------------------------------------------------------------------
*"*"Local interface:
*"       IMPORTING
*"             VALUE(COUNTRY) TYPE  BAPI0417_1-LAND1
*"       EXPORTING
*"             VALUE(RETURN) TYPE  BAPIRET2
*"       TABLES
*"              CUSTOMER_LIST STRUCTURE  BAPI0417_1
*"              EXTENSION_OUT TYPE  BAPIPAREX_BC417_TAB OPTIONAL
*"----------------------------------------------------------------------
  clear: customer_list, return, skna1, extension_out.

  authority-check object 'W_AUFT_RMB'
             id 'ACTVT'  field '03'.
  if sy-subrc ne 0.
    clear message.
    message-msgty = 'E'.
    message-msgid = 'BC417'.
    message-msgno = 001.  "You are not authorized to display customers

    perform bapireturn_fill using message-msgty
                                  message-msgid
                                  message-msgno
                                  message-msgv1
                                  message-msgv2
                                  message-msgv3
                                  message-msgv4
                             changing return.


  else.

    if not country is initial.

      translate country to upper case.

      select * from skna1 into corresponding fields of table
              customer_list
                 where land1 = country.

      If sy-subrc nE 0.
        clear message.
        message-msgty = 'E'.
        message-msgid = 'BC417'.
        message-msgno = 002.  "No customer found for this selection

        perform bapireturn_fill using message-msgty
                                  message-msgid
                                  message-msgno
                                  message-msgv1
                                  message-msgv2
                                  message-msgv3
                                  message-msgv4
                                changing return.

      else.

        call method cl_exithandler=>get_instance
                 changing
                     instance = exit_ref.

        call method exit_ref->export_data
               exporting
                   country = country
               importing
                   extension_out = temp_table.

          extension_out[] = temp_table[].

      endif.

    else.
      clear message.
      message-msgty = 'E'.
      message-msgid = 'BC417'.
      message-msgno = 003.  "A country code was not entered

      perform bapireturn_fill using message-msgty
                                  message-msgid
                                  message-msgno
                                  message-msgv1
                                  message-msgv2
                                  message-msgv3
                                  message-msgv4
                             changing return.

    endif.
  endif.

ENDFUNCTION.
