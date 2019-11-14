class CX_BC402_NO_CONNECTION definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class CX_BC402_NO_CONNECTION
*"* do not include other source files here!!!
public section.

  constants CX_BC402_NO_CONNECTION type SOTR_CONC value '83520F424C4B430FE10000000A114735'. "#EC NOTEXT
  data CITYFROM type S_FROM_CIT .
  data CITYTO type S_TO_CITY .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !CITYFROM type S_FROM_CIT optional
      !CITYTO type S_TO_CITY optional .
protected section.
*"* protected components of class CX_BC401_INVALID_PLANETYPE
*"* do not include other source files here!!!
private section.
*"* private components of class CX_BC402_NO_CONNECTION
*"* do not include other source files here!!!
ENDCLASS.



CLASS CX_BC402_NO_CONNECTION IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = CX_BC402_NO_CONNECTION .
 ENDIF.
me->CITYFROM = CITYFROM .
me->CITYTO = CITYTO .
endmethod.
ENDCLASS.
