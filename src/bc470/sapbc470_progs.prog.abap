**************************************************************
*  Solution for the exercise of unit 8 of BC470
**************************************************************

REPORT  sapbc470_progs.
DATA:
  gt_bookings   TYPE ty_bookings,
  gs_booking    TYPE sbook,
  gt_customers  TYPE ty_customers,
  gs_customer   TYPE scustom,
  ge_color      TYPE tdbtype.

DATA:
  ge_func_mod_name TYPE rs38l_fnam.

DATA:
  gs_output_options TYPE ssfcompop,       " optional part of exercise
  gs_control_params TYPE ssfctrlop.   " optional part of exercise


* selection-screen
SELECT-OPTIONS:
  so_cust FOR gs_customer-id DEFAULT 1    TO 3,
  so_carr FOR gs_booking-carrid    DEFAULT 'AA' TO 'LH'.

* printing options
SELECTION-SCREEN SKIP 1.
PARAMETERS:
  pa_prnt  TYPE tsp01-rqdest VALUE CHECK DEFAULT 'P280'
    OBLIGATORY VISIBLE LENGTH 4.

* graphics
SELECTION-SCREEN SKIP 2.
SELECTION-SCREEN COMMENT 1(30) text-se2.
PARAMETERS:
  pa_col     RADIOBUTTON GROUP col,
  pa_mon     RADIOBUTTON GROUP col DEFAULT 'X'.


********************************************************************
START-OF-SELECTION.

* set ge_color for company logo
  IF pa_col = 'X'.
    ge_color = 'BCOL'.
  ELSE.
    ge_color = 'BMON'.
  ENDIF.


  SELECT * FROM  scustom "#EC CI_SGLSELECT
    INTO TABLE gt_customers
    WHERE id IN so_cust
    ORDER BY PRIMARY KEY.

  SELECT * FROM  sbook
    INTO TABLE gt_bookings
    WHERE customid IN so_cust AND
          carrid   IN so_carr
    ORDER BY PRIMARY KEY.




********************************************************************
********************************************************************
* Your Coding here:

* find out the name of the generated function module
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'BC470_FLOWS'
    IMPORTING
      fm_name            = ge_func_mod_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


* set output options (optional)
  gs_output_options-tddest = pa_prnt.

  gs_control_params-no_dialog = 'X'.
  gs_control_params-preview = 'X'.


* process the form for every customer in gt_customers
  LOOP AT gt_customers
    INTO gs_customer.

* make sure only one spool request is used
    AT FIRST.
      gs_control_params-no_close = 'X'.
    ENDAT.
    AT LAST.
      gs_control_params-no_close = space.
    ENDAT.

* call the generated function module
    CALL FUNCTION ge_func_mod_name
       EXPORTING
* The following three parameters belong to the optional
* part of the exercise.
            control_parameters = gs_control_params
            output_options     = gs_output_options
            user_settings      = space

            is_customer        = gs_customer
            ie_color           = ge_color
       TABLES
            it_bookings        = gt_bookings
       EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    gs_control_params-no_open = 'X'.
  ENDLOOP.
