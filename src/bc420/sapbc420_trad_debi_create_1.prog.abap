REPORT sapbc420_trad_debi_create_1
       NO STANDARD PAGE HEADING LINE-SIZE 25.

INCLUDE bdcrecx1.

START-OF-SELECTION.

*perform open_group.
  DO 2 TIMES.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '0105'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RF02D-KTOKD'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'RF02D-BUKRS'
                                  '0001'.
    PERFORM bdc_field       USING 'RF02D-KTOKD'
                                  'DEBI'.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '0110'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KNA1-SORTL'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'KNA1-NAME1'
                                  'Muster'.
    PERFORM bdc_field       USING 'KNA1-SORTL'
                                  'MU'.
    PERFORM bdc_field       USING 'KNA1-ORT01'
                                  'HD'.
    PERFORM bdc_field       USING 'KNA1-PSTLZ'
                                  '12345'.
    PERFORM bdc_field       USING 'KNA1-LAND1'
                                  'DE'.
    PERFORM bdc_field       USING 'KNA1-SPRAS'
                                  'DE'.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '0120'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KNA1-STCEG'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'KNA1-STCEG'
                                  'de123456789'.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '0130'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KNBK-BANKS(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '0210'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KNB1-AKONT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=UPDA'.
    PERFORM bdc_field       USING 'KNB1-AKONT'
                                  '120000'.
    PERFORM bdc_transaction USING 'FD01'.
  ENDDO.

*perform close_group.

  CALL FUNCTION 'ABAP4_CALL_TRANSACTION'
       EXPORTING
            tcode                   = 'FD01'
*         SKIP_SCREEN             = ' '
            mode_val                = 'A'
*         UPDATE_VAL              = 'A'
*    IMPORTING
*         SUBRC                   =
       TABLES
            using_tab               = bdcdata
*         SPAGPA_TAB              =
*         MESS_TAB                =
       EXCEPTIONS
            call_transaction_denied = 1
            tcode_invalid           = 2
            OTHERS                  = 3
            .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
