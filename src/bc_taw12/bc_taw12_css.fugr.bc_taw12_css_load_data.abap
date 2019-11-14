FUNCTION bc_taw12_css_load_data.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(I_SBOOK) TYPE  SBOOK
*"     VALUE(I_MODUS) TYPE  C DEFAULT 'V'
*"  EXPORTING
*"     VALUE(NUMBER_OF_ENTRIES) TYPE  I
*"----------------------------------------------------------------------

  gf_modus = i_modus.

* read DB only when booking has changed:
  READ TABLE gt_adds INTO gs_add
     WITH KEY carrid = i_sbook-carrid
              connid = i_sbook-connid
              fldate = i_sbook-fldate
              bookid = i_sbook-bookid.
  IF sy-subrc = 0.
    DESCRIBE TABLE gt_adds.
    number_of_entries = sy-tfill.
    EXIT.
  ENDIF.

  SELECT * FROM  sbook_adds
           INTO CORRESPONDING FIELDS OF TABLE gt_adds
           WHERE  carrid  = i_sbook-carrid
           AND    connid  = i_sbook-connid
           AND    fldate  = i_sbook-fldate
           AND    bookid  = i_sbook-bookid.
  number_of_entries = sy-dbcnt.

  IF i_modus = 'C'.
    MESSAGE s555(bc410) WITH text-004.
  ENDIF.

ENDFUNCTION.
