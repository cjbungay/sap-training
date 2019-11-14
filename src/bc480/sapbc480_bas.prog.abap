*&---------------------------------------------------------------------*
*& Report  BC480_BAS
*&
*&---------------------------------------------------------------------*
*& Demo program for PDF-based forms with Business Address Services
*& (former term: Central Address Management)
*&
*& relevant DB tables:
*& ADRP: Persons
*& ADRC: Addresses
*& ADCP: person/address assignment
*&---------------------------------------------------------------------*

INCLUDE bc480_bastop.

INITIALIZATION.
  GET PARAMETER ID 'RFC' FIELD pa_rfc.
  IF sy-subrc <> 0. "first call
    pa_rfc = 'ADS'.
  ENDIF.

  GET PARAMETER ID 'FPWBFORM' FIELD pa_form.
  IF sy-subrc <> 0. "first call
    pa_form = 'BC480_BAS'. "EC#
  ENDIF.

  SELECT SINGLE laiso
    FROM t002
    INTO pa_cntry
    WHERE spras = sy-langu.
  IF pa_cntry = 'EN'. pa_cntry = 'US'. ENDIF.

* Select address number for IDES
  SELECT SINGLE addrnumber "#EC CI_NOFIELD
    FROM adrc
    INTO so_addno-low
    WHERE name1 = 'IDES'.
  IF sy-subrc NE 0.
* if no success, try to select address number for SAP AG
    SELECT SINGLE addrnumber "#EC CI_NOFIELD
      FROM adrc
      INTO so_addno-low
      WHERE name1 = 'SAP AG'.
  ENDIF.
  so_addno-sign = 'I'.
  so_addno-option = 'EQ'.
  APPEND so_addno.

*******************************************************************
AT SELECTION-SCREEN OUTPUT.
* FOR THE TIME BEING!!
* person addresses do not seem to work properly
  LOOP AT SCREEN.
    IF screen-group1 = 'XXX'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.



* If type "work address" has been selected,
* check whether address number belongs to company address.
  IF pa_work = 'X'.
    IF NOT pa_addno = space.
      SELECT SINGLE addrnumber
        FROM adrc
        INTO address_number
        WHERE addrnumber = pa_addno.
      IF sy-subrc NE 0.                " address not in system
        pa_comp = text-i01.
      ELSE.
        SELECT SINGLE addrnumber
          FROM adcp
          INTO address_number
          WHERE addrnumber = pa_addno AND
                comp_pers = 'C'.
        pa_comp = text-se7.
        IF sy-subrc = 0.               " address is company address
          SELECT SINGLE name1
            FROM adrc
            INTO pa_comp
            WHERE addrnumber = pa_addno.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.



* The selection-screen is dynamically changed, depending on which
* address type has been chosen via radio button.
  PERFORM modify_screen.

*******************************************************************



AT SELECTION-SCREEN ON pa_form.
* These lines checks whether a given PDF based form is
* suitable for demoing it with this program.
* It will be checked whether any non-optional parameters are used
* in the form other than the ones filled by this program.
* It will also be checked whether the appropriate type is used.

  SELECT SINGLE name
      FROM fpcontext
      INTO form
      WHERE name = pa_form AND
            state = 'A'.
  IF sy-subrc <> 0.
      MESSAGE e004 with pa_form.
* No active form &1 available
  ENDIF.

  DATA:
*    func_mod TYPE rs38l_fnam,
    it_func_mod_params TYPE TABLE OF fupararef,
    func_mod_param TYPE fupararef.

* determine the name of the generated function module
  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name           = pa_form
    IMPORTING
      e_funcname       = func_module_name
      e_interface_type = interface_type
    EXCEPTIONS
      OTHERS           = 1.
  CASE sy-subrc.
    WHEN 1.
      MESSAGE e004 with pa_form.
* No active form &1 available
  ENDCASE.

  SELECT *
    FROM fupararef
    INTO TABLE it_func_mod_params
    WHERE funcname = func_module_name AND
          r3state  = 'A'.

  LOOP AT it_func_mod_params
    INTO func_mod_param.
    CASE func_mod_param-paramtype.
      WHEN 'E'.
        " export parameters are always optional, so they don't hurt
      WHEN 'X'.
        " exceptions are always optional, so they don't hurt
      WHEN 'I'.
        IF func_mod_param-optional <> 'X' AND NOT
          ( func_mod_param-parameter = 'IV_ADDRESS_TYPE'  OR "AND
*            func_mod_param-structure = 'I'  OR
          func_mod_param-parameter = 'IV_ADDRESS_NUMBER'  OR "AND
*            func_mod_param-structure = 'CHAR10' OR
          func_mod_param-parameter = 'IV_PERSON_NUMBER'   OR "AND
*            func_mod_param-structure = 'CHAR10'
          func_mod_param-parameter = 'IV_SENDING_COUNTRY'    "AND
*            func_mod_param-structure = 'CHAR3'
          ).

          MESSAGE e024.
