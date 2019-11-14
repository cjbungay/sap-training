REPORT sapbc420_sptd_tablecontrol NO STANDARD PAGE HEADING.
*---------------------------------------------------------------------*
* This program shows how to deal with TABLE-Controls via Batch-Input
* In the transaction FD01 bankdata is entered to demonstrate this.
*---------------------------------------------------------------------*
PARAMETERS: kunnr LIKE rf02d-kunnr DEFAULT 'Z-80-00001'.
INCLUDE bdcrecxx.

START-OF-SELECTION.

  PERFORM open_group.
************* data for the first dynpro 105 ************************
  PERFORM bdc_dynpro      USING 'SAPMF02D'     '0105'.
  PERFORM bdc_field       USING 'BDC_CURSOR'   'RF02D-KTOKD'.
  PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
  PERFORM bdc_field       USING 'RF02D-KUNNR'  kunnr.
  PERFORM bdc_field       USING 'RF02D-BUKRS'  '0001'.
  PERFORM bdc_field       USING 'RF02D-KTOKD'  'KUNA'.
  PERFORM bdc_dynpro      USING 'SAPMF02D'     '0110'.
  PERFORM bdc_field       USING 'BDC_CURSOR'   'KNA1-SPRAS'.
  PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
  PERFORM bdc_field       USING 'KNA1-ANRED'   'Herr'.
  PERFORM bdc_field       USING 'KNA1-NAME1'   'MAyer'.
  PERFORM bdc_field       USING 'KNA1-SORTL'   'Peter'.
  PERFORM bdc_field       USING 'KNA1-STRAS'   'heidel str.1'.
  PERFORM bdc_field       USING 'KNA1-ORT01'   'Walldorf'.
  PERFORM bdc_field       USING 'KNA1-PSTLZ'   '69690'.
  PERFORM bdc_field       USING 'KNA1-LAND1'   'de'.
  PERFORM bdc_field       USING 'KNA1-SPRAS'   'de'.
************* data for the second dynpro 120 ************************
  PERFORM bdc_dynpro      USING 'SAPMF02D'     '0120'.
  PERFORM bdc_field       USING 'BDC_CURSOR'   'KNA1-STCEG'.
  PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
  PERFORM bdc_field       USING 'KNA1-STCEG'   'de123456789'.
************* data for the third dynpro 130 ************************
  PERFORM bdc_dynpro      USING 'SAPMF02D'     '0130'.
  PERFORM bdc_field       USING 'BDC_CURSOR'   'KNBK-BANKN(02)'.
  PERFORM bdc_field       USING 'BDC_OKCODE'   '/00'.
  PERFORM bdc_field       USING 'KNBK-BANKS(01)'  'DE'.
  PERFORM bdc_field       USING 'KNBK-BANKS(02)'  'DE'.
  PERFORM bdc_field       USING 'KNBK-BANKL(01)'  '12345678'.
  PERFORM bdc_field       USING 'KNBK-BANKL(02)'  '12345679'.
  PERFORM bdc_field       USING 'KNBK-BANKN(01)'  '08154711'.
  PERFORM bdc_field       USING 'KNBK-BANKN(02)'  '00708157'.
************* data for the fourth dynpro 210 ************************
  PERFORM bdc_dynpro      USING 'SAPMF02D'        '0210'.
  PERFORM bdc_field       USING 'BDC_CURSOR'      'KNB1-AKONT'.
  PERFORM bdc_field       USING 'BDC_OKCODE'      '=UPDA'.
  PERFORM bdc_field       USING 'KNB1-AKONT'      '120000'.
  PERFORM bdc_transaction USING 'FD01'.

  PERFORM close_group.
