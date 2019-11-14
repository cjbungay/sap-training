REPORT sapbc420_sptd_tabstrip NO STANDARD PAGE HEADING LINE-SIZE 255.
*---------------------------------------------------------------------*
* This program shows how to deal with TABSTRIP-Controls via Batch-Input
* The transaction SU3 is used to demonstrate this.
*---------------------------------------------------------------------*
* the default-printer can be entered by user on selection-screen
* the default setting is "LOCL"
* for local printing on Windows-NT environments
PARAMETERS: defprint LIKE usdefaults-spld DEFAULT 'LOCL'.

INCLUDE bdcrecxx.

START-OF-SELECTION.

  PERFORM open_group.

  PERFORM bdc_dynpro      USING 'SAPLSUU5' '0100'.
  PERFORM bdc_field       USING 'BDC_OKCODE'   '=DEFA'.
*perform bdc_field       using 'BDC_CURSOR'   'SZA5_D0700-TITLE_MEDI'.
  PERFORM bdc_dynpro      USING 'SAPLSUU5'     '0100'.
  PERFORM bdc_field       USING 'BDC_OKCODE'   '=UPD'.
  PERFORM bdc_field       USING 'BDC_CURSOR'   'USDEFAULTS-SPLD'.
  PERFORM bdc_field       USING 'USDEFAULTS-SPLD'   defprint.
  PERFORM bdc_transaction USING 'SU3'.

  PERFORM close_group.
