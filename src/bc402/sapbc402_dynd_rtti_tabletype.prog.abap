*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYND_RTTI_TABLE
*&
*&---------------------------------------------------------------------*
*&
*& This program uses RTTI to
*& provide information about a table type,
*& its line type
*& and components
*&
*&---------------------------------------------------------------------*
REPORT  sapbc402_dynd_rtti_table.

PARAMETERS:
  pa_type TYPE dd40l-typename  DEFAULT `BC402_T_NEST`.
*  pa_type TYPE c LENGTH 30  DEFAULT `BC402_T_SPFLI`.

DATA:
  ref_type  TYPE REF TO cl_abap_typedescr,
  ref_table TYPE REF TO cl_abap_tabledescr,
  ref_struc TYPE REF TO cl_abap_structdescr,

  it_components TYPE abap_component_tab,
  wa_components TYPE abap_componentdescr,

  it_comp       TYPE abap_compdescr_tab,
  wa_comp       TYPE abap_compdescr,


  it_ddfields   TYPE ddfields,
  wa_ddfields   TYPE dfies.


* get description object for table type
*&---------------------------------------------------------------------*
CALL METHOD cl_abap_typedescr=>describe_by_name
  EXPORTING
    p_name         = pa_type
  RECEIVING
    p_descr_ref    = ref_type
  EXCEPTIONS
    type_not_found = 1
    OTHERS         = 2.
IF sy-subrc <> 0.
  MESSAGE e801(bc402) WITH pa_type.
*   Typ &1 wurde nicht gefunden
ENDIF.

TRY.
    ref_table ?= ref_type.
  CATCH cx_sy_move_cast_error.
    MESSAGE e800(bc402) WITH pa_type.
ENDTRY.

WRITE:
   / 'Table type name:', 20 ref_table->absolute_name,
   / 'Table type kind:'.

CASE ref_table->table_kind.
  WHEN cl_abap_tabledescr=>tablekind_sorted.
    WRITE 20 'sorted table'.
  WHEN cl_abap_tabledescr=>tablekind_std.
    WRITE 20 'standard table'.
  WHEN cl_abap_tabledescr=>tablekind_hashed.
    WRITE 20 'hashed table'.
  WHEN OTHERS.
    WRITE 20 'generic'.
ENDCASE.

* get description object for line type
*&---------------------------------------------------------------------*
TRY.
    ref_struc ?= ref_table->get_table_line_type( ).
  CATCH cx_sy_move_cast_error.
    MESSAGE e701(bc402).
*   Unerkannter Fehler!
ENDTRY.

SKIP.
WRITE:
  / 'Line type name:', 20 ref_struc->absolute_name,
  / 'Structure kind:'.

CASE ref_struc->struct_kind.
  WHEN cl_abap_structdescr=>structkind_nested.
    WRITE 20 'nested structure'.
  WHEN cl_abap_structdescr=>structkind_flat.
    WRITE 20 'flat structure'.
ENDCASE.

* get data about components
*&---------------------------------------------------------------------*
it_comp       = ref_struc->components.          "public attribute
it_components = ref_struc->get_components( ).   "method call

CALL METHOD ref_struc->get_ddic_field_list      "method call
*  EXPORTING
*    P_LANGU                  = SY-LANGU
*    P_INCLUDING_SUBSTRUCTRES = ABAP_FALSE
  RECEIVING
    p_field_list             = it_ddfields
  EXCEPTIONS
    not_found                = 1
    no_ddic_type             = 2
    OTHERS                   = 3
        .
IF sy-subrc <> 0.
  MESSAGE e701(bc402).
*   Unerkannter Fehler!
ENDIF.

* content of these three tables: (show in debugger)
*
* it_comp:       technical properties of components
*                 (name, typekind, length)
* it_components: references to description objects
*                of component types
* it_ddfields:   attributes of data elements
*                (e.g. screen texts)

SKIP.
WRITE / 'list of components:'.
LOOP AT it_comp INTO wa_comp.
  READ TABLE it_components INTO wa_components
                           WITH TABLE KEY
                           name = wa_comp-name.
  READ TABLE it_ddfields INTO wa_ddfields WITH KEY
                              fieldname = wa_comp-name.

  WRITE /5 wa_comp-name.

  CASE wa_comp-type_kind.
    WHEN cl_abap_typedescr=>typekind_float.
      WRITE 20 'Float'.
    WHEN cl_abap_typedescr=>typekind_int.
      WRITE 20 'Integer'.
    WHEN cl_abap_typedescr=>typekind_date.
      WRITE 20 'Date'.
    WHEN cl_abap_typedescr=>typekind_time.
      WRITE 20 'Time'.
    WHEN cl_abap_typedescr=>typekind_char.
      WRITE:
            20 'Character',
            30  wa_comp-length.
    WHEN cl_abap_typedescr=>typekind_num.
      WRITE:
            20 'Numchar',
            30  wa_comp-length.
    WHEN cl_abap_typedescr=>typekind_packed.
      WRITE:
            20 'Packed',
            30  wa_comp-length,
                wa_comp-decimals.
    WHEN cl_abap_typedescr=>typekind_struct1.
      WRITE 20 'Flat Structure'.
    WHEN cl_abap_typedescr=>typekind_struct2.
      WRITE 20 'Deep Structure'.
    WHEN cl_abap_typedescr=>typekind_table.
      WRITE 20 'Table'.
    WHEN OTHERS.
      WRITE 20 'Other type'.
  ENDCASE.


  WRITE 60 wa_ddfields-scrtext_m.

ENDLOOP.
