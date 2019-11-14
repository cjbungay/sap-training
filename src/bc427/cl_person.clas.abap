class CL_PERSON definition
  public
  create public .

*"* public components of class CL_PERSON
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING .
  methods DISPLAY_ATTRIBUTES .
  methods SET_NAME
    importing
      !IM_NAME type STRING .
  methods GET_NAME
    exporting
      !EX_NAME type STRING .
protected section.
*"* protected components of class CL_PERSON
*"* do not include other source files here!!!
private section.
*"* private components of class CL_PERSON
*"* do not include other source files here!!!

  data NAME type STRING .
ENDCLASS.



CLASS CL_PERSON IMPLEMENTATION.


METHOD CONSTRUCTOR .
  name = im_name.
ENDMETHOD.


METHOD DISPLAY_ATTRIBUTES .

  WRITE: / icon_customer AS ICON , name.

ENDMETHOD.


method GET_NAME.
  ex_name = name.
endmethod.


method SET_NAME.
  name = im_name.
endmethod.
ENDCLASS.
