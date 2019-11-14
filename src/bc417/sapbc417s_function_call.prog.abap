REPORT SAPBC417S_FUNCTION_CALL .

data: customer_list type table of bapi0417_1,
      wa_customer_list type bapi0417_1,
      return type bapiret2.

Start-of-selection.

  CALL FUNCTION 'BAPI_CONTACT_GETLIST'
       EXPORTING
            COUNTRY       = 'de'
       IMPORTING
            RETURN        = return
       TABLES
            CUSTOMER_LIST = customer_list.

  Case sy-subrc.
    when 0.
      if not customer_list is initial.
        loop at customer_list into wa_customer_list from 1 to 100.

          write:/ wa_customer_list-kunnr,
                 wa_customer_list-name1,
                 wa_customer_list-ort01.

        endloop.

      else.

        write / return.
      endif.
    when others.
      write:/ 'Return code from function call = ', sy-subrc.
  endcase.
