*&---------------------------------------------------------------------*
*& Report  sapbc470_textd_cam
*&---------------------------------------------------------------------*
*&                                                                     *
*& Demo Program for SAP Smart Forms with Business Address Services
*& (former term: Central Address Management)
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc470_textd_bas.
TABLES: adrc.

DATA:
  func_module_name    TYPE rs38l_fnam,
  control_parameters  TYPE ssfctrlop,

  address_type        TYPE i,
  address_number      TYPE adrc-addrnumber,
  person_number       TYPE adrp-persnumber,
  wa_numbers          TYPE char10,
  it_numbers          TYPE TABLE OF char10,
  return_code         TYPE i,
  wa_country          TYPE adrc-country,
  it_country          TYPE TABLE OF adrc-country.

* selection-screen
PARAMETERS: pa_form LIKE ssfscreen-fname DEFAULT 'BC470_TEXTD_BAS'.
SELECTION-SCREEN SKIP 1.

* central address administration
* determine type of address
SELECTION-SCREEN BEGIN OF BLOCK address WITH FRAME TITLE text-se1.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:
  pa_orga RADIOBUTTON GROUP adrs USER-COMMAND address_type DEFAULT 'X'.
SELECTION-SCREEN COMMENT 3(20) text-se2 FOR FIELD pa_orga.
SELECTION-SCREEN POSITION 23.
PARAMETERS:
  pa_pers RADIOBUTTON GROUP adrs.
SELECTION-SCREEN COMMENT 25(20) text-se3 FOR FIELD pa_pers.
SELECTION-SCREEN POSITION 47.
PARAMETERS:
  pa_work RADIOBUTTON GROUP adrs.
SELECTION-SCREEN COMMENT 50(20) text-se4 FOR FIELD pa_work.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN SKIP 1.


* determine address/person numbers
SELECT-OPTIONS:
  so_addno  FOR adrc-addrnumber.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) text-se5 FOR FIELD pa_addno.
PARAMETERS:
  pa_addno TYPE adrc-addrnumber.
PARAMETERS:
  pa_comp TYPE adrc-name1.
SELECTION-SCREEN END OF LINE.
SELECT-OPTIONS:
  so_perno FOR person_number  DEFAULT 1    TO 22.
PARAMETERS:
  pa_cntry   TYPE adrc-country DEFAULT 'DE' MEMORY ID spr.

SELECTION-SCREEN END OF BLOCK address.


INITIALIZATION.
* Set selection screen with valid numbers
* Select up to 10 organisation addresses (i.e. "normal" addresses)
* in different countries

  SELECT DISTINCT country                               "#EC CI_NOFIELD
    FROM adrc
    INTO TABLE it_country
    UP TO 10 ROWS
    WHERE name1 NE space.
  IF sy-dbcnt = 0.
    MESSAGE e670(bc_global)." abort if no addresses available
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
  SELECT SINGLE addrnumber                              "#EC CI_NOFIELD
    FROM adrc
    INTO pa_addno
    WHERE name1 = 'IDES'.
  IF sy-subrc NE 0.
* if no success, try to select address number for SAP AG
    SELECT SINGLE addrnumber                            "#EC CI_NOFIELD
      FROM adrc
      INTO pa_addno
      WHERE name1 = 'SAP AG'.
  ENDIF.

* Select up to 10 IDES/SAP AG employess
  SELECT persnumber
    FROM adcp
    INTO TABLE it_numbers
    UP TO 10 ROWS
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


*******************************************************************
AT SELECTION-SCREEN OUTPUT.
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
  CASE 'X'.
    WHEN pa_orga.
      PERFORM modify_screen
        USING 1 0 0 0.
    WHEN pa_pers.
      PERFORM modify_screen
        USING 0 1 0 1.
    WHEN pa_work.
      PERFORM modify_screen
        USING 0 1 1 1.
  ENDCASE.

*    LOOP AT SCREEN.
*      CASE screen-name.
** Parameter for address number
*        WHEN 'PA_ADDNO'.
*          screen-invisible = 0. screen-input = 0.
*          MODIFY SCREEN.
*      ENDCASE.
*    ENDLOOP.

