class CX_BC401_NO_DATA definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class CX_BC401_NO_DATA
*"* do not include other source files here!!!
public section.

  constants CX_BC401_NO_DATA type SOTR_CONC
 value '8D0358FA58B5804F8E598B376F603067' .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .
protected section.
*"* protected components of class CX_BC401_NO_DATA
*"* do not include other source files here!!!
private section.
*"* private components of class CX_BC401_NO_DATA
*"* do not include other source files here!!!
ENDCLASS.



CLASS CX_BC401_NO_DATA IMPLEMENTATION.


method CONSTRUCTOR .
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = CX_BC401_NO_DATA .
 ENDIF.
endmethod.
ENDCLASS.
