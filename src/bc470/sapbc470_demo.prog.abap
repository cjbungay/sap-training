*&---------------------------------------------------------------------*
*& Test Program for SAP Smart Forms
*&---------------------------------------------------------------------*

REPORT  sapbc470_demo.
TYPE-POOLS vrm.

DATA:
  gt_values           TYPE vrm_values,
  gs_value            TYPE vrm_value,
  gs_usr01            TYPE usr01,
  ge_func_mod_name    TYPE rs38l_fnam,
  gs_control_params   TYPE ssfctrlop,
  gs_output_options   TYPE ssfcompop,

  gt_bookings         TYPE ty_bookings,
  gs_booking          TYPE sbook,
  gt_customers        TYPE ty_customers,
  gs_customers        TYPE scustom,
  gv_subrc            TYPE sy-subrc.

* selection-screen
PARAMETERS: pa_form TYPE ssfscreen-fname MATCHCODE OBJECT sh_stxfadm.
SELECT-OPTIONS:
  so_cust FOR gs_customers-id   DEFAULT 1    TO 3,
  so_carr FOR gs_booking-carrid DEFAULT 'AA' TO 'LH'.

* printer
SELECTION-SCREEN SKIP 2.
PARAMETERS:
  pa_prnt TYPE tsp03-padest OBLIGATORY VISIBLE LENGTH 4,
  pa_copy TYPE ssfcompop-tdcopies DEFAULT 1.

* Graphics
* These settings are relevant only for certain forms!
SELECTION-SCREEN SKIP 3.
SELECTION-SCREEN COMMENT 1(60) text-se1.
PARAMETERS:
  pa_color TYPE tdbtype AS LISTBOX VISIBLE LENGTH 25
    OBLIGATORY DEFAULT 'BMON'.


*******************************************************************
INITIALIZATION.
* set form name using SAP memory
  GET PARAMETER ID 'SSFNAME' FIELD pa_form.
  IF pa_form IS INITIAL.
    pa_form = 'BC470_STEPT'.
  ENDIF.

* set printer
  SELECT SINGLE *
    FROM usr01
    INTO gs_usr01
    WHERE bname = sy-uname.

  IF gs_usr01-spld IS INITIAL.
    pa_prnt = 'P280'.
  ELSE.
    pa_prnt = gs_usr01-spld.
  ENDIF.


* set dropdonwlist for image color
  gs_value-key = 'BMON'.
  gs_value-text = 'Black and white'(bla).                   "#EC *
  APPEND gs_value TO gt_values.

  gs_value-key = 'BCOL'.
  gs_value-text = 'Color'(col).                             "#EC *
  APPEND gs_value TO gt_values.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'PA_COLOR'
      values = gt_values.


*******************************************************************
START-OF-SELECTION.
  PERFORM set_default_printer.

  SET PARAMETER ID 'SSFNAME' FIELD pa_form.

* set output options
  gs_output_options-tddest   = pa_prnt.
  gs_output_options-tdimmed   = space.
  gs_output_options-tdnewid   = 'X'.
  gs_output_options-tdcopies  = pa_copy.

  gs_control_params-preview   = 'X'.
  gs_control_params-no_dialog = 'X'.

* determine the name of the generated function module
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = pa_form
    IMPORTING
      fm_name            = ge_func_mod_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  CASE sy-subrc.
    WHEN 0.
      PERFORM select_business_data.

      LOOP AT gt_customers
        INTO gs_customers.
*       set decimal notation and date format according to
*       addressee's country
        SET COUNTRY gs_customers-country.

        AT FIRST.
          gs_control_params-no_close = 'X'.
        ENDAT.
        AT LAST.
          gs_control_params-no_close = space.
        ENDAT.
        PERFORM process_form CHANGING gv_subrc.
        IF gv_subrc NE 0.
          EXIT.
        ENDIF.
        gs_control_params-no_open = 'X'.
      ENDLOOP.

    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
  ENDCASE.


*---------------------------------------------------------------------*
*       FORM select_business_data                                     *
*---------------------------------------------------------------------*
*   fill the tables for the form interface
*---------------------------------------------------------------------*
FORM select_business_data.
  SELECT * FROM  scustom                              "#EC CI_SGLSELECT
    INTO TABLE gt_customers
    WHERE id IN so_cust
    ORDER BY PRIMARY KEY.

  SELECT * FROM  sbook
    INTO TABLE gt_bookings
    WHERE customid IN so_cust AND
          carrid   IN so_carr
    ORDER BY PRIMARY KEY.
ENDFORM.                    "select_business_data

*---------------------------------------------------------------------*
*       FORM process_form                                             *
*---------------------------------------------------------------------*
FORM process_form
  CHANGING gv_subrc TYPE sy-subrc.

* call the generated function module of the form
  CALL FUNCTION ge_func_mod_name
    EXPORTING
      control_parameters = gs_control_params
      output_options     = gs_output_options
      user_settings      = space
      is_customer        = gs_customers
      ie_color           = pa_color
    TABLES
      it_bookings        = gt_bookings
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  CASE sy-subrc.
    WHEN 0.
      gv_subrc = 0.
    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
              DISPLAY LIKE 'E'.
      gv_subrc = sy-subrc.
  ENDCASE.

ENDFORM.                    "process_form

*---------------------------------------------------------------------*
*  FORM set_default_printer
*---------------------------------------------------------------------*
FORM set_default_printer.
  DATA:
    le_default_prn_text TYPE text70,
    le_titlebar         TYPE c LENGTH 70,
    le_answer           TYPE c LENGTH 1.

* If no default printer in user settings or if user has entered a
* different printer on the selection-screen, the user will be asked
* whether an entry should be made in table usr01.
  IF gs_usr01-spld <> pa_prnt.
    IF gs_usr01-spld IS INITIAL.
      le_titlebar = 'No printer in user setting'(dp1).      "#EC *
    ELSE.
      le_titlebar =
        'Default printer different on selection-screen'(dp2)."#EC *
    ENDIF.

    CONCATENATE pa_prnt ':' INTO le_default_prn_text.
    CONCATENATE le_default_prn_text text-dp3
      INTO le_default_prn_text SEPARATED BY space.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = le_titlebar
        text_question         = le_default_prn_text
        text_button_1         = text-yes
        text_button_2         = text-noh
        display_cancel_button = space
      IMPORTING
        answer                = le_answer.
    IF le_answer = '1'.
      gs_usr01-spld = pa_prnt(4).
      MODIFY usr01 FROM gs_usr01.
    ENDIF.
  ENDIF.

ENDFORM.                    " set_default_printer
