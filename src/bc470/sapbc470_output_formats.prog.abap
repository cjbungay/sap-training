*&---------------------------------------------------------------------*
*& Report  SAPBC470_OUTPUT_FORMATS
*&---------------------------------------------------------------------*
*&                                                                     *
*& Shows available output formats of SAP Smart Forms
*&---------------------------------------------------------------------*

REPORT  sapbc470_output_formats MESSAGE-ID bc470.
TYPES: ty_hex1024(1024) TYPE x,
  ty_it_hex1024 TYPE TABLE OF ty_hex1024,

  ty_char1024(1024) TYPE c,
  ty_it_char1024 TYPE TABLE OF ty_char1024.

DATA:
  gs_usr01          TYPE usr01,
  ge_func_mod_name  TYPE rs38l_fnam,
  gs_control_params TYPE ssfctrlop,
  gs_output_options TYPE ssfcompop,

  gt_bookings      TYPE ty_bookings,
  gs_booking       TYPE sbook,
  gt_customers     TYPE ty_customers,
  gs_customer      TYPE scustom,
  ge_color         TYPE tdbtype,
  return_code      TYPE sy-subrc,
  return_boolean   TYPE c,
  gt_return        TYPE ssfcrescl,
  spool_id         TYPE LINE OF ssfcrescl-spoolids,
  gs_otf           TYPE LINE OF ssfcrescl-otfdata,
  wa_css           LIKE LINE OF gt_return-xmloutput-stsheet-fmtcontent,

  html_length      TYPE i,
  gt_html          TYPE ty_it_char1024,

  url_string       TYPE string,
  url              TYPE c LENGTH 1024,
  pagename         TYPE o2pagename,
  bsp              TYPE REF TO cl_o2_api_pages,
  file_name        TYPE string.

* selection-screen
PARAMETERS:
  pa_form LIKE ssfscreen-fname,
  pa_cust LIKE gs_customer-id DEFAULT 3.

SELECT-OPTIONS:
  so_carr FOR gs_booking-carrid DEFAULT 'AA' TO 'LH' NO-EXTENSION.

* printer
SELECTION-SCREEN SKIP 2.
PARAMETERS:
  pa_prnt TYPE tsp03-padest VISIBLE LENGTH 4,
  pa_copy TYPE ssfcompop-tdcopies.

* Graphics
* These settings are relevant only for certain forms!
SELECTION-SCREEN SKIP 3.
SELECTION-SCREEN COMMENT 1(60) text-se1.
PARAMETERS:
  pa_col     RADIOBUTTON GROUP col,
  pa_mon     RADIOBUTTON GROUP col DEFAULT 'X'.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK output WITH FRAME TITLE text-se2.
PARAMETERS:
  pa_norm RADIOBUTTON GROUP out USER-COMMAND rad,
  pa_otf  RADIOBUTTON GROUP out,
  pa_pdf  RADIOBUTTON GROUP out,
  pa_xsf  RADIOBUTTON GROUP out,
  pa_bsp  RADIOBUTTON GROUP out.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:
pa_html RADIOBUTTON GROUP out.
SELECTION-SCREEN COMMENT 3(20) TEXT-htm FOR FIELD pa_html.
SELECTION-SCREEN POSITION POS_LOW.
"SELECTION-SCREEN POSITION 40.
PARAMETERS:
  pa_file(80) DEFAULT 'c:\B470_DEMO.HTML'
    MODIF ID htm VISIBLE LENGTH 40.
SELECTION-SCREEN END OF LINE.
PARAMETERS:
  pa_css  RADIOBUTTON GROUP out,
  pa_xdf  RADIOBUTTON GROUP out.
SELECTION-SCREEN END OF BLOCK output.


*******************************************************************
INITIALIZATION.
* set form name using SAP memory
  GET PARAMETER ID 'SSFNAME' FIELD pa_form.
  IF pa_form IS INITIAL.
    pa_form = 'BC470_STEPT'.
  ENDIF.

  SELECT SINGLE *
  FROM usr01
    INTO gs_usr01
  WHERE bname = sy-uname.

  IF gs_usr01-spld IS INITIAL.
    pa_prnt = 'LP01'.
  ELSE.
    pa_prnt = gs_usr01-spld.
  ENDIF.

