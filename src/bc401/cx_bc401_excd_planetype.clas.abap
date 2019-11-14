class CX_BC401_EXCD_PLANETYPE definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class CX_BC401_EXCD_PLANETYPE
*"* do not include other source files here!!!
public section.

  constants CX_BC401_EXCD_PLANETYPE type SOTR_CONC
 value 'A2C7363582181240B1456524D584F520'. "#EC NOTEXT
  constants CX_BC401_EXCD_PLANETYPE_F type SOTR_CONC
 value 'CA3A6E3F49819228E10000000A114627'. "#EC NOTEXT
  data PLANETYPE type SAPLANE-PLANETYPE read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      value(PLANETYPE) type SAPLANE-PLANETYPE optional .
protected section.
*"* protected components of class CX_D620AW_EXCD_PLANETYPE
*"* do not include other source files here!!!
private section.
*"* private components of class CX_D620AW_EXCD_PLANETYPE
*"* do not include other source files here!!!
ENDCLASS.



CLASS CX_BC401_EXCD_PLANETYPE IMPLEMENTATION.


method CONSTRUCTOR .
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = CX_BC401_EXCD_PLANETYPE .
 ENDIF.
me->PLANETYPE = PLANETYPE .
endmethod.
ENDCLASS.