*Form has unsuitable parameters
        ENDIF.
      WHEN 'T'.
        MESSAGE e024.
    ENDCASE.
  ENDLOOP.


AT SELECTION-SCREEN ON pa_max.
  IF pa_max < 1 OR pa_max > 20.
    MESSAGE e026.
*    Number must be between 1 and 20
  ENDIF.


AT SELECTION-SCREEN ON pa_rfc.
  SELECT SINGLE rfcdest
    FROM rfcdes
    INTO pa_rfc
    WHERE rfcdest = pa_rfc.
  IF sy-dbcnt <> 1.
    MESSAGE e015.
*   Enter valid RFC destination for Adobe document services'
  ENDIF.

AT SELECTION-SCREEN.
* Set selection screen with valid numbers
* Select up to <pa_max> organisation addresses
* in different countries
  IF pa_auto IS NOT INITIAL.
    SELECT DISTINCT country "#EC CI_NOFIELD
      FROM adrc
      INTO TABLE it_country
      UP TO pa_max ROWS
      WHERE name1 NE space.
    IF sy-dbcnt = 0.
      MESSAGE e025.
*    Business Address Services hold no data
    ENDIF.


    LOOP AT it_country
      INTO wa_country.
      SELECT SINGLE addrnumber
        FROM adrc
        INTO wa_numbers
        WHERE name1 NE space AND
              country = wa_country.
      APPEND wa_numbers TO it_numbers.
    ENDLOOP.

    CLEAR so_addno.
    REFRESH so_addno.
    LOOP AT it_numbers
      INTO wa_numbers.
      so_addno-sign = 'I'.
      so_addno-option = 'EQ'.
      so_addno-low = wa_numbers.
      APPEND so_addno.
    ENDLOOP.

* Select address number for IDES
    SELECT SINGLE addrnumber "#EC CI_NOFIELD
      FROM adrc
      INTO pa_addno
      WHERE name1 = 'IDES'.
    IF sy-subrc NE 0.
* if no success, try to select address number for SAP AG
      SELECT SINGLE addrnumber "#EC CI_NOFIELD
        FROM adrc
        INTO pa_addno
        WHERE name1 = 'SAP AG'.
    ENDIF.

* Select up to <pa_max> IDES/SAP AG employess
    SELECT persnumber
      FROM adcp
      INTO TABLE it_numbers
      UP TO pa_max ROWS
      WHERE addrnumber = pa_addno.
    IF sy-dbcnt > 0.
      CLEAR so_perno.
      REFRESH so_perno.
      so_perno-sign = 'I'.
      IF sy-dbcnt > 1.
        so_perno-option = 'BT'.
      ELSE.
        so_perno-option = 'EQ'.
      ENDIF.
      READ TABLE it_numbers INDEX 1
        INTO so_perno-low.
      READ TABLE it_numbers INDEX sy-dbcnt
        INTO so_perno-high.
      APPEND so_perno.
    ENDIF.

  ENDIF.



START-OF-SELECTION.

* Set output parameters for new interface
  fp_outputparams-nodialog = 'X'.    " show printer dialog popup
  fp_outputparams-preview  = 'X'.     " launch print preview
*  fp_outputparams-dest     = pa_prnt.     " set printer
  fp_outputparams-reqnew   = 'X'.
* determine RFC destination for Adobe Document Services
  fp_outputparams-connection = pa_rfc.


* determine the name of the generated function module
  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name           = pa_form
    IMPORTING
      e_funcname       = func_module_name
      e_interface_type = interface_type
    EXCEPTIONS
      OTHERS           = 1.

  CASE sy-subrc.
    WHEN 0.
      IF interface_type = 'S'.
        EXIT.
      ENDIF.

      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = fp_outputparams
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.
      CASE sy-subrc.
        WHEN 0.
        WHEN 1.
          EXIT.
        WHEN OTHERS.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDCASE.

      CASE 'X'.
* Organisation addresses (e.g. company addresses)
        WHEN pa_orga.
          address_type = 1.

          SELECT addrnumber
            FROM adrc
            INTO TABLE it_numbers
            WHERE addrnumber IN so_addno AND
                  name1 NE space.

          PERFORM loop_at_addresses
            USING address_number.

