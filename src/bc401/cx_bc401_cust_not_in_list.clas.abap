class CX_BC401_CUST_NOT_IN_LIST definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class CX_BC401_CUST_NOT_IN_LIST
*"* do not include other source files here!!!
public section.

  constants CX_BC401_CUST_NOT_IN_LIST type SOTR_CONC value '0AAA9D3DC2AB2225E10000000A114627'. "#EC NOTEXT
  data CUSTOMER type S_CUSTOMER .
  data CARRID type SFLIGHT-CARRID .
  data CONNID type SFLIGHT-CONNID .
  data FLDATE type SFLIGHT-FLDATE .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !CUSTOMER type S_CUSTOMER optional
      !CARRID type SFLIGHT-CARRID optional
      !CONNID type SFLIGHT-CONNID optional
      !FLDATE type SFLIGHT-FLDATE optional .
protected section.
*"* protected components of class CX_CUST_NOT_IN_LIST
*"* do not include other source files here!!!
private section.
*"* private components of class CX_CUST_NOT_IN_LIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS CX_BC401_CUST_NOT_IN_LIST IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
 IF textid IS INITIAL.
   me->textid = CX_BC401_CUST_NOT_IN_LIST .
 ENDIF.
me->CUSTOMER = CUSTOMER .
me->CARRID = CARRID .
me->CONNID = CONNID .
me->FLDATE = FLDATE .
endmethod.
ENDCLASS.