*******************************************************************
AT SELECTION-SCREEN ON pa_form.
  SELECT SINGLE stxfadm~formname
    FROM stxfadm
    INNER JOIN stxfadmi
    ON stxfadm~formname = stxfadmi~formname
    INTO pa_form
    WHERE stxfadm~formname = pa_form AND formtype = space.
  IF sy-dbcnt = 0.
    MESSAGE e001 WITH pa_form. " function module does not exist
  ENDIF.

  CALL FUNCTION 'BC470_CHECK_FORM_IS_OK'
    EXPORTING
      smart_form_name = pa_form
    EXCEPTIONS
      no_form         = 1
      not_suitable    = 2
      OTHERS          = 3.
  CASE sy-subrc.
    WHEN 1 OR 2.
      MESSAGE e002 WITH pa_form. " unsuitable interface
  ENDCASE.

*******************************************************************
AT SELECTION-SCREEN ON BLOCK output.
  IF pa_file IS INITIAL AND NOT pa_html IS INITIAL.
    MESSAGE e027.
  ENDIF.

* check whether file exists
  IF NOT pa_html IS INITIAL.
    file_name = pa_file.
    CALL METHOD cl_gui_frontend_services=>file_exist
      EXPORTING
        file   = file_name
      RECEIVING
        result = return_boolean
      EXCEPTIONS
        OTHERS = 5.

    IF sy-subrc <> 0.
      MESSAGE e028.
    ENDIF.

    IF return_boolean = 'X'.
      MESSAGE e029 WITH file_name.
    ENDIF.
  ENDIF.

*******************************************************************
START-OF-SELECTION.
  SET PARAMETER ID 'SSFNAME' FIELD pa_form.

* set output options
  IF pa_prnt IS INITIAL.
    gs_output_options-tddest      = 'P280'.
  ELSE.
    gs_output_options-tddest      = pa_prnt.
  ENDIF.

  gs_output_options-tdimmed       = space.
  gs_output_options-tdnewid       = 'X'.
  gs_output_options-tdcopies      = pa_copy.


  CASE 'X'.
    WHEN pa_norm.
      gs_control_params-preview   = 'X'.

    WHEN pa_otf OR pa_pdf.
      gs_control_params-getotf = 'X'.
      gs_control_params-preview   = space.

    WHEN pa_xsf.
      gs_output_options-xsfcmode = 'X'. " override XML settings of form
      gs_output_options-xsf        = 'X'.   " XML output instead of OTF
      gs_output_options-xsfoutmode = 'S'.   " create spool request
      gs_output_options-xsfformat  = space. " no CSS or HTML
      gs_control_params-preview    = space.

    WHEN pa_html OR pa_css.
      gs_output_options-xsfcmode = 'X'. " override XML settings of form
      gs_output_options-xsf        = 'X'.   " XML output instead of OTF
      gs_output_options-xsfoutmode = 'A'. " send data to application
      gs_output_options-xsfformat  = 'X'.   " HTML with CSS
      gs_control_params-preview    = 'X'.
      gs_output_options-xsfaction  = 'RESULT.HTM'.

    WHEN pa_xdf.
      gs_output_options-xdfcmode = 'X'. " override XDF settings of form
      gs_output_options-xdf      = 'X'. " XDF output instead of OTF
      gs_output_options-xdfoutmode = 'S'.    " create spool request
      gs_output_options-xdfoutdev  = pa_prnt.
      gs_control_params-preview   = 'X'.

  ENDCASE.

  gs_control_params-no_dialog = 'X'.

* set color for company logo
  IF pa_col = 'X'.
    ge_color = 'BCOL'.
  ELSE.
    ge_color = 'BMON'.
  ENDIF.

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
        INTO gs_customer.
* set decimal notation and date format according to
* addressee's country
        SET COUNTRY gs_customer-country.

        AT FIRST.
          gs_control_params-no_close = 'X'.
        ENDAT.
        AT LAST.
          gs_control_params-no_close = space.
        ENDAT.
        PERFORM process_form CHANGING return_code.
        IF return_code NE 0.
          EXIT.
        ENDIF.
        gs_control_params-no_open = 'X'.
      ENDLOOP.

