*&---------------------------------------------------------------------*
*& Report  SAPBC470_FLOWD_LABELS
*&
*&---------------------------------------------------------------------*
*&
*& Demo Program for labels with SAP Smart Forms
*&
*& uses table SBOOK - NOT the Central Address Management!
*&
*&---------------------------------------------------------------------*

REPORT  sapbc470_flowd_labels.
DATA:
  ge_func_mod_name  TYPE rs38l_fnam,
  gs_control_params TYPE ssfctrlop,
  gs_output_options TYPE ssfcompop,

  gt_customers      TYPE ty_customers,
  gs_customer       TYPE scustom.

* selection-screen
PARAMETERS: pa_form LIKE ssfscreen-fname DEFAULT 'BC470_FLOWD_LABELS'.
SELECT-OPTIONS:
  so_cust FOR gs_customer-id   DEFAULT 1    TO 10.




*******************************************************************
START-OF-SELECTION.
* set output options
  gs_output_options-tdnewid       = 'X'.

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
      SELECT * FROM  scustom                          "#EC CI_SGLSELECT
        INTO TABLE gt_customers
        WHERE id IN so_cust
        ORDER BY PRIMARY KEY.
      PERFORM process_form.
    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDCASE.



*---------------------------------------------------------------------*
FORM process_form.
* call the generated function module of the form
  CALL FUNCTION ge_func_mod_name
    EXPORTING
      control_parameters = gs_control_params
      output_options     = gs_output_options
    TABLES
      gt_customers       = gt_customers
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  CASE sy-subrc.
    WHEN 0.
    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDCASE.
ENDFORM.                    "process_form
