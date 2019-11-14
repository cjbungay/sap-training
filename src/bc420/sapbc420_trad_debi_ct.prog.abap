REPORT sapbc420_trad_debi_ct NO STANDARD PAGE HEADING LINE-SIZE 255.

INCLUDE bdcrecx1.

PARAMETERS: dataset(132) LOWER CASE DEFAULT
                              'BC420-00-BIFILE'.
***    DO NOT CHANGE - the generated data section - DO NOT CHANGE    ***
*
*   If it is nessesary to change the data section use the rules:
*   1.) Each definition of a field exists of two lines
*   2.) The first line shows exactly the comment
*       '* data element: ' followed with the data element
*       which describes the field.
*       If you don't have a data element use the
*       comment without a data element name
*   3.) The second line shows the fieldname of the
*       structure, the fieldname must consist of
*       a fieldname and optional the character '_' and
*       three numbers and the field length in brackets
*   4.) Each field must be type C.
*
*** Generated data section with specific formatting - DO NOT CHANGE  ***
DATA: BEGIN OF record,
* data element: KUN16
        kunnr_001(010),
* data element: NAME1_GP
        name1_004(030),
* data element: PSTLZ
        pstlz_006(010),
* data element: ORT01_GP
        ort01_005(030),
* data element: TELF1
        telf1_007(016),
      END OF record.

*** End generated data section ***

START-OF-SELECTION.

  PERFORM open_dataset USING dataset.
  PERFORM open_group.

  DO.

    READ DATASET dataset INTO record.
    IF sy-subrc <> 0. EXIT. ENDIF.

    PERFORM bdc_dynpro      USING 'SAPMF02D' '0106'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RF02D-D0110'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'RF02D-KUNNR'
                                  record-kunnr_001.
    PERFORM bdc_field       USING 'RF02D-BUKRS'
                                  '0001'.
    PERFORM bdc_field       USING 'RF02D-D0110'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPMF02D' '0110'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KNA1-PSTLZ'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=UPDA'.
    PERFORM bdc_field       USING 'KNA1-NAME1'
                                  record-name1_004.
    PERFORM bdc_field       USING 'KNA1-ORT01'
                                  record-ort01_005.
    PERFORM bdc_field       USING 'KNA1-PSTLZ'
                                  record-pstlz_006.
    PERFORM bdc_field       USING 'KNA1-TELF1'
                                  record-telf1_007.
    PERFORM bdc_transaction USING 'FD02'.

  ENDDO.

  PERFORM close_group.
  PERFORM close_dataset USING dataset.
