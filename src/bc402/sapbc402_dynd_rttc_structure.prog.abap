*&---------------------------------------------------------------------*
*& Report  SAPBC402_DYND_RTTC_STRUCTURE
*&
*&---------------------------------------------------------------------*
*&
*& This program uses RTTC to create a structure type dynamically.
*&
*& This dynamically created type is compatible
*& with the statically declared type ty_mytype
*&
*& To proof this,
*& the field symbol <fs_struct> is declared with the static type
*& and the data object ref_data is created with the dynamic type
*&
*& (normally one would declare the field-symbol with type ANY)
*&---------------------------------------------------------------------*
REPORT  sapbc402_dynd_rttc_structure.

* declaration of the static type
TYPES:
   BEGIN OF ty_mystruct,
     comp1 TYPE i,
     comp2 TYPE c LENGTH 8,
     comp3 TYPE p LENGTH 4 DECIMALS 2,
     comp4 TYPE s_carr_id,
   END OF ty_mystruct.

* field symbol with static type
FIELD-SYMBOLS:
 <fs_struct> TYPE ty_mystruct.

* data objects needed for the creation of the dynamic type
DATA:
 ref_data   TYPE REF TO data,
 ref_struct TYPE REF TO cl_abap_structdescr,

 ref_comp1 TYPE REF TO cl_abap_elemdescr,
 ref_comp2 TYPE REF TO cl_abap_elemdescr,
 ref_comp3 TYPE REF TO cl_abap_elemdescr,
 ref_comp4 TYPE REF TO cl_abap_elemdescr,

 lt_components TYPE abap_component_tab,
 ls_components LIKE LINE OF lt_components.
*======================================================================*
START-OF-SELECTION.

* Get descriptor for first component (complete built in ABAP type)
*----------------------------------------------------------------------*
  ref_comp1 = cl_abap_elemdescr=>get_i( ).

* Get descriptor for second component (built in ABAP type plus length)
*----------------------------------------------------------------------*
  TRY.
      ref_comp2 = cl_abap_elemdescr=>get_c( p_length = 8  ).
    CATCH cx_parameter_invalid_range.
      MESSAGE e701(bc402).
*   Unerkannter Fehler!
  ENDTRY.

* Get descriptor for third component
*----------------------------------------------------------------------*
  TRY.
      ref_comp3 = cl_abap_elemdescr=>get_p( p_length   = 4
                                            p_decimals = 2 ).
    CATCH cx_parameter_invalid_range.
      MESSAGE e701(bc402).
*   Unerkannter Fehler!
  ENDTRY.

* Get descriptor for fourth component (data element in dictionary)
*----------------------------------------------------------------------*
  TRY.
      ref_comp4 ?= cl_abap_typedescr=>describe_by_name(
                                      p_name = 'S_CARR_ID' ).
    CATCH cx_sy_move_cast_error.
      MESSAGE e701(bc402).
*   Unerkannter Fehler!
  ENDTRY.

* build components table
*----------------------------------------------------------------------*
  CLEAR ls_components.
  ls_components-name = 'COMP1'.
  ls_components-type = ref_comp1.
  APPEND ls_components TO lt_components.

  CLEAR ls_components.
  ls_components-name = 'COMP2'.
  ls_components-type = ref_comp2.
  APPEND ls_components TO lt_components.

  CLEAR ls_components.
  ls_components-name = 'COMP3'.
  ls_components-type = ref_comp3.
  APPEND ls_components TO lt_components.

  CLEAR ls_components.
  ls_components-name = 'COMP4'.
  ls_components-type = ref_comp4.
  APPEND ls_components TO lt_components.

* create structure type
*----------------------------------------------------------------------*
 TRY.
      ref_struct = cl_abap_structdescr=>create(
                    p_components = lt_components ).
    CATCH cx_sy_struct_creation.
      MESSAGE e804(bc402).
*   Fehler beim Erzeugen des Strukturtyps
  ENDTRY.

* create data object with generic type
*----------------------------------------------------------------------*
  CREATE DATA ref_data TYPE HANDLE ref_struct.

* assign to field symbol with compatible static type
*----------------------------------------------------------------------*

  ASSIGN ref_data->* TO <fs_struct>."no error here -> compatible types

* use data object.
*----------------------------------------------------------------------*
  <fs_struct>-comp1 = 123567.
  <fs_struct>-comp2 = 'TESTTEXT'.
  <fs_struct>-comp3 = '47.11'.
  <fs_struct>-comp4 = 'LH'.


  WRITE:
   / 'COMP1:', <fs_struct>-comp1,
   / 'COMP2:', <fs_struct>-comp2,
   / 'comp3:', <fs_struct>-comp3,
   / 'COMP4:', <fs_struct>-comp4.
