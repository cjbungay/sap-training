*----------------------------------------------------------------------*
*       Report SAPBC480_TEMPLATE
*----------------------------------------------------------------------*
*       Printing of documents using PDF-based forms
*
*       Stub only - to be continued!
*----------------------------------------------------------------------*

INCLUDE bc480_templatetop.
INCLUDE bc480_templatee01.
INCLUDE bc480_templatef01.


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


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Get name of the generated function module
* Remember to use the class-based exception handling!


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Optional: Set output parameters
*  gs_outputparams-nodialog =
*  gs_outputparams-preview  =
*  gs_outputparams-dest     =
*

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Open print job


  LOOP AT gt_customers INTO gs_customer.
* Set form language and country (->form locale)
    gs_docparams-langu   = pa_lang.
    gs_docparams-country = pa_cntry.

    PERFORM find_bookings_for_customer.


*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Now call the generated function module


  ENDLOOP.

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
* Close spool job
