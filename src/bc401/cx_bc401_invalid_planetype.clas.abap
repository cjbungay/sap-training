class CX_BC401_INVALID_PLANETYPE definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class CX_BC401_INVALID_PLANETYPE
*"* do not include other source files here!!!
public section.

  constants CX_BC401_INVALID_PLANETYPE type SOTR_CONC
 value '1F78650CA02A1F46A62015E726584428' .
  data PLANETYPE type S_PLANETYE .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      value(PLANETYPE) type S_PLANETYE optional .
protected section.
*"* protected components of class CX_BC401_INVALID_PLANETYPE
*"* do not include other source files here!!!
private section.
*"* private components of class CX_BC401_INVALID_PLANETYPE
*"* do not include other source files here!!!
ENDCLASS.



CLASS CX_BC401_INVALID_PLANETYPE IMPLEMENTATION.


method CONSTRUCTOR .
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = CX_BC401_INVALID_PLANETYPE .
 ENDIF.
me->PLANETYPE = PLANETYPE .
endmethod.
ENDCLASS.
