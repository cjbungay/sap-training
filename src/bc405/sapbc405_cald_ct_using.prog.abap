*&---------------------------------------------------------------------*
*& Report  SAPBC405_CALD_CT_USING
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc405_cald_ct_using.

INCLUDE bdcrecx1.

PARAMETERS: pa_kunnr(16) DEFAULT 'Z-BC405-1'.

START-OF-SELECTION.

  PERFORM open_group.

  PERFORM bdc_dynpro      USING 'SAPMF02D' '0105'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RF02D-KTOKD'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/00'.
  PERFORM bdc_field       USING 'RF02D-KUNNR'
                                pa_kunnr.
  PERFORM bdc_field       USING 'RF02D-BUKRS'
                                '0001'.
  PERFORM bdc_field       USING 'RF02D-KTOKD'
                                'KUNA'.

  PERFORM bdc_dynpro      USING 'SAPMF02D' '0110'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'KNA1-SPRAS'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=VW'.
  PERFORM bdc_field       USING 'KNA1-NAME1'
                                'Neil Young'.
  PERFORM bdc_field       USING 'KNA1-SORTL'
                                'YOUNGN'.
  PERFORM bdc_field       USING 'KNA1-STRAS'
                                '11 Hurricane Drive'.
  PERFORM bdc_field       USING 'KNA1-ORT01'
                                'Calgary'.
  PERFORM bdc_field       USING 'KNA1-PSTLZ'
                                'C2D 3F4'.
  PERFORM bdc_field       USING 'KNA1-LAND1'
                                'CA'.
  PERFORM bdc_field       USING 'KNA1-SPRAS'
                                'EN'.

  PERFORM bdc_dynpro      USING 'SAPMF02D' '0120'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'KNA1-STCEG'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=VW'.
  PERFORM bdc_field       USING 'KNA1-STCEG'
                                'DE123456789'.

  PERFORM bdc_dynpro      USING 'SAPMF02D' '0130'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'KNBK-BANKS(01)'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=VW'.

  PERFORM bdc_dynpro      USING 'SAPMF02D' '0210'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'KNB1-AKONT'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=UPDA'.
  PERFORM bdc_field       USING 'KNB1-AKONT'
                                '120000'.
  PERFORM bdc_transaction USING 'FD01'.

  PERFORM close_group.
