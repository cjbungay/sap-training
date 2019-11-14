*----------------------------------------------------------------------*
*       Report SAPBC480_SOLUTION_SIMPLE
*----------------------------------------------------------------------*
*       Printing of documents using PDF-based forms
*
*----------------------------------------------------------------------*


REPORT sapbc480_solution_simple MESSAGE-ID bc480.

DATA:
  gs_customer        TYPE scustom,
  gt_bookings        TYPE ty_bookings, "table of sbook
  gv_fm_name         TYPE rs38l_fnam,

* parameter for function module JOB_OPEN
  gs_outputparams    TYPE sfpoutputparams,

* parameters for calling the generated function module
  gs_docparams       TYPE sfpdocparams,

  r_error            TYPE REF TO cx_root.


**********************************************************************
* Selection screen
PARAMETERS:
  pa_form   TYPE fpwbformname DEFAULT 'BC480_SIMPLE' MODIF ID inv.

SELECTION-SCREEN SKIP.

* Data source settings
PARAMETERS:
  pa_cusid LIKE gs_customer-id DEFAULT 1.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_lang TYPE t005-spras MODIF ID inv OBLIGATORY,
  pa_cntry TYPE t005t-land1 OBLIGATORY MEMORY ID lnd
    MATCHCODE OBJECT country_for_param_spr.


**********************************************************************
INITIALIZATION.
  pa_lang = sy-langu.
  CASE sy-langu.
    WHEN 'D'.
      pa_cntry = 'DE'.
    WHEN 'E'.
      pa_cntry = 'US'.
    WHEN 'F'.
      pa_cntry = 'FR'.
    WHEN OTHERS.
      pa_lang = 'E'.
      pa_cntry = 'US'.
  ENDCASE.

**********************************************************************
* dynamic screen modifications
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'INV'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

**********************************************************************
* check country fits to user language
AT SELECTION-SCREEN ON pa_cntry.
  SELECT SINGLE land1
    FROM t005
    INTO pa_cntry
    WHERE land1 = pa_cntry AND
          spras = sy-langu.
  IF sy-dbcnt <> 1.
    MESSAGE e022 WITH sy-langu.
  ENDIF.

**********************************************************************
START-OF-SELECTION.
  SELECT SINGLE *
    FROM scustom
    INTO gs_customer
    WHERE id = pa_cusid.

  SELECT *
    FROM sbook
    INTO TABLE gt_bookings
    WHERE customid = gs_customer-id
    ORDER BY PRIMARY KEY.



************************************************************************
************************************************************************
* Relevant for form printing
************************************************************************
************************************************************************

* Please note that the error handling implemented here is very
* rudimentary!

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Get name of the generated function module
  TRY.
      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = 'BC480_SIMPLE'
        IMPORTING
          e_funcname = gv_fm_name.
    CATCH cx_root.
      MESSAGE e004 WITH pa_form.
* No active form &1 available
  ENDTRY.


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Open print job
  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = gs_outputparams
    EXCEPTIONS
      OTHERS          = 1.

  IF sy-subrc <> 0.
    MESSAGE e020.
* Form processing could not be started
  ENDIF.


* Set form language and country (->form locale)
  gs_docparams-langu   = pa_lang.
  gs_docparams-country = pa_cntry.


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Now call the generated function module
  CALL FUNCTION gv_fm_name
    EXPORTING
      /1bcdwb/docparams = gs_docparams
      is_customer       = gs_customer
      it_bookings       = gt_bookings
    EXCEPTIONS
      OTHERS            = 1.

  IF sy-subrc <> 0.
    MESSAGE e021.
  ENDIF.


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Close spool job
  CALL FUNCTION 'FP_JOB_CLOSE'.
