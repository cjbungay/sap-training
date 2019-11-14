FUNCTION bc_taw12_css_vb.
*"----------------------------------------------------------------------
*"*"Verbuchungsfunktionsbaustein:
*"
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IT_INSERTS) TYPE  TSBOOK_ADDS OPTIONAL
*"     VALUE(IT_DELETES) TYPE  TSBOOK_ADDS OPTIONAL
*"----------------------------------------------------------------------

  IF NOT it_inserts IS INITIAL.
    INSERT  sbook_adds FROM TABLE it_inserts.
    IF sy-subrc NE 0.
      MESSAGE a184(bc410) WITH 'major trouble during INSERT'.
    ENDIF.
  ENDIF.

  IF NOT it_deletes IS INITIAL.
    DELETE  sbook_adds FROM TABLE it_deletes.
    IF sy-subrc NE 0.
      MESSAGE a184(bc410) WITH 'major trouble during DELETE'.
    ENDIF.
  ENDIF.

ENDFUNCTION.
