*&---------------------------------------------------------------------*
*&  Include           BC480_DEMOTOP
*&---------------------------------------------------------------------*
REPORT sapbc480_demo MESSAGE-ID bc480.

* Dropdown list for image requires a type pool
TYPE-POOLS: vrm.

* Data declaration
CONSTANTS:
  c_internet(20) VALUE 'INTERNET',
  c_intranet(20) VALUE 'INTRANET',
  c_internet_image(255) VALUE
    'http://www.sap.com/global/images/sap_logo.gif',
  c_intranet_image(255) VALUE
"    'http://wts:1080/portal/corp/pictures/sap_logo.gif'.
   'http://wts.wdf.sap.corp:1080/portal/Image/sap_logo.gif'.

DATA:
  gt_customers       TYPE TABLE OF scustom,
  gs_customer        LIKE LINE OF gt_customers,
  gt_all_bookings    TYPE ty_bookings,
  gt_bookings        TYPE ty_bookings, "table of sbook
  gs_booking         LIKE LINE OF gt_bookings,
  gt_sums            TYPE flpricet,
  gs_sums            LIKE LINE OF gt_sums,
  gv_url             TYPE string,
  gv_image_file      TYPE xstring,
  gv_mime_type       TYPE string,
  gv_fm_name         TYPE rs38l_fnam,
  interface_type     TYPE fpinterfacetype,

* parameters for calling the generated function module
* for new interface
  gs_docparams       TYPE sfpdocparams,
  gs_outputparams    TYPE sfpoutputparams,
  gs_result          TYPE fpformoutput,


* for Smart Forms compatible interface
  old_control_params TYPE ssfctrlop,
  old_output_options TYPE ssfcompop,

  old_document_output_info TYPE ssfcrespd,
  old_job_output_info      TYPE ssfcrescl,
  old_job_output_options   TYPE ssfcresop,

  r_error            TYPE REF TO cx_root,
  error_string       TYPE string,

* for mailing
  pdf_content        TYPE solix_tab,


* flags
  gv_advanced,
  gv_sundries,  " ADS/interactive features on sel.screen?
  gv_proc_type, " advanced procssing (fax/mail) on sel. screen?
  gv_max, " dynamic text module and graphic content on sel. screen?
  gv_download_ok,

* help fields
  gs_land                TYPE t005,
  downl_path             TYPE string,
  upl_path               TYPE string,
  image_upload_filename  TYPE string,
  gv_file_filter         TYPE string,
  gv_window_text         TYPE string,
  file_exists,
  dot                    TYPE i,
  last_char              TYPE i,
  old_radio_button(10)   VALUE 'PA_SPOOL',
  gv_subrc               TYPE sy-subrc,

* Dropdown list for image on selection-screen must be filled
  field_for_dropdown     TYPE vrm_id,
  gt_values              TYPE vrm_values,
  gs_values              LIKE LINE OF gt_values,


* ranges tables for switching between different customers,
* depending on user's selection on the screen
  ra_cus1 LIKE RANGE OF gs_customer-id,
  ra_cus2 LIKE RANGE OF gs_customer-id,
  ra_cus1_line LIKE LINE OF ra_cus1.


**********************************************************************
* Selection screen
PARAMETERS:
  pa_form   TYPE fpwbformname MEMORY ID fpwbform MODIF ID sho
            OBLIGATORY MATCHCODE OBJECT hfpwbform.

SELECTION-SCREEN SKIP.

SELECT-OPTIONS:
  so_cusid FOR gs_customer-id DEFAULT 1 MODIF ID cus.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN PUSHBUTTON /1(30) push01 USER-COMMAND
  advanced MODIF ID sho.

SELECTION-SCREEN SKIP.

* Data source settings
SELECTION-SCREEN BEGIN OF SCREEN 110 AS SUBSCREEN.
PARAMETERS:
  pa_any RADIOBUTTON GROUP sel USER-COMMAND toggle_customers,
  pa_four RADIOBUTTON GROUP sel.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK number_of_bookings.
PARAMETERS:
  pa_db RADIOBUTTON GROUP book USER-COMMAND toggle_bookings,
  pa_no_db RADIOBUTTON GROUP book,
  pa_numb TYPE i MODIF ID num MEMORY ID number_of_bookings. "#EC EXISTS
SELECTION-SCREEN END OF BLOCK number_of_bookings.
SELECTION-SCREEN SKIP.
PARAMETERS:
  pa_url LIKE gs_values-key AS LISTBOX VISIBLE LENGTH 40
    MEMORY ID graphic_from_url,                             "#EC EXISTS
  pa_image TYPE text255 MEMORY ID graphic_from_upload       "#EC EXISTS
    MODIF ID min.

SELECTION-SCREEN SKIP.

