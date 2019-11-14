*&---------------------------------------------------------------------*
*& Report  SAPBC480_XML_DISPLAY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  sapbc480_xml_display MESSAGE-ID bc480.

TYPES ctype(1)      TYPE c.

DATA:
  xml               TYPE xstring,
  xhelp(4)          TYPE x,
  len               TYPE i,
  space_count       TYPE i,
  separator         TYPE c VALUE '\',
  file_exists,
  only_master_lang,
  master_lang       TYPE tadir-masterlang,
  filename          TYPE string,
  download_path     TYPE string,
  gv_window_text    TYPE string.

FIELD-SYMBOLS:
  <fs> TYPE ANY.

SELECTION-SCREEN BEGIN OF BLOCK choice.
PARAMETERS:
  rad_if  RADIOBUTTON GROUP typ  USER-COMMAND rad DEFAULT 'X',
  rad_con RADIOBUTTON GROUP typ,
  rad_lay RADIOBUTTON GROUP typ.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_if  TYPE fpinterface-name
    MATCHCODE OBJECT hfpwbinterface
    MODIF ID if
    MEMORY ID fpwbinterface,
  pa_con TYPE fpcontext-name
    MATCHCODE OBJECT hfpwbform
    MODIF ID con
    MEMORY ID fpwbform,
  pa_lang TYPE fplayoutt-language DEFAULT sy-langu MODIF ID lay,
  pa_lay TYPE fplayout-name
    MATCHCODE OBJECT hfpwbform
    MODIF ID lay MEMORY ID fpwbform.
SELECTION-SCREEN END OF BLOCK choice.

SELECTION-SCREEN SKIP.

PARAMETERS:
  pa_list RADIOBUTTON GROUP gui USER-COMMAND gui DEFAULT 'X',
  pa_gui  RADIOBUTTON GROUP gui,
  pa_path(128) MEMORY ID gr8 MODIF ID pat.

INITIALIZATION.
  GET PARAMETER ID 'GR8' FIELD pa_path.
  IF pa_path IS INITIAL. " first call
    pa_path = 'C:\'.
  ENDIF.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE 'X'.
      WHEN rad_if.
        IF screen-group1 = 'CON' OR screen-group1 = 'LAY'.
          screen-active = 0.
        ENDIF.
      WHEN rad_con.
        IF screen-group1 = 'IF' OR screen-group1 = 'LAY'.
          screen-active = 0.
        ENDIF.
      WHEN rad_lay.
        IF screen-group1 = 'IF' OR screen-group1 = 'CON'.
          screen-active = 0.
        ENDIF.
    ENDCASE.
    IF pa_gui IS INITIAL AND screen-group1 = 'PAT'.
      screen-active = 0.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_path.
  gv_window_text = 'Select download directory'(dow).
  CALL METHOD cl_gui_frontend_services=>directory_browse
    EXPORTING
      window_title         = gv_window_text
    CHANGING
      selected_folder      = download_path
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  pa_path = download_path.


AT SELECTION-SCREEN ON pa_path.
  download_path = pa_path.
  CALL METHOD cl_gui_frontend_services=>directory_exist
    EXPORTING
      directory = download_path
    RECEIVING
      result    = file_exists
    EXCEPTIONS
      OTHERS    = 5.

  IF file_exists IS INITIAL.
    MESSAGE e012.
*   Invalid download path
  ENDIF.

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

    WHEN rad_lay.
      IF pa_lay IS INITIAL OR pa_lang IS INITIAL.
        MESSAGE e005.
        " Enter form and language
      ENDIF.

      SELECT SINGLE masterlang
       FROM tadir
       INTO master_lang
       WHERE pgmid = 'R3TR' AND
             object = 'SFPF' AND
             obj_name = pa_lay.
      IF sy-subrc <> 0.
        MESSAGE e004 WITH pa_lay.
        " No active form of this name available
      ENDIF.

  ENDCASE.

