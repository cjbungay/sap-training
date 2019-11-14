FUNCTION bc_taw12_css_exec_fcode.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(IM_FCODE) TYPE  C
*"     VALUE(IM_BOOKID) TYPE  S_BOOK_ID OPTIONAL
*"----------------------------------------------------------------------

  DATA:
   lt_sbook_adds_ins TYPE tsbook_adds,
   ls_sbook_adds     TYPE sbook_adds.

  CASE im_fcode.
    WHEN 'DEL_ALL'.
      CLEAR gt_adds.


    WHEN 'SAVE'.
*     get current flight:
      CALL METHOD gr_badi_reference->get_key_data
        IMPORTING
          e_carrid = gf_carrid
          e_connid = gf_connid
          e_fldate = gf_fldate.

*     prepare data for posting:
      ls_sbook_adds-carrid = gf_carrid.
      ls_sbook_adds-connid = gf_connid.
      ls_sbook_adds-fldate = gf_fldate.
      ls_sbook_adds-bookid = im_bookid.

      LOOP AT gt_adds INTO gs_add.
        CHECK NOT gs_add-special IS INITIAL.

        ls_sbook_adds-special = gs_add-special.

        PERFORM specialid_get_new CHANGING ls_sbook_adds-specialid.

        APPEND ls_sbook_adds TO lt_sbook_adds_ins.
      ENDLOOP.

*     call posting
      CALL FUNCTION 'BC_TAW12_CSS_VB' IN UPDATE TASK
        EXPORTING
          it_inserts = lt_sbook_adds_ins.
      CLEAR gt_adds.

  ENDCASE.


ENDFUNCTION.
