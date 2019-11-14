*----------------------------------------------------------------------*
*       Report SAPBC480_SOLUTION
*----------------------------------------------------------------------*
*       Printing of documents using PDF-based forms
*
*       Solution of exercise
*----------------------------------------------------------------------*

INCLUDE bc480_solutiontop.
INCLUDE bc480_solutione01.
INCLUDE bc480_solutionf01.



**********************************************************************
START-OF-SELECTION.
  CASE pa_url.
    WHEN c_intranet.
      gv_image_url = c_intranet_image.
    WHEN c_internet.
      gv_image_url = c_internet_image.
  ENDCASE.

  PERFORM select_business_data.


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
          i_name     = pa_form
        IMPORTING
          e_funcname = gv_fm_name.
    CATCH cx_root.
      MESSAGE e004 WITH pa_form.
* No active form &1 available
  ENDTRY.



*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Optional: Set output parameters
  gs_outputparams-nodialog = space.
  gs_outputparams-preview  = 'X'.

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


  LOOP AT gt_customers INTO gs_customer.
* Set form language and country (->form locale)
    gs_docparams-langu   = pa_lang.
    gs_docparams-country = pa_cntry.

    PERFORM find_bookings_for_customer.


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Now call the generated function module
    CALL FUNCTION gv_fm_name
      EXPORTING
        /1bcdwb/docparams  = gs_docparams
        is_customer        = gs_customer
        it_bookings        = gt_bookings
        it_sums            = gt_sums
        iv_image_url       = gv_image_url
        iv_sending_country = pa_cntry
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3
        OTHERS             = 4.

    IF sy-subrc <> 0.
      MESSAGE e021.
    ENDIF.

  ENDLOOP.

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Close spool job
  CALL FUNCTION 'FP_JOB_CLOSE'.
