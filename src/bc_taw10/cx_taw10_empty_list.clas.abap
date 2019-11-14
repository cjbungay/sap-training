class CX_TAW10_EMPTY_LIST definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class CX_TAW10_EMPTY_LIST
*"* do not include other source files here!!!
public section.

  constants CX_TAW10_EMPTY_LIST type SOTR_CONC
 value '4DAA9D3DC2AB2225E10000000A114627'. "#EC NOTEXT
  data CARRID type SFLIGHT-CARRID .
  data CONNID type SFLIGHT-CONNID .
  data FLDATE type SFLIGHT-FLDATE .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      value(CARRID) type SFLIGHT-CARRID optional
      value(CONNID) type SFLIGHT-CONNID optional
      value(FLDATE) type SFLIGHT-FLDATE optional .
protected section.
*"* protected components of class CX_EMPTY_LIST
*"* do not include other source files here!!!
private section.
*"* private components of class CX_EMPTY_LIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS CX_TAW10_EMPTY_LIST IMPLEMENTATION.


method CONSTRUCTOR .
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = CX_TAW10_EMPTY_LIST .
 ENDIF.
me->CARRID = CARRID .
me->CONNID = CONNID .
me->FLDATE = FLDATE .
endmethod.
ENDCLASS.
