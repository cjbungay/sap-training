class CL_BC401_FLIGHT definition
  public
  create public .

*"* public components of class CL_BC401_FLIGHT
*"* do not include other source files here!!!
public section.

  class-methods GET_SEP_STRING
    importing
      !IM_NUMBER type I default '1'
      !IM_TABLE_NAME type TABNAME default 'SFLIGHT'
      !IM_SEPARATOR type C default '#'
      !IM_UNIQUE type C default 'X'
    returning
      value(EX_STRING) type STRING
    raising
      CX_BC401_NO_DATA .
protected section.
*"* protected components of class CL_BC401_FLIGHT
*"* do not include other source files here!!!
private section.
*"* private components of class CL_BC401_FLIGHT
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_BC401_FLIGHT IMPLEMENTATION.


METHOD get_sep_string .

* data object 'd_ref' is created dynamically based on the line type of
* the given database table
*
* we have to assign it to the field-symbol <fs_wa> in order to select
* the data directly into this data object
*
* names of components of this flat structure still unknown, so all
* components are assigned to the field-symbol '<fs_comp>' in a loop
* in order to concatenate them
*
* every data set will be separated by a doubled separator

  DATA d_ref TYPE REF TO data.
  DATA comp  TYPE string.
  DATA set   TYPE string.
  DATA rem   LIKE sy-dbcnt.

  FIELD-SYMBOLS:
    <fs_wa>   TYPE ANY,
    <fs_comp> TYPE ANY.


  CREATE DATA d_ref TYPE (im_table_name).
  ASSIGN d_ref->* TO <fs_wa>.


  SELECT * FROM (im_table_name) INTO <fs_wa>
           UP TO im_number ROWS.
    CLEAR set.
    CONCATENATE set im_separator INTO set.

    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa> TO <fs_comp>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.

      MOVE <fs_comp> TO comp. "cause of CONCATENATE, get characters
      CONCATENATE set comp INTO set
                           SEPARATED BY im_separator.
      IF comp IS INITIAL.
        CONCATENATE set comp INTO set
                             SEPARATED BY space.
      ENDIF.
    ENDDO.

    CONCATENATE ex_string set INTO ex_string.
    IF im_unique IS INITIAL.
      rem = sy-dbcnt MOD 5.
      IF rem = 0.
        CONCATENATE ex_string set INTO ex_string.
      ENDIF.
    ENDIF.
  ENDSELECT.

  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE cx_bc401_no_data.
  ENDIF.

  CONCATENATE ex_string im_separator im_separator INTO ex_string.

ENDMETHOD.                    "GET_SEP_STRING
ENDCLASS.
