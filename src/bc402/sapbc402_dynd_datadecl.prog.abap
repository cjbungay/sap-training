*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYND_DATADECL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT  sapbc402_dynd_datadecl.

*----------------------------------------------------------------------*
DATA:
    gr_itab TYPE REF TO data,
    gr_wa   TYPE REF TO data.

*----------------------------------------------------------------------*
FIELD-SYMBOLS:
    <fs_itab> TYPE ANY TABLE,
    <fs_wa>   TYPE ANY,
    <fs_comp> TYPE ANY.

*----------------------------------------------------------------------*
PARAMETERS
    pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.


*----------------------------------------------------------------------*
START-OF-SELECTION.

  CREATE DATA gr_itab TYPE STANDARD TABLE OF (pa_tab)
                       WITH NON-UNIQUE DEFAULT KEY.

  ASSIGN gr_itab->* TO <fs_itab>.

  SELECT * FROM (pa_tab)
      INTO TABLE <fs_itab>
      UP TO 100 ROWS.

  CREATE DATA gr_wa LIKE LINE OF <fs_itab>.         "or: TYPE (pa_tab).

  ASSIGN gr_wa->* TO <fs_wa>.

  LOOP AT <fs_itab> ASSIGNING <fs_wa>.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa> TO <fs_comp>.
      IF sy-subrc NE 0.
        NEW-LINE.
        EXIT.
      ENDIF.

      WRITE <fs_comp>.
    ENDDO.
  ENDLOOP.
