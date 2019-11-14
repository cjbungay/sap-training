REPORT SAPBC417S_RFC_FUNCTION_CALL .
data: customer_list type table of bapi0417_1,
      wa_customer_list type bapi0417_1,
      return type bapiret2.

Start-of-selection.

  CALL FUNCTION 'BAPI_CONTACT_GETLIST'
    DESTINATION           'BC417'
    EXPORTING
      COUNTRY             = 'de'
   IMPORTING
     RETURN              = return
    TABLES
      CUSTOMER_LIST       = customer_list
    exceptions
       communication_failure = 1
       system_failure = 2.

  case sy-subrc.
    when 0.
      If not customer_list is initial.

        loop at customer_list into wa_customer_list from 1 to 100.

          write:/ wa_customer_list-kunnr,
                 wa_customer_list-name1,
                 wa_customer_list-ort01.

        endloop.
      else.
        write:/ return.
      endif.
    when 1.
      write / 'Error in communication with destination '.

    when 2.
      write / 'System error occurred'.

  endcase.
