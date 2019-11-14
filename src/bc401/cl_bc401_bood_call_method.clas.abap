class CL_BC401_BOOD_CALL_METHOD definition
  public
  create public .

*"* public components of class CL_BC401_BOOD_CALL_METHOD
*"* do not include other source files here!!!
public section.

  interfaces IF_BC401_BOOD_EMPTY .

  methods CALLER .
protected section.
*"* protected components of class CL_D620AW_BOOT_CALL_METHOD
*"* do not include other source files here!!!
private section.
*"* private components of class CL_D620AW_BOOD_CALL_METHOD
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_BC401_BOOD_CALL_METHOD IMPLEMENTATION.


METHOD caller .

  DATA l_string TYPE string.

  l_string = 'new character string'(str).

  CALL METHOD me->if_bc401_bood_empty~send_message
    EXPORTING
      im_string = l_string.


ENDMETHOD.                    "CALLER


METHOD if_bc401_bood_empty~send_message .

  MESSAGE im_string TYPE 'I'.

ENDMETHOD.
ENDCLASS.