START-OF-SELECTION.
  IF download_path CS '/'.
    separator = '/'.
  ELSE.
    separator = '\'.
  ENDIF.

  len = STRLEN( download_path ) - 1.

  IF download_path+len(1) <> separator.
    CONCATENATE download_path separator INTO download_path.
    pa_path = download_path.
  ENDIF.

  CASE 'X'.
    WHEN rad_if.
      SELECT SINGLE interface
       FROM fpinterface
       INTO xml
       WHERE name = pa_if AND
             state = 'A'.
      CONCATENATE download_path pa_if 'xml.hex' INTO filename.

    WHEN rad_con.
      SELECT SINGLE context
      FROM fpcontext
      INTO xml
      WHERE name = pa_con AND
             state = 'A'.
      CONCATENATE download_path pa_con '_Context' 'xml.hex'
        INTO filename.

    WHEN rad_lay.
      SELECT SINGLE layout
      FROM fplayoutt
      INTO xml
      WHERE name = pa_lay AND
             state = 'A' AND
             language = pa_lang.
      CONCATENATE download_path pa_lay '_Layout_' pa_lang 'xml.hex'
        INTO filename.

      IF sy-dbcnt = 0.
        SELECT SINGLE layout
        FROM fplayoutt
        INTO xml
        WHERE name = pa_lay AND
              state = 'A' AND
              language = master_lang.
        only_master_lang = 'X'.
        CONCATENATE download_path pa_lay '_Layout_' master_lang
          'xml.hex' INTO filename.
      ENDIF.
  ENDCASE.

  CHECK sy-dbcnt = 1.

  CASE 'X'.
    WHEN pa_gui.
      PERFORM download_hex
        USING xml.
      PERFORM parse_interface.

    WHEN pa_list.

      IF only_master_lang = 'X'.
        FORMAT COLOR COL_NEGATIVE.
        WRITE:
          AT /(40) 'Form is not available in language'(nol), pa_lang.
        FORMAT COLOR COL_HEADING.
        WRITE:
       AT /(40) 'Display language = master language:'(dim), master_lang.
      ELSE.
        FORMAT COLOR COL_HEADING.
        WRITE:
          AT /(20) 'Display language:'(dis), pa_lang,
          AT /(20) 'Master language:'(mas), master_lang.
      ENDIF.

      FORMAT RESET.
      SKIP.


      len = XSTRLEN( xml ).
      DO len TIMES.
        xhelp = xml.

        ASSIGN xhelp TO <fs> CASTING TYPE ctype.
        CASE 'X'.
          WHEN rad_lay.

            CASE xhelp(1).
              WHEN '0A'.
                NEW-LINE. "layout has line breaks included
              WHEN OTHERS.
                WRITE <fs> NO-GAP.
            ENDCASE.
          WHEN OTHERS. " interfac or context
            CASE xhelp(1).
              WHEN '3E'. " >
                WRITE '>' NO-GAP.
                NEW-LINE.
                IF xhelp+1(1) <> '3C'. " content detected
                  space_count = space_count + 2.
                  WRITE AT space_count space.
                  POSITION space_count.
                  space_count = space_count - 2.
                  FORMAT COLOR COL_POSITIVE.
                ENDIF.
                "context and interface have no line breaks included
              WHEN '3C'. " <
                FORMAT COLOR COL_BACKGROUND INTENSIFIED ON.
                IF xhelp(2) = '3C2F'. " </
                  WRITE AT /space_count '<' NO-GAP.
                  space_count = space_count - 2.
                ELSE.
                  space_count = space_count + 2.
                  WRITE AT /space_count '<' NO-GAP.
                ENDIF.
              WHEN '2F'.
                IF xhelp(2) = '2F3E'. " /> (empty tag)
                  space_count = space_count - 2.
                ENDIF.
                WRITE '/' NO-GAP.
              WHEN OTHERS."regular sign
                WRITE <fs> NO-GAP.
            ENDCASE.
        ENDCASE.

        SHIFT xml BY 1 PLACES LEFT IN BYTE MODE.
      ENDDO.
  ENDCASE.


*&--------------------------------------------------------------------*
FORM download_hex
  USING value(p_pdf_hex) TYPE xstring.
  TYPES:
    hex_line(10000) TYPE x.
  DATA:
    len       TYPE i,
    itab      TYPE TABLE OF hex_line,
    remains   TYPE i.

  remains = len = XSTRLEN( p_pdf_hex ).
  DO.
    IF remains > 10000.
      APPEND p_pdf_hex(10000) TO itab.
    ELSE.
      APPEND p_pdf_hex(remains) TO itab.
    ENDIF.
    SHIFT p_pdf_hex BY 10000 PLACES LEFT IN BYTE MODE.
    remains = remains - 10000.
    IF remains < 0. EXIT. ENDIF.
  ENDDO.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      bin_filesize = len
      filename     = filename
      filetype     = 'BIN'
    TABLES
      data_tab     = itab
    EXCEPTIONS
      OTHERS       = 22.
  IF sy-subrc <> 0.
    MESSAGE e006.
    " Download failure
  ENDIF.
ENDFORM.                    "download_hex

************************************************************************
FORM parse_interface.
  DATA:
    lr_xml_interface      TYPE REF TO cl_fp_interface_data,

    lr_global_definitions TYPE REF TO if_fp_global_definitions,
    lt_global_data        TYPE tfpgdata,

    lr_reference_fields   TYPE REF TO if_fp_reference_fields,
    lt_reference_fields   TYPE tfpref,

    lr_parameters         TYPE REF TO if_fp_parameters,
    lt_export_parameters  TYPE tfpiopar,
    lt_import_parameters  TYPE tfpiopar,
    lt_table_parameters   TYPE tfpiopar.

  TRY.
      CALL TRANSFORMATION id
        SOURCE XML xml
        RESULT interface = lr_xml_interface.
    CATCH cx_xslt_exception.
    message e040.
  ENDTRY.

  lr_global_definitions =
  lr_xml_interface->if_fp_interface_data~get_global_definitions( ).
  lt_global_data = lr_global_definitions->get_global_data( ).

  lr_reference_fields =
  lr_xml_interface->if_fp_interface_data~get_reference_fields( ).
  lt_reference_fields = lr_reference_fields->get_reference_fields( ).

  lr_parameters =
  lr_xml_interface->if_fp_interface_data~get_parameters( ).
  lt_export_parameters = lr_parameters->get_export_parameters( ).
  lt_import_parameters = lr_parameters->get_import_parameters( ).
  lt_table_parameters  = lr_parameters->get_table_parameters( ).


ENDFORM.                    "parse_interface
