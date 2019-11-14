*&---------------------------------------------------------------------*
*&  Include           BC480_BASTOP
*&---------------------------------------------------------------------*


REPORT  sapbc480_bas message-id BC480.

TABLES: adrc.

DATA:
  form                TYPE fpwbformname,
  func_module_name    TYPE rs38l_fnam,
  fp_docparams        TYPE sfpdocparams,
  fp_outputparams     TYPE sfpoutputparams,
  interface_type      TYPE fpinterfacetype,

  address_type        TYPE i,
  address_number      TYPE adrc-addrnumber,
  person_number       TYPE adrp-persnumber,
  wa_numbers          TYPE char10,
  it_numbers          TYPE TABLE OF char10,
  return_code         TYPE i,
  wa_country          TYPE adrc-country,
  it_country          TYPE TABLE OF adrc-country.


* selection-screen
PARAMETERS:
  pa_form   TYPE fpwbformname MEMORY ID fpwbform MODIF ID sho
            OBLIGATORY MATCHCODE OBJECT hfpwbform.


SELECTION-SCREEN SKIP 1.


* central address administration
* determine type of address
SELECTION-SCREEN BEGIN OF BLOCK address WITH FRAME TITLE text-se1.
PARAMETERS:

  pa_orga RADIOBUTTON GROUP adrs USER-COMMAND address_type DEFAULT 'X',
  pa_pers RADIOBUTTON GROUP adrs MODIF ID xxx,
  pa_work RADIOBUTTON GROUP adrs.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS:
  pa_auto AS CHECKBOX DEFAULT 'X' USER-COMMAND auto.
SELECTION-SCREEN COMMENT 3(30) text-se3.
SELECTION-SCREEN COMMENT pos_low(20) text-se4 MODIF ID max.
PARAMETERS:
  pa_max(2) TYPE p DEFAULT 3  VISIBLE LENGTH 2 MODIF ID max.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN SKIP 1.

* determine address/person numbers
PARAMETERS:
pa_perno TYPE adrp-persnumber MODIF ID pep.

SELECT-OPTIONS:
  so_addno  FOR adrc-addrnumber MODIF ID ads OBLIGATORY.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) text-se2 MODIF ID adp.
SELECTION-SCREEN POSITION pos_low.
PARAMETERS:
  pa_addno TYPE adrc-addrnumber MODIF ID adp.
PARAMETERS:
  pa_comp TYPE adrc-name1 MODIF ID com.
SELECTION-SCREEN END OF LINE.

SELECT-OPTIONS:
  so_perno FOR person_number MODIF ID pes.

SELECTION-SCREEN END OF BLOCK address.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_cntry   TYPE adrc-country MEMORY ID spr.

SELECTION-SCREEN SKIP 1.
PARAMETERS:
  pa_rfc   TYPE rfcdes-rfcdest OBLIGATORY
    MEMORY ID rfc MATCHCODE OBJECT httpdestination."h_rfcdest
