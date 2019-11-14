*&---------------------------------------------------------------------*
*& Report  SAPBC401_TYPD_DYN_DATADECL                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  selects all data from a given database table                       *
*&---------------------------------------------------------------------*
*
* data object 'd_ref' is created dynamically based on the line type of
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


REPORT sapbc401_typd_dyn_datadecl.

PARAMETERS pa_dbtab TYPE dd02l-tabname DEFAULT 'SFLIGHT'.

DATA:
  d_ref TYPE REF TO data.

FIELD-SYMBOLS:
  <fs_wa>   TYPE ANY,
  <fs_comp> TYPE ANY.


* for type description:
DATA:
  descr_ref TYPE REF TO cl_abap_structdescr,
  wa_comp   TYPE abap_compdescr.

DATA:
  pos TYPE i VALUE 1, len TYPE i.




START-OF-SELECTION.

  CREATE DATA d_ref TYPE (pa_dbtab).
  ASSIGN d_ref->* TO <fs_wa>.

* get reference to type descripion object by widening cast:
  descr_ref ?= cl_abap_typedescr=>describe_by_data( <fs_wa> ).

* list headings:
  sy-tvar1 = descr_ref->absolute_name+6.

* dynamical data selection and output:
  SELECT * FROM (pa_dbtab) INTO <fs_wa>.

    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa> TO <fs_comp>.
      IF sy-subrc NE 0.
        NEW-LINE.
        EXIT.
      ENDIF.

      WRITE <fs_comp>.

    ENDDO.
  ENDSELECT.


TOP-OF-PAGE.
* create the header line dynamically:
  LOOP AT descr_ref->components INTO wa_comp.
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
