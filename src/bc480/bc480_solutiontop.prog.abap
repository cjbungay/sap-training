*&---------------------------------------------------------------------*
*&  Include           BC480_TEMPLATETOP
*&---------------------------------------------------------------------*
REPORT sapbc480_template MESSAGE-ID bc480.

* Dropdown list for image requires a type pool
TYPE-POOLS: vrm.

* Data declaration
CONSTANTS:
  c_internet(20) VALUE 'INTERNET',
  c_intranet(20) VALUE 'INTRANET',
  c_internet_image(255) VALUE
    'http://www.sap.com/global/images/sap_logo.gif',
  c_intranet_image(255) VALUE
    "'http://wts:1080/portal/corp/pictures/sap_logo.gif'.
    'http://wts:1080/portal/Image/sap_logo.gif'.


DATA:
  gt_customers       TYPE TABLE OF scustom,
  gs_customer        LIKE LINE OF gt_customers,
  gt_all_bookings    TYPE ty_bookings,
  gt_bookings        TYPE ty_bookings, "table of sbook
  gs_booking         LIKE LINE OF gt_bookings,
  gt_sums            TYPE flpricet,
  gs_sums            LIKE LINE OF gt_sums,
  gv_image_url       TYPE string,
  gv_fm_name         TYPE rs38l_fnam,

* parameters for calling the generated function module
  gs_docparams       TYPE sfpdocparams,
  gs_outputparams    TYPE sfpoutputparams,

  r_error            TYPE REF TO cx_root,
  error_string       TYPE string,

* for mailing
  gs_result          TYPE fpformoutput,
  pdf_content        TYPE solix_tab,

* Dropdown list for image on selection-screen must be filled
  field_for_dropdown     TYPE vrm_id,
  gt_values              TYPE vrm_values,
  gs_values              LIKE LINE OF gt_values.



**********************************************************************
* Selection screen
PARAMETERS:
  pa_form   TYPE fpwbformname MEMORY ID fpwbform MODIF ID sho
            OBLIGATORY MATCHCODE OBJECT hfpwbform.

SELECTION-SCREEN SKIP.

* Data source settings
SELECT-OPTIONS:
  so_cusid FOR gs_customer-id DEFAULT 1 MODIF ID cus.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_url LIKE gs_values-key AS LISTBOX VISIBLE LENGTH 40
    MEMORY ID graphic_from_url.                             "#EC EXISTS
SELECTION-SCREEN SKIP.

SELECTION-SCREEN SKIP.

* Country setting
SELECTION-SCREEN BEGIN OF BLOCK country.
PARAMETERS:
  pa_lang   TYPE t005-spras OBLIGATORY
            MODIF ID lan MEMORY ID language,                "#EC EXISTS
  pa_cntry TYPE t005t-land1 OBLIGATORY MEMORY ID lnd.

SELECTION-SCREEN END OF BLOCK country.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_send TYPE adrc-country DEFAULT 'US' VALUE CHECK.
