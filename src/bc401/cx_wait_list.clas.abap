class CX_WAIT_LIST definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

*"* public components of class CX_WAIT_LIST
*"* do not include other source files here!!!
public section.

  interfaces IF_T100_MESSAGE .

  constants:
    begin of CX_WAIT_LIST,
      msgid type symsgid value 'TAW10',
      msgno type symsgno value '002',
      attr1 type scx_attrname value 'CARRID',
      attr2 type scx_attrname value 'CONNID',
      attr3 type scx_attrname value 'FLDATE',
      attr4 type scx_attrname value '',
    end of CX_WAIT_LIST .
  constants:
    begin of CX_WAIT_LIST_EXISTS,
      msgid type symsgid value 'TAW10',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'CARRID',
      attr2 type scx_attrname value 'CONNID',
      attr3 type scx_attrname value 'FLDATE',
      attr4 type scx_attrname value '',
    end of CX_WAIT_LIST_EXISTS .
  constants:
    begin of CX_WAIT_LIST_NO_ENTRY,
      msgid type symsgid value 'TAW10',
      msgno type symsgno value '003',
      attr1 type scx_attrname value 'CARRID',
      attr2 type scx_attrname value 'CONNID',
      attr3 type scx_attrname value 'FLDATE',
      attr4 type scx_attrname value '',
    end of CX_WAIT_LIST_NO_ENTRY .
  constants:
    begin of CX_WAIT_LIST_CUSTOMER_THERE,
      msgid type symsgid value 'TAW10',
      msgno type symsgno value '009',
      attr1 type scx_attrname value 'CUSTOMER',
      attr2 type scx_attrname value 'CARRID',
      attr3 type scx_attrname value 'CONNID',
      attr4 type scx_attrname value 'FLDATE',
    end of CX_WAIT_LIST_CUSTOMER_THERE .
  constants:
    begin of CX_WAIT_LIST_CUSTOMER_NOTTHERE,
      msgid type symsgid value 'TAW10',
      msgno type symsgno value '011',
      attr1 type scx_attrname value 'CUSTOMER',
      attr2 type scx_attrname value 'CARRID',
      attr3 type scx_attrname value 'CONNID',
      attr4 type scx_attrname value 'FLDATE',
    end of CX_WAIT_LIST_CUSTOMER_NOTTHERE .
  data CARRID type S_CARR_ID .
  data CONNID type S_CONN_ID .
  data FLDATE type S_DATE .
  data CUSTOMER type SCUSTOM-ID .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !CARRID type S_CARR_ID optional
      !CONNID type S_CONN_ID optional
      !FLDATE type S_DATE optional
      !CUSTOMER type SCUSTOM-ID optional .
protected section.
*"* protected components of class CX_WAIT_LIST
*"* do not include other source files here!!!
private section.
*"* private components of class CX_WAIT_LIST
*"* do not include other source files here!!!
ENDCLASS.



CLASS CX_WAIT_LIST IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->CARRID = CARRID .
me->CONNID = CONNID .
me->FLDATE = FLDATE .
me->CUSTOMER = CUSTOMER .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = CX_WAIT_LIST .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