* different output according to radiobuttons
      IF return_code EQ 0.
        CASE 'X'.
          WHEN pa_otf.

            LOOP AT gt_return-otfdata INTO gs_otf.
              WRITE: / gs_otf-tdprintcom COLOR COL_KEY,
                       gs_otf-tdprintpar.
            ENDLOOP.

          WHEN pa_pdf.
            CALL FUNCTION 'SSFCOMP_PDF_PREVIEW'
              EXPORTING
                i_otf                    = gt_return-otfdata
              EXCEPTIONS
                convert_otf_to_pdf_error = 1
                cntl_error               = 2
                OTHERS                   = 3.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.

          WHEN pa_css.
            LOOP AT gt_return-xmloutput-stsheet-fmtcontent INTO wa_css.
              WRITE: / wa_css.
            ENDLOOP.

          WHEN pa_html.
            PERFORM convert_xstring_it_to_char_it
              USING    gt_return-xmloutput-trfresult-content
              CHANGING gt_html
                       html_length.

            file_name = pa_file.
            CALL METHOD cl_gui_frontend_services=>gui_download
              EXPORTING
                bin_filesize = html_length
                filename     = file_name
                write_lf     = space
                filetype     = 'BIN'
              CHANGING
                data_tab     = gt_html
              EXCEPTIONS
                OTHERS       = 24.

            IF sy-subrc <> 0.
              MESSAGE i026.
            ENDIF.

* display the downloaded HTML file in the Internet Explorer
            CALL FUNCTION 'CALL_BROWSER'
              EXPORTING
                url    = pa_file
              EXCEPTIONS
                OTHERS = 6.
            IF sy-subrc <> 0.
              WRITE: text-bro. "'Browser could not be started'.
            ENDIF.

          WHEN pa_bsp.
*   get URL for BSP to display the form
            pagename-applname = 'BC470_WAS'.
            pagename-pagename = 'SHOW_SMART_FORM.HTM'.
            CALL METHOD cl_o2_helper=>generate_url_for_page
              EXPORTING
                p_page        = pagename
                p_secure_http = space
              IMPORTING
                p_url         = url_string
              EXCEPTIONS
                OTHERS        = 1.
            url = url_string.

            CONCATENATE url
              '?carrier_low=' so_carr-low
              '&carrier_high=' so_carr-high
              '&customer=' pa_cust
              '&smart_form=' pa_form
              '&sap-client=' sy-mandt
              '&sap-language=' sy-langu
             INTO url.

            CALL FUNCTION 'CALL_BROWSER'
              EXPORTING
                url    = url
              EXCEPTIONS
                OTHERS = 6.
            IF sy-subrc <> 0.
              WRITE: text-bro. "'Browser could not be started'.
            ENDIF.

          WHEN pa_xsf OR pa_xdf.
            READ TABLE gt_return-spoolids INTO spool_id INDEX 1.
            CALL FUNCTION 'RSPO_DISPLAY_SPOOLJOB'
              EXPORTING
                rqident              = spool_id
              EXCEPTIONS
                no_such_job          = 1
                job_contains_no_data = 2
                selection_empty      = 3
                no_permission        = 4
                can_not_access       = 5
                read_error           = 6
                OTHERS               = 7.
            IF sy-subrc <> 0.
              MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            ENDIF.
* Other method: set fields xdfoutmode/xsfdfoutmode of parameter
* gs_output_options to A (application) and convert result
* from raw to xstring.
*            DATA: xml_xstring TYPE xstring.
*            LOOP AT it_return-xmloutput-xsfdata INTO wa_xsf.
*              CONCATENATE xml_xstring wa_xsf
*                INTO xml_xstring IN BYTE MODE.
*            ENDLOOP.
*            PERFORM convert_xstring_to_char
*                        USING
*                           xml_xstring.

        ENDCASE.
      ENDIF.

    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDCASE.


