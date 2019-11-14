*&---------------------------------------------------------------------*
*& Report  SAPBC460D_UPROG_STRICHCODE                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC460D_UPROG_STRICHCODE    .

*---------------------------------------------------------------------*
*       FORM GET_STRICHCODE                                           *
*---------------------------------------------------------------------*
*       Aufruf im Formular SAPBC460D_FM_04C                           *
*---------------------------------------------------------------------*
*  -->  IN_PAR                                                        *
*  -->  OUT_PAR                                                       *
*---------------------------------------------------------------------*
FORM GET_STRICHCODE TABLES IN_PAR   STRUCTURE ITCSY
                           OUT_PAR  STRUCTURE ITCSY.
  DATA: PAGNUM  LIKE SY-PAGNO,
        NEXTPAG LIKE SY-PAGNO.

* read table in_par
  READ TABLE IN_PAR WITH KEY 'NEXTPAGE'.
  NEXTPAG = IN_PAR-VALUE.

  READ TABLE IN_PAR WITH KEY 'PAGE'.
  PAGNUM = IN_PAR-VALUE.

* read table out_par
  READ TABLE OUT_PAR WITH KEY 'STRICHCODE'.
  IF PAGNUM = 1.
    OUT_PAR-VALUE = '| '.
  ELSE.
    OUT_PAR-VALUE = '||'.
    IF NEXTPAG = 0.
      OUT_PAR-VALUE+2 = 'L'.
    ENDIF.
  ENDIF.

* write new entry into out_par
  MODIFY OUT_PAR INDEX SY-TABIX.

ENDFORM.
