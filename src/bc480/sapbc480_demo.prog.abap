*----------------------------------------------------------------------*
*       Report SAPBC480_DEMO
*----------------------------------------------------------------------*
*       Printing of documents using PDF-based forms
*----------------------------------------------------------------------*

INCLUDE bc480_demotop.
INCLUDE bc480_demo_sel_screen_events.
INCLUDE bc480_demof01.


**********************************************************************
START-OF-SELECTION.
  CASE pa_url.
    WHEN c_intranet.
      gv_url = c_intranet_image.
    WHEN c_internet.
      gv_url = c_internet_image.
  ENDCASE.

  PERFORM graphic_file_from_pc.

  PERFORM select_business_data.
  CHECK sy-dbcnt > 0.


************************************************************************
* Relevant for form printing
************************************************************************
* Get name of the generated function module
  TRY.
      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name           = pa_form
        IMPORTING
          e_funcname       = gv_fm_name
          e_interface_type = interface_type.
    CATCH cx_root INTO r_error.
      error_string = r_error->get_text( ).
      MESSAGE error_string TYPE 'E'.
  ENDTRY.

* Set output parameters for old interface
  old_control_params-no_dialog = pa_nodlg.
  old_control_params-preview   = pa_prev.
  old_output_options-tddest    = pa_prnt.

* Set output parameters for new interface
  gs_outputparams-nodialog = pa_nodlg.    " show printer dialog popup
  gs_outputparams-preview  = pa_prev.     " launch print preview
  gs_outputparams-dest     = pa_prnt.     " set printer
  gs_outputparams-nopdf    = pa_nopdf.
  gs_outputparams-reqnew   = pa_newid.

* determine RFC destination for Adobe Document Services
  gs_outputparams-connection = pa_rfc.

  IF pa_gui = 'X' OR pa_mail = 'X' OR pa_fax = 'X'.
    gs_outputparams-getpdf = 'X'.
  ENDIF.

* Print job needs to be opened exclusively for forms of new interface
  IF interface_type <> 'S'.
    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = gs_outputparams
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
  ENDIF.


* enable interactive features
  gs_docparams-fillable = pa_fill.

  LOOP AT gt_customers INTO gs_customer.
* Set form language and country (->form locale)
    IF pa_cnfix = 'X'.
* new interface
      gs_docparams-langu   = pa_lang.
      gs_docparams-country = pa_cntry.
* Smart Forms compatible interface
      old_control_params-langu = pa_lang.
      SET COUNTRY pa_cntry.
    ELSE.
* new interface
      gs_docparams-langu   = gs_customer-langu.
      gs_docparams-country = gs_customer-country.
* Smart Forms compatible interface
      old_control_params-langu = gs_customer-langu.
      SET COUNTRY gs_customer-country.
    ENDIF.


    IF pa_db IS NOT INITIAL.
      CLEAR: gt_bookings, gt_sums.

* build internal table that contains only the bookings for the
* current customer
* required only for selection-screen setting "Bookings from database"
      LOOP AT gt_all_bookings
        INTO gs_booking
        WHERE customid = gs_customer-id.
        APPEND gs_booking TO gt_bookings.

* currency key dependent summing
        gs_sums-price  = gs_booking-forcuram.
        gs_sums-currency = gs_booking-forcurkey.
        COLLECT gs_sums INTO gt_sums.
      ENDLOOP.

    ELSE.
      LOOP AT gt_bookings
        INTO gs_booking.

* currency key dependent summing
        gs_sums-price  = gs_booking-forcuram.
        gs_sums-currency = gs_booking-forcurkey.
        COLLECT gs_sums INTO gt_sums.
      ENDLOOP.
    ENDIF.

**************************************************
* Now call the generated function module
**************************************************
    CALL FUNCTION gv_fm_name
      EXPORTING
* parameters for Smart Forms compatible interface
        control_parameters = old_control_params
        output_options     = old_output_options
        user_settings      = space
* parameter for new interface
       /1bcdwb/docparams   = gs_docparams
* parameters for both interfaces
       is_customer         = gs_customer
       it_bookings         = gt_bookings
       it_sums             = gt_sums
       iv_image_url        = gv_url
       iv_image_file       = gv_image_file
       iv_mime_type        = gv_mime_type
       iv_sending_country  = pa_send
       iv_sf_text          = pa_sftxt
       iv_so10_text        = pa_so10
     IMPORTING
* parameters for Smart Forms compatible interface
       document_output_info = old_document_output_info	
       job_output_info      = old_job_output_info
       job_output_options   = old_job_output_options
* parameter for new interface
       /1bcdwb/formoutput   = gs_result

     EXCEPTIONS
* exceptions of SmartForms compatible interface
       formatting error   = 1
       send_error         = 2
       user_canceled      = 3
* exceptions of new interface
       usage_error        = 4
       system_error       = 5
* exceptions of both interfaces
       internal_error     = 6
       OTHERS             = 7.

    gv_subrc = sy-subrc.
    CASE sy-subrc.
      WHEN 0.
        IF interface_type = 'S' AND pa_spool = 'X'
          AND pa_prev IS INITIAL.
          MESSAGE i017.
        ENDIF.

      WHEN OTHERS.
        CALL FUNCTION 'FP_GET_LAST_ADS_ERRSTR'
          IMPORTING
            e_adserrstr = error_string.
        IF NOT error_string IS INITIAL.
*     we received a detailed error description
          MESSAGE error_string TYPE 'E'.
          EXIT.
          EXIT.
        ELSE.
          IF sy-msgid IS NOT INITIAL AND sy-msgno IS NOT INITIAL.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH
              sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ELSE.
            MESSAGE e018 WITH gv_subrc.
* Form processing error: return code = &1
          ENDIF.
        ENDIF.
    ENDCASE.


    CASE 'X'.
      WHEN pa_gui.
        IF sy-batch = 'X'.
          WRITE: 'Download not possible in background'(eba).
        ELSE.
          PERFORM download_pdf
            USING gs_result-pdf gs_customer-id
            CHANGING gv_download_ok.
        ENDIF.

      WHEN pa_mail.
        PERFORM fax_or_mail_pdf USING 'M'.

      WHEN pa_fax.
        PERFORM fax_or_mail_pdf USING 'F'.
    ENDCASE.
  ENDLOOP.

  IF pa_gui = 'X'.
    IF gv_download_ok = 'X'.
      MESSAGE s016 WITH pa_path 'BC480...pdf'.
    ELSE.
      MESSAGE e006. " Download failure
    ENDIF.
  ENDIF.

* Close spool job
  IF interface_type <> 'S'.
    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    CASE sy-subrc.
      WHEN 0.
        IF pa_spool = 'X' AND pa_prev IS INITIAL.
          MESSAGE i017.
        ENDIF.
      WHEN OTHERS.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDCASE.
  ENDIF.
