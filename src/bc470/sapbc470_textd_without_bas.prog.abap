*&---------------------------------------------------------------------*
*&
*& Formated addresses without Business Address Services
*& (Former term: Central Address Management)
*&
*&---------------------------------------------------------------------*

* This report calls the form BC470_WITHOUT_CAM, which then calls
* the function module ADDRESS_INTO_PRINTFORM to convert the unformatted
* data from table SCUSTOM into formatted data.
* The sender country, which determines whether the country of the
* addressee will be printed, must be entered on the selection-screen.

REPORT  sapbc470_textd_without_bas.

TYPE-POOLS: szadr.

TABLES: spfli.

DATA:
  wa_country          TYPE scustom-country,
  it_country          TYPE TABLE OF scustom-country,
  wa_id               TYPE scustom-id,
  it_id               TYPE TABLE OF scustom-id,

  func_module_name    TYPE rs38l_fnam,
  control_parameters  TYPE ssfctrlop,
  output_options      TYPE ssfcompop,

  it_bookings         TYPE ty_bookings,
  it_customers        TYPE ty_customers,
  wa_customers        TYPE scustom,
  return_code         TYPE i.

* selection-screen
PARAMETERS: pa_form LIKE ssfscreen-fname DEFAULT
  'BC470_TEXTD_WITHOUT_BAS'.
SELECT-OPTIONS:
  so_cust FOR wa_customers-id,
  so_carr FOR spfli-carrid DEFAULT 'AA' TO 'LH'.
SELECTION-SCREEN SKIP 1.
PARAMETERS:
  pa_ctry TYPE adrc-country DEFAULT 'DE'.



********************************************************************
INITIALIZATION.
* select 10 customers from 10 different countries
  SELECT DISTINCT country                             "#EC CI_SGLSELECT
    FROM scustom                                         "#EC CI_BYPASS
    UP TO 10 ROWS
    INTO TABLE it_country
    WHERE country LIKE '__'.


  LOOP AT it_country
  INTO wa_country.
    SELECT SINGLE id                                    "#EC CI_GENBUFF
      FROM scustom
      INTO wa_id
      WHERE country = wa_country.
    APPEND wa_id TO it_id.
  ENDLOOP.

* set the selection-screen with the IDs of the customers
  REFRESH so_cust.
  LOOP AT it_id
    INTO wa_id.
    CLEAR so_cust.
    so_cust-sign   = 'I'.
    so_cust-option = 'EQ'.
    so_cust-low    = wa_id.
    APPEND so_cust.
  ENDLOOP.

*******************************************************************
START-OF-SELECTION.
* set output options
  output_options-tdnewid       = 'X'.
  control_parameters-preview   = 'X'.
  control_parameters-no_dialog = 'X'.

* determine the name of the generated function module
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = pa_form
    IMPORTING
      fm_name            = func_module_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.


  CASE sy-subrc.
    WHEN 0.
      PERFORM set_interface.

      LOOP AT it_customers
        INTO wa_customers.
        AT FIRST.
          control_parameters-no_close = 'X'.
        ENDAT.
        AT LAST.
          control_parameters-no_close = space.
        ENDAT.
        PERFORM process_form CHANGING return_code.
        IF return_code NE 0.
          EXIT.
        ENDIF.
        control_parameters-no_open = 'X'.
      ENDLOOP.

    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDCASE.


*---------------------------------------------------------------------*
FORM set_interface.

* fill the tables for the form interface
  SELECT * FROM  scustom                              "#EC CI_SGLSELECT
    INTO TABLE it_customers
    WHERE id IN so_cust
    ORDER BY PRIMARY KEY.

  SELECT * FROM  sbook
    INTO TABLE it_bookings
    FOR ALL ENTRIES IN it_customers
    WHERE customid = it_customers-id AND
          carrid   IN so_carr
    ORDER BY PRIMARY KEY.

ENDFORM.                    "set_interface

*---------------------------------------------------------------------*
FORM process_form
  CHANGING return_code TYPE i.

* make sure the proper date format and decimal notation of
* the addressee's country is used.
  SET COUNTRY wa_customers-country.
  IF sy-subrc <> 0.
    SET COUNTRY sy-langu.
  ENDIF.

* call the generated function module of the form
  CALL FUNCTION func_module_name
    EXPORTING
      control_parameters = control_parameters
      output_options     = output_options
      user_settings      = space
      is_customer        = wa_customers
      sender_country     = pa_ctry
    TABLES
      it_bookings        = it_bookings
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      my_exception       = 5
      OTHERS             = 6.
  CASE sy-subrc.
    WHEN 0.
      return_code = 0.
    WHEN OTHERS.
      return_code = -1.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDCASE.

ENDFORM.                    "process_form
