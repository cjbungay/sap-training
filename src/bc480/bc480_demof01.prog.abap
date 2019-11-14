*&---------------------------------------------------------------------*
*&  Include           BC480_DEMOF01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  select_business_data
*&---------------------------------------------------------------------*
FORM select_business_data .
  DATA:
    lv_spfli_entries        TYPE sy-dbcnt,
    lv_bookings_count       TYPE sy-dbcnt,
    lv_bookings_per_carrier TYPE sy-dbcnt.

  SELECT * "#EC CI_SGLSELECT
    FROM scustom
    INTO TABLE gt_customers
    WHERE id IN so_cusid.
  CHECK sy-subrc = 0.

  IF pa_db IS NOT INITIAL.
    SELECT *
      FROM sbook
      INTO TABLE gt_all_bookings
      FOR ALL ENTRIES IN gt_customers
      WHERE customid = gt_customers-id
      ORDER BY PRIMARY KEY.
  ELSE.
* The user can decide how bookings should be selected from DB table
* SBOOK. This is helpful for testing dynamic page breaks.
* Mind however that this option will not reflect the actual bookings
* of the specific customer(s) entered on the selection-screen - you
* will get back as many random bookings per customer as you specify.
    SELECT COUNT(*) "#EC CI_BYPASS
      FROM spfli
      INTO lv_spfli_entries .
    lv_bookings_per_carrier = ( pa_numb - 1 ) DIV lv_spfli_entries + 1.

    SELECT carrid connid
      FROM spfli
      INTO (gs_booking-carrid, gs_booking-connid).
      SELECT *
        FROM sbook
        INTO gs_booking
        WHERE carrid = gs_booking-carrid AND
              connid = gs_booking-connid.
        APPEND gs_booking TO gt_bookings.
        ADD 1 TO lv_bookings_count.
        IF sy-dbcnt >= lv_bookings_per_carrier
          OR lv_bookings_count >= pa_numb.
          EXIT.
        ENDIF.
      ENDSELECT.
      IF lv_bookings_count >= pa_numb.
        EXIT.
      ENDIF.
    ENDSELECT.
  ENDIF.
  SORT gt_bookings BY carrid connid fldate bookid.
ENDFORM.                    " select_business_data

*&---------------------------------------------------------------------*
*&      Form  download_pdf
*&---------------------------------------------------------------------*
FORM download_pdf
  USING p_pdf_hex TYPE xstring
    p_number TYPE scustom-id
  CHANGING gv_download_ok TYPE c.
  DATA:
    lt_itab      TYPE TABLE OF x,
    lv_len       TYPE i,
    lv_filename  TYPE string VALUE 'XYZ.pdf',
    lv_separator VALUE '\',
    last         TYPE i.

  IF pa_path CS '/'.
    lv_separator = '/'.
  ENDIF.

*  FIND ALL OCCURRENCES OF lv_separator IN pa_path MATCH OFFSET last.
  PERFORM find_last_substring
              USING
                 pa_path
                 lv_separator
              CHANGING
                 last.

  IF pa_path+last <> lv_separator.
    last = STRLEN( pa_path ).
    pa_path+last = lv_separator.
  ENDIF.

  REPLACE 'X' IN lv_filename WITH pa_path.
  REPLACE 'Y' IN lv_filename WITH pa_form.
  REPLACE 'Z' IN lv_filename WITH p_number.

  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
    EXPORTING
      buffer        = p_pdf_hex
    IMPORTING
      output_length = lv_len
    TABLES
      binary_tab    = lt_itab.


  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      bin_filesize            = lv_len
      filename                = lv_filename
      filetype                = 'BIN'
    TABLES
      data_tab                = lt_itab
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc  <>  0.
    CLEAR gv_download_ok.
    MESSAGE e006.
*    Download failure
  ELSE.
    gv_download_ok = 'X'.
  ENDIF.
ENDFORM.                    "download_pdf


*&--------------------------------------------------------------------*
*&      Form  XSTRING_TO_SOLIX
*&--------------------------------------------------------------------*
FORM  xstring_to_solix
  USING ip_xstring TYPE xstring.

  DATA:
    lp_offset          TYPE i,
    lt_solix           TYPE solix_tab,
    ls_solix_line      TYPE solix,
    lp_pdf_string_len  TYPE i,
    lp_solix_rows      TYPE i,
    lp_last_row_length TYPE i,
    lp_row_length      TYPE i.

* transform xstring to SOLIX
  DESCRIBE TABLE lt_solix.
  lp_row_length = sy-tleng.
  lp_offset = 0.

  lp_pdf_string_len = XSTRLEN( ip_xstring ).

  lp_solix_rows = lp_pdf_string_len DIV lp_row_length.
  lp_last_row_length = lp_pdf_string_len MOD lp_row_length.
  DO lp_solix_rows TIMES.
    ls_solix_line-line =
           ip_xstring+lp_offset(lp_row_length).
    APPEND ls_solix_line TO pdf_content.
    ADD lp_row_length TO lp_offset.
  ENDDO.
  IF lp_last_row_length > 0.
    CLEAR ls_solix_line-line.
    ls_solix_line-line = ip_xstring+lp_offset(lp_last_row_length).
    APPEND ls_solix_line TO pdf_content.
  ENDIF.

