* This report generates function modules of BC470 forms.
* It helps to speed up demos in classes

***************************************************************
* IT TAKES A FEW MINUTES TO RUN THIS PROGRAM
* if you choose to generate the function modules
* for all BC470 forms.
***************************************************************


REPORT  sapbc470_generate_forms.
TABLES: stxfadm.
DATA:
  wa_form         TYPE tdsfname,
  it_form         TYPE TABLE OF tdsfname,
  mark.


SELECT-OPTIONS:
  so_form FOR stxfadm-formname.

INITIALIZATION.
  MOVE:
    'I' TO so_form-sign,
    'CP' TO so_form-option,
    'BC470*' TO so_form-low.
  APPEND so_form.

START-OF-SELECTION.
  SELECT formname
    FROM stxfadm
    INTO TABLE it_form
    WHERE formname IN so_form AND
          formtype = space. " forms only

  LOOP AT it_form
    INTO wa_form.
    WRITE: / mark AS CHECKBOX, wa_form.
    HIDE: wa_form.
  ENDLOOP.

  SET PF-STATUS 'GENERATE'.


AT USER-COMMAND.
  CASE sy-ucomm.
    WHEN 'SELECT_ALL'.
      PERFORM set_mark USING 'X'.

    WHEN 'DESELECT_ALL'.
      PERFORM set_mark USING space.


    WHEN 'GENERATE'.
      CHECK sy-lsind = 1.
      DO.
        CLEAR mark.
        READ LINE sy-index FIELD VALUE mark.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        CHECK NOT mark IS INITIAL.
        MODIFY CURRENT LINE
          FIELD FORMAT mark INPUT OFF wa_form COLOR col_positive
          FIELD VALUE mark FROM space.
        CALL FUNCTION 'FB_GENERATE_FORM'
          EXPORTING
            i_formname       = wa_form
          EXCEPTIONS
            no_name          = 1
            no_form          = 2
            no_active_source = 3
            generation_error = 4
            illegal_formtype = 5
            OTHERS           = 6.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ELSE.
          SET TITLEBAR 'GENERATED'.
          WRITE: / wa_form.
        ENDIF.
      ENDDO.
      SET PF-STATUS space.
  ENDCASE.

*---------------------------------------------------------------------*
FORM set_mark USING value(p_value) TYPE flag.
  DO.
    READ LINE sy-index FIELD VALUE p_value.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
    MODIFY CURRENT LINE FIELD VALUE mark FROM p_value.
  ENDDO.
ENDFORM.                    "set_mark
