class CX_BC401_EXCD_LIST definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class CX_BC401_EXCD_LIST
*"* do not include other source files here!!!
public section.

  constants CX_BC401_EXCD_LIST type SOTR_CONC
 value 'E892FB0CE2DC0C44B9D783CAF7249075'. "#EC NOTEXT

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .
protected section.
*"* protected components of class CX_D620AW_EXCD_LIST
*"* do not include other source files here!!!
private section.
*"* private components of class CX_D620AW_EXCD_LIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS CX_BC401_EXCD_LIST IMPLEMENTATION.


method CONSTRUCTOR .
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = CX_BC401_EXCD_LIST .
 ENDIF.
endmethod.
ENDCLASS.