PARAMETERS:
" long texts (text module/SAPscrip text)
  pa_sftxt TYPE ssfscreen-tname MEMORY ID ssftxtname
    MATCHCODE OBJECT sh_stxfadm MODIF ID min,
  pa_so10  TYPE stxh-tdname MODIF ID min.
SELECTION-SCREEN END OF SCREEN 110.

* Country settings
SELECTION-SCREEN BEGIN OF SCREEN 120 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(70) text-s11 MODIF ID exp.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(70) text-s12 MODIF ID exp.
SELECTION-SCREEN END OF LINE.
PARAMETERS:
  pa_send TYPE adrc-country DEFAULT 'US' VALUE CHECK.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK country WITH FRAME TITLE text-se5.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(70) text-se9 MODIF ID la1.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(70) text-s10 MODIF ID la1.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:
  pa_cnfix  AS CHECKBOX DEFAULT 'X' USER-COMMAND lang_country
  MODIF ID la1.
"country and language fix or dynamic
SELECTION-SCREEN COMMENT 3(70) text-se6 MODIF ID la1.
SELECTION-SCREEN END OF LINE.
PARAMETERS:
  pa_lang   TYPE sfpdocparams-langu
            MODIF ID lan,
  pa_cntry  TYPE t005t-land1
            MODIF ID lan MEMORY ID lnd
    MATCHCODE OBJECT country_for_param_spr.
SELECTION-SCREEN END OF BLOCK country.
SELECTION-SCREEN END OF SCREEN 120.


* Processing settings
SELECTION-SCREEN BEGIN OF SCREEN 130 AS SUBSCREEN.
SELECTION-SCREEN BEGIN OF BLOCK download_details.
PARAMETERS:
  pa_spool RADIOBUTTON GROUP proc MODIF ID pro
    USER-COMMAND proc_type DEFAULT 'X' ,
  pa_gui   RADIOBUTTON GROUP proc MODIF ID pro,
  pa_path(128) MEMORY ID gr8 MODIF ID pat.


PARAMETERS:
  pa_mail   RADIOBUTTON GROUP proc MODIF ID pro,
  pa_addr   TYPE adr6-smtp_addr OBLIGATORY MODIF ID mai
    DEFAULT sy-uname,
  pa_fax   RADIOBUTTON GROUP proc MODIF ID pro,
  pa_faxct TYPE ad_comctry MODIF ID fax,
  pa_faxno TYPE ad_fxnmbr MODIF ID fax.

SELECTION-SCREEN END OF BLOCK download_details.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK print_settings.
PARAMETERS:
  pa_prnt TYPE usr01-spld MEMORY ID spool_dev OBLIGATORY MODIF ID prn,
  pa_nodlg  AS CHECKBOX DEFAULT 'X' MEMORY ID no_dialog     "#EC EXISTS
    MODIF ID prn.
SELECTION-SCREEN BEGIN OF BLOCK preview.
PARAMETERS:
  pa_prev   AS CHECKBOX DEFAULT 'X' USER-COMMAND prev MODIF ID prn,
  pa_nopdf AS CHECKBOX USER-COMMAND prev MODIF ID prn.
SELECTION-SCREEN END OF BLOCK preview.
PARAMETERS:
  pa_newid AS CHECKBOX DEFAULT 'X' MEMORY ID new_spool_id   "#EC EXISTS
    MODIF ID prn.
SELECTION-SCREEN END OF BLOCK print_settings.
SELECTION-SCREEN END OF SCREEN 130.

* Sundries
SELECTION-SCREEN BEGIN OF SCREEN 140 AS SUBSCREEN.
PARAMETERS:
  pa_rfc   TYPE rfcdes-rfcdest OBLIGATORY
    MEMORY ID rfc MATCHCODE OBJECT httpdestination
    MODIF ID ads."h_rfcdest

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_fill  AS CHECKBOX DEFAULT space
    MEMORY ID fillable.                                     "#EC EXISTS
SELECTION-SCREEN END OF SCREEN 140.


SELECTION-SCREEN BEGIN OF TABBED BLOCK tabs FOR 15 LINES.
SELECTION-SCREEN TAB (30) data_src USER-COMMAND tab_data_source
                 DEFAULT  SCREEN 110.
SELECTION-SCREEN TAB (30) langcntr USER-COMMAND tab_lang_country
                 DEFAULT  SCREEN 120.
SELECTION-SCREEN TAB (30) process USER-COMMAND tab_process
                 DEFAULT  SCREEN 130.
SELECTION-SCREEN TAB (30) sundries USER-COMMAND tab_sundries
                 DEFAULT  SCREEN 140.
SELECTION-SCREEN END OF BLOCK tabs.

SELECTION-SCREEN SKIP.
