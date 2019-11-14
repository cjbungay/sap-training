*&---------------------------------------------------------------------*
*& Report  SAPBC470_TABLD_TICKET
*&---------------------------------------------------------------------*
*& Demo Program for printing flight tickets
*&---------------------------------------------------------------------*

REPORT  sapbc470_tabld_ticket.
TABLES: sbook.

* selection-screen
PARAMETERS: pa_form LIKE ssfscreen-fname DEFAULT 'BC470_TABLD_TICKET'.
SELECT-OPTIONS:
  so_car  FOR sbook-carrid DEFAULT 'AA',
  so_book FOR sbook-bookid DEFAULT 1000    TO 1003,
  so_date FOR sbook-fldate.

* printing options
SELECTION-SCREEN SKIP 1.
PARAMETERS:
  pa_prnt  TYPE tsp03-padest DEFAULT 'P280' OBLIGATORY
    VISIBLE LENGTH 4.

DATA:
  func_module_name    TYPE rs38l_fnam,
  control_parameters  TYPE ssfctrlop,
  output_options      TYPE ssfcompop,

  wa_bookings         TYPE sbook,
  it_bookings         TYPE TABLE OF sbook,
  return_code         TYPE i.


*******************************************************************
START-OF-SELECTION.
* set output options
  IF pa_prnt IS INITIAL.
    output_options-tddest     = 'P280'.
  ELSE.
    output_options-tddest     = pa_prnt.
  ENDIF.
  output_options-tdimmed    = space.
  output_options-tdnewid    = 'X'.


  control_parameters-preview = 'X'.
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
      SELECT * FROM  sbook
        INTO TABLE it_bookings
        WHERE carrid IN so_car  AND
              bookid IN so_book AND
              fldate IN so_date
        ORDER BY PRIMARY KEY.

      LOOP AT it_bookings
        INTO wa_bookings.
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
*       FORM process_form                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM process_form
  CHANGING return_code TYPE i.

* call the generated function module of the form
  CALL FUNCTION func_module_name
       EXPORTING
            control_parameters = control_parameters
            output_options     = output_options
            user_settings      = space
            wa_sbook           = wa_bookings
       EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 6.
  CASE sy-subrc.
    WHEN 0.
      return_code = 0.
    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      return_code = -1.
  ENDCASE.

ENDFORM.