* Person addresses
        WHEN pa_pers.
          address_type = 2.

          SELECT persnumber
            FROM adrp
            INTO TABLE it_numbers
            WHERE persnumber = pa_perno.

          address_number = pa_addno.
          PERFORM loop_at_addresses
            USING pa_perno.

* Work addresses
        WHEN pa_work.
          address_type = 3.

          SELECT persnumber
            FROM adrp
            INTO TABLE it_numbers
            WHERE persnumber IN so_perno AND
                  addr_comp = pa_addno.

          address_number = pa_addno.
          PERFORM loop_at_addresses
            USING person_number.
      ENDCASE.

      IF interface_type <> 'S'.
        CALL FUNCTION 'FP_JOB_CLOSE'
          EXCEPTIONS
            usage_error    = 1
            system_error   = 2
            internal_error = 3
            OTHERS         = 4.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
      ENDIF.

    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDCASE.



*---------------------------------------------------------------------*
*       FORM modify_screen                                            *
*---------------------------------------------------------------------*
* This form sets the screen attributes depending on the address type.
*---------------------------------------------------------------------*
FORM modify_screen..


  LOOP AT SCREEN.
    IF screen-name = 'PA_COMP'.
      screen-input = 0. MODIFY SCREEN.
    ENDIF.

    CASE screen-group1.
* Select-option for address numbers
      WHEN 'ADS'.
        IF pa_work = 'X' OR pa_pers = 'X'.
          screen-active = 0. MODIFY SCREEN.
        ENDIF.
        IF pa_auto IS NOT INITIAL.
          screen-input = 0. MODIFY SCREEN.
        ENDIF.

* Parameter for address number
      WHEN 'ADP'.
        IF pa_orga = 'X' OR pa_pers = 'X'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
        IF pa_auto IS NOT INITIAL.
          screen-input = 0. MODIFY SCREEN.
        ENDIF.

* Parameter pa_comp is used for displaying the company name only
      WHEN 'COM'.
        IF pa_orga = 'X' OR pa_pers = 'X'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
        IF pa_auto IS NOT INITIAL.
          screen-input = 0. MODIFY SCREEN.
        ENDIF.


* Select-option for personal addresses
      WHEN 'PES'.
        IF pa_orga = 'X' OR pa_pers = 'X'.
          screen-active = 0. MODIFY SCREEN.
        ENDIF.
        IF pa_auto IS NOT INITIAL.
          screen-input = 0. MODIFY SCREEN.
        ENDIF.


      WHEN 'PEP'.
        CHECK pa_orga = 'X' OR pa_work = 'X'.
        screen-active = 0. MODIFY SCREEN.

      WHEN 'MAX'.
        CHECK pa_auto IS INITIAL.
        screen-active = 0.
        MODIFY SCREEN.


    ENDCASE.
  ENDLOOP.

ENDFORM.                    "modify_screen


*---------------------------------------------------------------------*
*       FORM loop_at_addresses                                        *
*---------------------------------------------------------------------*
*  -->  NUMBER                                                        *
*---------------------------------------------------------------------*
FORM loop_at_addresses
  USING number.

  DATA: lines_of_it TYPE i.

  DESCRIBE TABLE it_numbers LINES lines_of_it.
  IF lines_of_it = 0.
    WRITE: text-i01.                   " 'No such address'
  ENDIF.
  LOOP AT it_numbers
    INTO number.
    PERFORM process_form CHANGING return_code.
    IF return_code NE 0.
      EXIT.
    ENDIF.
  ENDLOOP.
ENDFORM.                    "loop_at_addresses



*---------------------------------------------------------------------*
*       FORM process_form                                             *
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
FORM process_form
  CHANGING return_code TYPE i.

  DATA: land TYPE adrc-country.

* make sure the proper date format and decimal notation of
* the addressee's country is used.
  SELECT SINGLE country langu
    FROM adrc
    INTO (fp_docparams-country, fp_docparams-langu)
    WHERE addrnumber = address_number.
  IF sy-subrc <> 0.
    fp_docparams-langu   = sy-langu.
    fp_docparams-country = 'US'.
  ENDIF.


* call the generated function module of the form
  CALL FUNCTION func_module_name
    EXPORTING
      /1bcdwb/docparams  = fp_docparams
      iv_address_type    = address_type
      iv_address_number  = address_number
      iv_person_number   = person_number
      iv_sending_country = pa_cntry
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.

  CASE sy-subrc.
    WHEN 0.
      return_code = 0.
    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      return_code = -1.
  ENDCASE.

ENDFORM.                    "process_form
