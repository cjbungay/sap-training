FUNCTION customer_address_to_itf .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_CUSTOMER) TYPE  SCUSTOM
*"     REFERENCE(IV_SENDING_COUNTRY) TYPE  SZAD_FIELD-SEND_CNTRY
*"     REFERENCE(IV_NUMBER_OF_LINES) TYPE  ADRS-ANZZL DEFAULT 5
*"  EXPORTING
*"     REFERENCE(ET_ADDRESS) TYPE  TLINE_TAB
*"----------------------------------------------------------------------


  DATA:
    ls_address TYPE  adrs1,
    lt_address_lines TYPE szadr_printform_table,
    ls_address_line  LIKE LINE OF lt_address_lines,
    ls_dynamic_text  TYPE tline.

*map address fields from work area to fields from function module
  ls_address-title_text = is_customer-form.
  ls_address-name1      = is_customer-name.
  ls_address-street     = is_customer-street.
  ls_address-po_box     = is_customer-postbox.
  ls_address-post_code1 = is_customer-postcode.
  ls_address-region     = is_customer-region.
  ls_address-city1      = is_customer-city.
  ls_address-country    = is_customer-country.


  CALL FUNCTION 'ADDRESS_INTO_PRINTFORM'
    EXPORTING
      address_1               = ls_address
      address_type            = '1' "normal/company
      sender_country          = iv_sending_country
      number_of_lines         = iv_number_of_lines
    IMPORTING
      address_printform_table = lt_address_lines.


* Internal table lt_address_lines has only one column.
* Every line contains one line of the address that has been
* assembled according to the addressess's country.
* These lines need to be converted into a two-column internal
* table that can be used as the source of a dynamic text in a PDF form.
* - Column TDFORMAT contains the paragraph format of the line (e.g.
*   an asterisk for the default format)
* - Column TDLINE contains the text itself.
* (This two-column format is known as ITF.)

  LOOP AT lt_address_lines
    INTO ls_address_line.
    ls_dynamic_text-tdformat = '*'.
    ls_dynamic_text-tdline = ls_address_line-address_line.
    APPEND ls_dynamic_text TO et_address.
  ENDLOOP.

ENDFUNCTION.
