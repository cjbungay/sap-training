*&---------------------------------------------------------------------*
*& Report  SAPBC402_TYPD_DYN_TYPECAST                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  selects all data from a given database table                       *
*&---------------------------------------------------------------------*
*
* First, data is written in the character field 'line'
* (components of database table unknown).
*
* After assigning to the field-symbol '<fs_wa>' and type casting
* access is possible now as if it were a flat structure.
* All types are transmitted together with the name of the DB-table.
*
* names of components of this flat structure still unknown, so all
* components are assigned to the field-symbol '<fs_comp>' in a loop
* in order to display them
*
* problem:
* address of 'line' must be divisible by 4 without remainder
* therefore, data object 'dummy' is declared immediately before
* (Integers are always stored under such addresses.)
*
*&---------------------------------------------------------------------*

REPORT sapbc402_typd_dyn_typecast.

PARAMETERS pa_dbtab TYPE dd02l-tabname.

DATA dummy TYPE i. " address of line mod 4 has to be 0 !!!
DATA line(65535).

FIELD-SYMBOLS:
  <fs_wa>   TYPE ANY,
  <fs_comp> TYPE ANY.


START-OF-SELECTION.

  SELECT * FROM (pa_dbtab) INTO line.
    ASSIGN line TO <fs_wa> CASTING TYPE (pa_dbtab).
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa> TO <fs_comp>.
      IF sy-subrc <> 0.
        SKIP.
        EXIT.
      ENDIF.
      WRITE <fs_comp>.
    ENDDO.
  ENDSELECT.

