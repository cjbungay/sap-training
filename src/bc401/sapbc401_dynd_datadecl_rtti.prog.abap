*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYND_DATADECL_RTTI                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  selects all data from a given database table                       *
*&---------------------------------------------------------------------*
*
* data object ref_itab is created dynamically based on the line type of
* the given database table
*
* we have to assign it to the field-symbol <fs_wa> in order to select
* the data directly into this data object
*
* all components are assigned to the field-symbol '<fs_comp>' in a loop
* in order to display them
*
* to list the names of components of this flat structure we have to use
* the RTTI-concept: get the automatically created type description
* object and access its attributes to get information
*&---------------------------------------------------------------------*


REPORT sapbc401_dynd_datadecl_rtti.

DATA:
  ref_itab TYPE REF TO data,
  ref_wa   TYPE REF TO data,

  ref_descr TYPE REF TO cl_abap_structdescr,
  wa_comp   TYPE abap_compdescr,
  pos       TYPE i,
  len       TYPE i.

FIELD-SYMBOLS:
  <fs_itab> TYPE ANY TABLE,
  <fs_wa>   TYPE ANY,
  <fs_comp> TYPE ANY.

PARAMETERS pa_tab TYPE dd02l-tabname DEFAULT 'SPFLI'.




START-OF-SELECTION.

  CREATE DATA ref_itab TYPE STANDARD TABLE OF (pa_tab)
                       WITH NON-UNIQUE DEFAULT KEY.
  ASSIGN ref_itab->* TO <fs_itab>.

* dynamical data selection and output:
  SELECT * FROM (pa_tab)
           INTO TABLE <fs_itab>
           UP TO 100 ROWS.

  CREATE DATA ref_wa LIKE LINE OF <fs_itab>. "or: TYPE (pa_tab).
  ASSIGN ref_wa->* TO <fs_wa>.

* get reference to type descripion object by widening cast:
  ref_descr ?= cl_abap_typedescr=>describe_by_data( <fs_wa> ).

* list headings:
  sy-tvar1 = ref_descr->absolute_name+6.


  LOOP AT <fs_itab> INTO <fs_wa>.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa> TO <fs_comp>.
      IF sy-subrc NE 0.
        NEW-LINE.
        EXIT.
      ENDIF.
      WRITE <fs_comp>.
    ENDDO.
  ENDLOOP.




TOP-OF-PAGE.
* create the header line dynamically:
  LOOP AT ref_descr->components INTO wa_comp.
    CASE wa_comp-type_kind.
      WHEN 'P'.
        len = 2 * wa_comp-length + 1 + wa_comp-decimals.
      WHEN 'F'.
        len = 22.
      WHEN 'I' OR 'D'.
        len = 10.
      WHEN 'T'.
        len = 6.
      WHEN OTHERS.
        len = wa_comp-length.
    ENDCASE.
    WRITE AT pos(len) wa_comp-name COLOR COL_HEADING.
    pos = pos + len + 1.
  ENDLOOP.
  ULINE.
