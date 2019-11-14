*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYNS_CREATE_SE16
*&
*&---------------------------------------------------------------------*
*&  This program works similar to the Data Browser.
*&  Selection-Screen for a table name.
*&  Use RTTI to get the field names
*&  Build Up an internal table with program code
*&  Insert this report and submit it
*&  Export data to / Import data From Memory.
*&  Dynamic SQL Statement to read the data from the table
*&  Use ALV to display the data
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_dyns_create_se16.

*----------------------------------------------------------------------*
TYPE-POOLS:
    abap.
*----------------------------------------------------------------------*
DATA:
    ok_code LIKE sy-ucomm,

    gr_alv   TYPE REF TO cl_salv_table,
    ref_itab TYPE REF TO data.

*----------------------------------------------------------------------*
FIELD-SYMBOLS:
    <fs_itab> TYPE ANY TABLE.

*----------------------------------------------------------------------*
PARAMETERS pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.

*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*
** RTTI: Beschaffen der Metainformation fuer eingegebene Tabelle.
  DATA:
      gr_struc TYPE REF TO cl_abap_structdescr,
      wa_comp  TYPE  abap_compdescr.

  gr_struc ?= cl_abap_typedescr=>describe_by_name( pa_tab ).

*** Test output
*  LOOP AT gr_struc->components INTO wa_comp.
*    WRITE: / wa_comp-name.
*  ENDLOOP.

*----------------------------------------------------------------------*
** Generate Report:

  DATA:
      gt_report TYPE STANDARD TABLE OF char72,
      wa_report LIKE LINE OF gt_report,
      gv_index  TYPE n LENGTH 2.

*----------------------------------------------------------------------*
** Report Header:

  APPEND 'REPORT.'                    TO gt_report.
  CONCATENATE 'TABLES' pa_tab '.' INTO wa_report SEPARATED BY space.
  APPEND wa_report TO gt_report.
  CLEAR wa_report.

*----------------------------------------------------------------------*
** Selection Screen

  LOOP AT gr_struc->components INTO wa_comp.
    CHECK wa_comp-name <> 'MANDT'.
    CLEAR wa_report.
    CONCATENATE 'SELECT-OPTIONS '
                wa_comp-name(8) INTO wa_report SEPARATED BY space.
    CONCATENATE wa_report
                'for'
                pa_tab         INTO wa_report SEPARATED BY space.
    CONCATENATE wa_report
                '-'
                wa_comp-name
                '.'            INTO wa_report.
    APPEND wa_report TO gt_report.
  ENDLOOP.
*----------------------------------------------------------------------*
** Start-of-selection
  APPEND 'START-OF-SELECTION.'        TO gt_report.
*----------------------------------------------------------------------*
** Export to Memory
  DATA helper TYPE c LENGTH 20.
  APPEND 'EXPORT' TO gt_report.
  LOOP AT gr_struc->components INTO wa_comp FROM 2 TO 5.
    CONCATENATE wa_comp-name(8)
                '='
                wa_comp-name(8)
           INTO wa_report SEPARATED BY space.
    APPEND wa_report TO gt_report.
  ENDLOOP.
  APPEND 'TO MEMORY ID ''HUGO''.' TO gt_report.
*----------------------------------------------------------------------*
  APPEND 'LEAVE PROGRAM.'        TO gt_report.


  INSERT REPORT 'Z00SE16' FROM gt_report
*      PROGRAM TYPE '1'
      STATE        'A'.

  IF sy-subrc <> 0.
  ENDIF.
  GENERATE REPORT 'Z00SE16'.
  SUBMIT z00se16 VIA SELECTION-SCREEN AND RETURN.

  IF sy-subrc <> 0.
  ENDIF.

*----------------------------------------------------------------------*
** Daten aus Memory importieren:

  DATA:
      carrid TYPE RANGE OF spfli-carrid.

  IMPORT carrid = carrid FROM MEMORY ID 'HUGO'.

  IF sy-subrc <> 0.
  ENDIF.

*----------------------------------------------------------------------*
** Where Bedingung zusammenbauen (das ist hier nur ein Ausschnitt)
  DATA: gv_where_clause TYPE string.

  LOOP AT gr_struc->components INTO wa_comp TO 2.
    CHECK wa_comp-name <> 'MANDT'.
    CONCATENATE wa_comp-name
                'IN'
                'CARRID'
           INTO gv_where_clause SEPARATED BY space.
  ENDLOOP.



*----------------------------------------------------------------------*
  CREATE DATA ref_itab TYPE STANDARD TABLE OF (pa_tab)
                       WITH NON-UNIQUE DEFAULT KEY.
  ASSIGN ref_itab->* TO <fs_itab>.


  SELECT * FROM (pa_tab)
           INTO TABLE <fs_itab>
           WHERE (gv_where_clause)
*           UP TO 100 ROWS
           .

  IF sy-subrc <> 0.
    MESSAGE e041(bc402).
  ENDIF.
*
*
**----------------------------------------------------------------------
**
  TRY.
    cl_salv_table=>factory(
*  EXPORTING
*    LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE
*    R_CONTAINER    = R_CONTAINER
*    CONTAINER_NAME = CONTAINER_NAME
      IMPORTING
        r_salv_table   = gr_alv
      CHANGING
        t_table        = <fs_itab>
           ).
* CATCH CX_SALV_MSG .
  ENDTRY.

  gr_alv->display( ).
**----------------------------------------------------------------------
**
