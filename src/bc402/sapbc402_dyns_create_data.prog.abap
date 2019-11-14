*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYNS_CREATE_DATA
*&
*&---------------------------------------------------------------------*
*&  This program works similar to the Data Browser.
*&  Features:
*&      Selection-Screen for a table name
*&      Selects Data from the table provided
*&      Output as classical list
*&---------------------------------------------------------------------*

REPORT  sapbc402_dyns_create_data.

*----------------------------------------------------------------------*
DATA:
    ok_code   LIKE sy-ucomm,

    gr_struc  TYPE REF TO data.

*----------------------------------------------------------------------*
FIELD-SYMBOLS:
    <fs_struc> TYPE ANY,
    <fs_comp>  TYPE ANY.

*----------------------------------------------------------------------*
PARAMETERS:
    pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.

*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*

  CREATE DATA gr_struc TYPE (pa_tab).
  ASSIGN gr_struc->* TO <fs_struc>.

  SELECT * FROM (pa_tab)
           INTO <fs_struc>
           UP TO 100 ROWS
           .
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_struc> TO <fs_comp>.
      IF sy-subrc <> 0.
        NEW-LINE.
        EXIT.
      ENDIF.
      WRITE: <fs_comp>.
    ENDDO.

  ENDSELECT.

  IF sy-subrc <> 0.
    MESSAGE e041(bc402).
  ENDIF.
*