*******************************************************************

START-OF-SELECTION.
  SET PARAMETER ID 'SSFNAME' FIELD pa_form.

* print settings
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
      CASE 'X'.
* Organisation addresses (i.e. "normal" addresses)
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
            WHERE persnumber IN so_perno AND
                  addr_pers = pa_addno.

          address_number = pa_addno.
          PERFORM loop_at_addresses
            USING person_number.

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


    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDCASE.



*---------------------------------------------------------------------*
*       FORM modify_screen                                            *
*---------------------------------------------------------------------*
* This form sets the screen attributes depending on the address type.
*---------------------------------------------------------------------*
FORM modify_screen
  USING
    switch1 TYPE i
    switch2 TYPE i
    switch3 TYPE i
    switch4 TYPE i.


  LOOP AT SCREEN.
    CASE screen-name.
* Select-option for address numbers
      WHEN '%_SO_ADDNO_%_APP_%-TEXT'.
        screen-active = switch1. MODIFY SCREEN.
      WHEN 'SO_ADDNO-LOW'.
        screen-active = switch1. MODIFY SCREEN.
      WHEN 'SO_ADDNO-HIGH'.
        screen-active = switch1. MODIFY SCREEN.
      WHEN '%_SO_ADDNO_%_APP_%-VALU_PUSH'.
        screen-active = switch1. MODIFY SCREEN.
      WHEN '%_SO_ADDNO_%_APP_%-OPTI_PUSH'.
        screen-active = switch1. MODIFY SCREEN.

* Parameter for address number
      WHEN '%_PA_ADDNO_%_APP_%-TEXT'.
        screen-active = switch2. MODIFY SCREEN.
      WHEN '%CSE5016_1000'.
        screen-active = switch2. MODIFY SCREEN.
      WHEN 'PA_ADDNO'.
        screen-active = switch2. MODIFY SCREEN.

* Parameter pa_comp is used for displaying the company name only
      WHEN '%CSE6018_1000'.
        screen-active = switch3. MODIFY SCREEN.
      WHEN '%_PA_COMP_%_APP_%-TEXT'.
        screen-active = switch3. MODIFY SCREEN.
      WHEN 'PA_COMP'.
        screen-active = switch3. MODIFY SCREEN.
        screen-input = space. MODIFY SCREEN.

* Select-option for personal addresses
      WHEN '%_SO_PERNO_%_APP_%-TEXT'.
        screen-active = switch4. MODIFY SCREEN.
      WHEN 'SO_PERNO-LOW'.
        screen-active = switch4. MODIFY SCREEN.
      WHEN 'SO_PERNO-HIGH'.
        screen-active = switch4. MODIFY SCREEN.
      WHEN '%_SO_PERNO_%_APP_%-VALU_PUSH'.
        screen-active = switch4. MODIFY SCREEN.
      WHEN '%_SO_PERNO_%_APP_%-OPTI_PUSH'.
        screen-active = switch4. MODIFY SCREEN.
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
    IF sy-tabix < lines_of_it.
      control_parameters-no_close = 'X'.
    ELSE.
      control_parameters-no_close = space.
    ENDIF.
    PERFORM process_form CHANGING return_code.
    IF return_code NE 0.
      EXIT.
    ENDIF.
    control_parameters-no_open = 'X'.
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
  SELECT SINGLE country
    FROM adrc
    INTO land
    WHERE addrnumber = address_number.
  IF sy-subrc <> 0.
    SET COUNTRY sy-langu.
  ELSE.
    SET COUNTRY land.
  ENDIF.


* call the generated function module of the form
  CALL FUNCTION func_module_name
    EXPORTING
      control_parameters = control_parameters
      address_type       = address_type
      address_number     = address_number
      pers_number        = person_number
      sender_country     = pa_cntry
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.

  CASE sy-subrc.
    WHEN 0.
      return_code = 0.
    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      return_code = -1.
  ENDCASE.

ENDFORM.                    "process_form
