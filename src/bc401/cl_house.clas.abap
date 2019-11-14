class CL_HOUSE definition
  public
  create public .

*"* public components of class CL_HOUSE
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING .
  methods DISPLAY_ATTRIBUTES .
protected section.
*"* protected components of class CL_HOUSE
*"* do not include other source files here!!!

  data NAME type STRING .
private section.
*"* private components of class CL_HOUSE
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_HOUSE IMPLEMENTATION.


METHOD constructor .
  name = im_name.
ENDMETHOD.


METHOD display_attributes .

  SKIP 2.
  WRITE: / icon_warehouse AS ICON , name.

ENDMETHOD.
ENDCLASS.
