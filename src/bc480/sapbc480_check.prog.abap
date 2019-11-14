*&---------------------------------------------------------------------*
*& Report  SAPBC480_CHECK
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

  INCLUDE bc480_checktop.

  INCLUDE bc480_checko01.

  INCLUDE bc480_checki01.

  INCLUDE bc480_checkf01.


  AT SELECTION-SCREEN OUTPUT.
    LOOP AT SCREEN.

* Context check and Smart Forms style not enabled yet
      IF screen-name = 'RAD_CON' OR screen-name = 'RAD_STYL'
        OR screen-name = 'RAD_IF'.
        screen-active = 0.
      ENDIF.

      CASE 'X'.
        WHEN rad_if.
          IF screen-group1 = 'CON' OR screen-group1 = 'STY'.
            screen-active = 0.
          ENDIF.
        WHEN rad_con.
          IF screen-group1 = 'IF' OR screen-group1 = 'STY'.
            screen-active = 0.
          ENDIF.
        WHEN rad_styl.
          IF screen-group1 = 'CON' OR screen-group1 = 'IF'.
            screen-active = 0.
          ENDIF.
      ENDCASE.
      IF screen-name = 'PA_IFORI'.
        screen-input = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.

  AT SELECTION-SCREEN ON BLOCK choice.
    CHECK sy-ucomm <> 'RAD'.
    CASE 'X'.
      WHEN rad_if.
        IF pa_if IS INITIAL.
          MESSAGE e001. "Enter interface
        ENDIF.
        SELECT SINGLE masterlang
         FROM tadir
         INTO master_lang
         WHERE pgmid = 'R3TR' AND
               object = 'SFPI' AND
               obj_name = pa_if.
        IF sy-subrc <> 0.
          MESSAGE e002 WITH pa_if.
          " No active interface &1 available
        ENDIF.

        SELECT SINGLE name
         FROM fpinterface
         INTO pa_if
         WHERE name = pa_if AND
               state = 'A'.
        IF sy-subrc <> 0.
          MESSAGE e002 WITH pa_if.
          " No active interface &1 available
        ENDIF.

        SELECT SINGLE name
         FROM fpinterface
         INTO pa_if
         WHERE name = pa_if AND
               state = 'I'.
        IF sy-dbcnt = 1.
          MESSAGE w039 WITH pa_if.
* Interface &1 has two versions. Only the active version will be checked
        ENDIF.

      WHEN rad_con.
        IF pa_con IS INITIAL.
          MESSAGE e003.
          "Enter form
        ENDIF.
        SELECT SINGLE masterlang
         FROM tadir
         INTO master_lang
         WHERE pgmid = 'R3TR' AND
               object = 'SFPF' AND
               obj_name = pa_con.
        IF sy-subrc <> 0.
          MESSAGE e004 WITH pa_con.
          " No active form &1 available
        ENDIF.

    ENDCASE.

  START-OF-SELECTION.
    CASE 'X'.
      WHEN rad_if.
* find out information on correct interface (template)
        SELECT SINGLE interface
         FROM fpinterface
         INTO xml
         WHERE name = pa_ifori AND
               state = 'A'.
        PERFORM parse_interface
          CHANGING gt_import_correct
             gt_export_correct
             gt_table_correct
             gt_global_correct
             gt_reference_correct.

* find out information on student's interface
        SELECT SINGLE interface
         FROM fpinterface
         INTO xml
         WHERE name = pa_if AND
               state = 'A'.
        PERFORM parse_interface
          CHANGING gt_import_parameters
             gt_export_parameters
             gt_table_parameters
             gt_global_data
             gt_reference_fields.

        CALL SCREEN 100.

      WHEN rad_con.
        SELECT SINGLE context
        FROM fpcontext
        INTO xml
        WHERE name = pa_con AND
               state = 'A'.
        PERFORM parse_context.

      WHEN rad_styl.
        PERFORM parse_style
          USING pa_styl
        CHANGING gt_paragraphs_correct.
        PERFORM parse_style
          USING 'BC480'
        CHANGING gt_paragraphs.
    ENDCASE.
