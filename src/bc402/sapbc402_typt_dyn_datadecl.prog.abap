*&---------------------------------------------------------------------*
*& Report  SAPBC402_TYPT_DYN_DATADECL                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  copy template for slide "dynamic data object declaration"          *
*&---------------------------------------------------------------------*



REPORT sapbc402_typt_dyn_datadecl.

PARAMETERS pa_dbtab TYPE dd02l-tabname DEFAULT 'SFLIGHT'.

* reference, field symbols, data object und assigning here:
...




START-OF-SELECTION.


* fill out here:
*  SELECT * FROM (pa_dbtab) INTO ... .
*    DO.
*      ASSIGN COMPONENT sy-index OF STRUCTURE ... TO ... .
*      IF sy-subrc NE 0.
*        SKIP.
*        EXIT.
*      ENDIF.
*      WRITE ... .
*    ENDDO.
*  ENDSELECT.