ENDFORM.                    "XSTRING_TO_SOLIX

*&--------------------------------------------------------------------*
*&      Form  fax_or_mail_pdf
*&
*& Detail information on Business Communication Service can be found
*& in the SAP Library, Topic "Generic Business Tools for Application
*& Developers (BC-SRV-GBT)"
*&
*& See also standard demo reports BCS_EXAMPLE_...
*&
*&--------------------------------------------------------------------*

FORM fax_or_mail_pdf
  USING p_fax_or_mail TYPE c.

* BCS data
  DATA:
    send_request    TYPE REF TO cl_bcs,
    document        TYPE REF TO cl_document_bcs,
    recipient       TYPE REF TO if_recipient_bcs,
    bcs_exception   TYPE REF TO cx_bcs,
    lv_sent_to_all  TYPE os_boolean,
    lp_pdf_size     TYPE so_obj_len.



* ------------ Call BCS interface ----------------------------------

  TRY.
*   ---------- create persistent send request ----------------------
      send_request = cl_bcs=>create_persistent( ).

*   ---------- add document ----------------------------------------
*   get PDF xstring and convert it to BCS format
      lp_pdf_size = XSTRLEN( gs_result-pdf ).

      PERFORM xstring_to_solix
                  USING
                     gs_result-pdf.

      document = cl_document_bcs=>create_document(
            i_type    = 'PDF' " cf. RAW, DOC
            i_hex     = pdf_content
            i_length  = lp_pdf_size
            i_subject = 'test created by BC480_DEMO' ).     "#EC NOTEXT

*   add document to send request
      send_request->set_document( document ).


*     --------- set sender -------------------------------------------
*     note: this is necessary only if you want to set the sender
*           different from actual user (SY-UNAME). Otherwise sender is
*           set automatically with actual user.
*
*      sender = cl_sapuser_bcs=>create( sy-uname ).
*      CALL METHOD send_request->set_sender
*        EXPORTING i_sender = sender.


*   ---------- add recipient (e-mail address) ----------------------
      CASE p_fax_or_mail.
        WHEN 'F' OR 'f'.
          recipient = cl_cam_address_bcs=>create_fax_address(
              i_country = pa_faxct
              i_number  = pa_faxno ).

        WHEN 'M' OR 'm'.
          recipient = cl_cam_address_bcs=>create_internet_address(
              i_address_string = pa_addr ).
      ENDCASE.


*   add recipient to send request
      send_request->add_recipient( i_recipient = recipient ).

*   ---------- send document ---------------------------------------
      lv_sent_to_all = send_request->send(
          i_with_error_screen = 'X' ).

      IF lv_sent_to_all = 'X'.
        MESSAGE i022(so).
      ENDIF.

*   ---------- explicit 'commit work' is mandatory! ----------------
      COMMIT WORK.

* ------------------------------------------------------------------
* *            exception handling
* ------------------------------------------------------------------
* * replace this very rudimentary exception handling
* * with your own one !!!
* ------------------------------------------------------------------
    CATCH cx_bcs INTO bcs_exception.
      MESSAGE e019 WITH bcs_exception->error_type.
*     Sending fax/mail failed
      EXIT.

  ENDTRY.
ENDFORM.                    "mail_pdf


*&---------------------------------------------------------------------*
*&      Form  graphic_file_from_PC
*&---------------------------------------------------------------------*
* This form uploads a graphic file from the location entered on the
* selection screen
* The file name (and its MIME type) is passed on to the generated
* function module, to be used for an image of type "graphic content".
*&---------------------------------------------------------------------*
FORM graphic_file_from_pc .
  DATA:
    gt_graphic TYPE TABLE OF x,"hexline,
    gs_graphic LIKE LINE OF gt_graphic.

  IF pa_image IS NOT INITIAL.
    image_upload_filename = pa_image.
    CALL FUNCTION 'GUI_UPLOAD'
      EXPORTING
        filename = image_upload_filename
        filetype = 'BIN'
      TABLES
        data_tab = gt_graphic
      EXCEPTIONS
        OTHERS   = 17.
    IF sy-subrc <> 0.
      " then we do not have a file :-(
    ENDIF.
    LOOP AT gt_graphic INTO gs_graphic.
      CONCATENATE gv_image_file gs_graphic
        INTO gv_image_file IN BYTE MODE.
    ENDLOOP.
  ENDIF.
ENDFORM.                    " graphic_file_from_PC

*&--------------------------------------------------------------------*
*&      Form  find_last_substring
*&--------------------------------------------------------------------*
FORM find_last_substring
  USING i_string "TYPE string
        i_substring "TYPE string
  CHANGING c_position TYPE i.

  DATA:
    lv_string TYPE string,
    lv_position TYPE i.

  lv_string = i_string. c_position = 0.
  DO.
    FIND i_substring IN lv_string MATCH OFFSET lv_position.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
    lv_position = lv_position + 1.
    lv_string = lv_string+lv_position.
    c_position = c_position + lv_position.
  ENDDO.
  c_position = c_position - 1.
ENDFORM.                    "find_last_substring
