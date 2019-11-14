*&---------------------------------------------------------------------*
*& Report  SAPBC480_COPY_TRANSLATION
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc480_copy_translation.

DATA:
  gv_form_name  TYPE fpwbformname,
  gt_layoutt    TYPE TABLE OF fplayoutt,"TYPE TABLE OF layout_key
  gs_layoutt    TYPE fplayoutt,"layout_key,
  gs_tadir      TYPE tadir.

* forms to be copied
SELECT-OPTIONS: so_names FOR gv_form_name MEMORY ID fpwbform.

* language selection, copy/display mode
PARAMETERS: pa_lang   TYPE spras OBLIGATORY,
            pa_over TYPE c AS CHECKBOX.


START-OF-SELECTION.
* select layout information according to the specified range
  SELECT *
    FROM fplayout
    INTO CORRESPONDING FIELDS OF TABLE gt_layoutt
    WHERE name  IN so_names
    AND   state =  if_fp_wb_object=>c_state_active.

  if sy-dbcnt = 0.
    write / 'No active forms found'(act).
  endif.
* check  each form
  LOOP AT gt_layoutt INTO gs_layoutt.
    gs_tadir-obj_name = gs_layoutt-name.
    WRITE: / gs_tadir-obj_name.

    CALL FUNCTION 'TR_TADIR_INTERFACE'
      EXPORTING
        wi_tadir_pgmid    = 'R3TR'
        wi_tadir_object   = 'SFPF'
        wi_tadir_obj_name = gs_tadir-obj_name
        wi_read_only      = 'X'
      IMPORTING
        new_tadir_entry   = gs_tadir
      EXCEPTIONS
        OTHERS            = 25.
    IF sy-subrc <> 0.
      WRITE: 'no valid object catalog entry'(cat).
    ENDIF.


    AUTHORITY-CHECK OBJECT 'S_DEVELOP'
                     ID 'DEVCLASS' FIELD gs_tadir-devclass
                     ID 'OBJTYPE'  FIELD 'SFPF'
                     ID 'OBJNAME'  FIELD gs_layoutt-name
                     ID 'P_GROUP'  DUMMY
                     ID 'ACTVT'    FIELD '02'.
    IF sy-subrc <> 0.
      WRITE: 'No authorization to change object.'(aut).
      CONTINUE.
    ENDIF.

    IF gs_tadir-author <> sy-uname.
      WRITE: 'You may change only your own objects'(own).
      CONTINUE.
    ENDIF.

    IF pa_over IS INITIAL.
      SELECT SINGLE name
        FROM fplayoutt
        INTO gv_form_name
        WHERE name     = gs_layoutt-name AND
              state    = if_fp_wb_object=>c_state_active AND
              language = pa_lang.
      IF sy-dbcnt = 1.
        WRITE:
          'exists in  target language. It must not be overwritten.'(exi)
.
        CONTINUE.
      ENDIF.
    ENDIF.

    IF gs_tadir-masterlang = pa_lang.
      WRITE: text-mas.
*     master language is not to be overwritten
      CONTINUE.
    ENDIF.

    CALL FUNCTION 'ENQUEUE_EFPFORM'
      EXPORTING
        mode_fpcontext = 'E'
        name           = gs_layoutt-name
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      WRITE: 'Form could not be locked'(enq).
      CONTINUE.
    ENDIF.


    SELECT SINGLE *
     FROM fplayoutt
     INTO gs_layoutt
     WHERE name     = gs_layoutt-name AND
           state    = if_fp_wb_object=>c_state_active AND
           language = gs_tadir-masterlang.

    gs_layoutt-language = pa_lang.
    INSERT fplayoutt FROM gs_layoutt.
    IF sy-dbcnt = 1.
      WRITE: 'New language version created'(new).
    ELSE.
      UPDATE fplayoutt FROM gs_layoutt.
      IF sy-dbcnt = 1.
        WRITE: 'Previous language version overwritten'(ove).
      ENDIF.
    ENDIF.

    CALL FUNCTION 'DEQUEUE_EFPFORM'
      EXPORTING
        mode_fpcontext = 'E'
        name           = gv_form_name.
  ENDLOOP.