*---------------------------------------------------------------------*
*       FORM select_business_data
*---------------------------------------------------------------------*
*   fill the tables for the form interface
*---------------------------------------------------------------------*
FORM select_business_data.
  SELECT * FROM  scustom "#EC CI_SGLSELECT
    INTO TABLE gt_customers
    WHERE id = pa_cust
    ORDER BY PRIMARY KEY.

  SELECT * FROM  sbook
    INTO TABLE gt_bookings
    FOR ALL ENTRIES IN gt_customers
    WHERE customid = gt_customers-id AND
          carrid   IN so_carr
    ORDER BY PRIMARY KEY.

ENDFORM.                    "select_business_data

*---------------------------------------------------------------------*
*       FORM process_form
*---------------------------------------------------------------------*
FORM process_form
  CHANGING return_code TYPE i.

* call the generated function module of the form
  CALL FUNCTION ge_func_mod_name
    EXPORTING
      control_parameters = gs_control_params
      output_options     = gs_output_options
      user_settings      = space
      is_customer        = gs_customer
      ie_color           = ge_color
    IMPORTING
      job_output_info    = gt_return
    TABLES
      it_bookings        = gt_bookings
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      my_exception       = 5
      OTHERS             = 6.
  CASE sy-subrc.
    WHEN 0.
      return_code = 0.
    WHEN OTHERS.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      return_code = -1.
  ENDCASE.

ENDFORM.                    "select_business_data


*&---------------------------------------------------------------------*
*&      Form  convert_xstring_it_to_char_it
*&---------------------------------------------------------------------*
*       Reads an internal table of hex(1024) and returns an internal
*       table of char(1024).
*&---------------------------------------------------------------------*
FORM convert_xstring_it_to_char_it
  USING    p_it_hex   TYPE ty_it_hex1024
  CHANGING p_it_char  TYPE ty_it_char1024
           p_c_length TYPE i.

  TYPES ctype         TYPE c LENGTH 1.

  DATA:
    xhelp             TYPE x LENGTH 4,
    pos               TYPE sy-index,

    wa_char           TYPE ty_char1024,
    wa_xstring        TYPE xstring.

  FIELD-SYMBOLS <fs> TYPE ANY.

  LOOP AT p_it_hex
    INTO wa_xstring.
    CLEAR wa_char.
    DO 1024 TIMES.
      xhelp = wa_xstring.
      pos = sy-index - 1.

      ASSIGN xhelp TO <fs> CASTING TYPE ctype.
      ADD 1 TO p_c_length.
      SHIFT wa_xstring BY 1 PLACES LEFT IN BYTE MODE.

*     CONCATENATE wa <fs> INTO wa_char.
      " simple concatenate does not work because of spaces in HTML!
      wa_char+pos = <fs>.
    ENDDO.
    APPEND wa_char TO p_it_char.
  ENDLOOP.
ENDFORM.                    " convert_xstring_it_to_char_it



*---------------------------------------------------------------------*
*  FORM convert_xstring_to_char
* Converts a hexadecimal string to an internal table with one character
* per line and prints the resulting characters.
* Could be used if the XDF output should be sent to the application and
* not to the spool.
*---------------------------------------------------------------------*
FORM convert_xstring_to_char                                "#EC CALLED
  CHANGING p_xstring TYPE xstring
  p_xstr_length TYPE i.

  TYPES ctype(1) TYPE c.

  DATA:
    c_string TYPE string,
    xhelp(4) TYPE x,

    it TYPE TABLE OF c,
    wa.

  FIELD-SYMBOLS <fs> TYPE ANY.

  DO.
    xhelp = p_xstring.

    ASSIGN xhelp TO <fs> CASTING TYPE ctype.

    SHIFT p_xstring BY 1 PLACES LEFT IN BYTE MODE.

    APPEND <fs> TO it.
    CONCATENATE c_string <fs> INTO c_string.

    IF p_xstring IS INITIAL.
      p_xstr_length  = sy-index - 1.
      EXIT.
    ENDIF.
  ENDDO.
  LOOP AT it INTO wa.
    WRITE wa NO-GAP.
  ENDLOOP.
ENDFORM.                    "convert_xstring_to_char
