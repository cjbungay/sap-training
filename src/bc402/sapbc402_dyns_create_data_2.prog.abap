*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYNS_CREATE_DATA_2
*&
*&---------------------------------------------------------------------*
*&  This program works similar to the Data Browser.
*&  Selection-Screen for a table name.
*&  Dynamic SQL Statement to read the data from the table
*&  Use ALV to display the data
*&
*&---------------------------------------------------------------------*

REPORT  sapbc402_dyns_create_data_2.

*----------------------------------------------------------------------*
DATA:
    ok_code LIKE sy-ucomm,

    gr_alv   TYPE REF TO cl_salv_table,
    gr_itab TYPE REF TO data.

*----------------------------------------------------------------------*
FIELD-SYMBOLS:
    <fs_itab> TYPE ANY TABLE.

*----------------------------------------------------------------------*
PARAMETERS pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*

  CREATE DATA gr_itab  TYPE STANDARD TABLE OF (pa_tab)
                       WITH NON-UNIQUE DEFAULT KEY.
  ASSIGN gr_itab->* TO <fs_itab>.


  SELECT * FROM (pa_tab)
           INTO TABLE <fs_itab>
           UP TO 100 ROWS
           .
  IF sy-subrc <> 0.
    MESSAGE e041(bc402).
  ENDIF.
*
*----------------------------------------------------------------------*
** Classical Write Statement:
*  PERFORM write_list.
*
*----------------------------------------------------------------------*
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

*&---------------------------------------------------------------------*
*&      Form  write_list
*&---------------------------------------------------------------------*
*  Classical Write Statements...
*----------------------------------------------------------------------*
FORM write_list.

  FIELD-SYMBOLS:
      <fs_line> TYPE ANY,
      <fs_comp> TYPE ANY.

  LOOP AT <fs_itab> ASSIGNING <fs_line>.

    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_line> TO <fs_comp>.
      IF sy-subrc <> 0.
        NEW-LINE.
        EXIT.
      ENDIF.
      WRITE <fs_comp>.
    ENDDO.
  ENDLOOP.

ENDFORM.                    " write_list
