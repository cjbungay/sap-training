class CL_BC401_BOOT_CALL_METHOD definition
  public
  create public .

*"* public components of class CL_BC401_BOOT_CALL_METHOD
*"* do not include other source files here!!!
public section.

  interfaces IF_BC401_BOOT_EMPTY .

  methods CALLER .
protected section.
*"* protected components of class CL_D620AW_BOOT_CALL_METHOD
*"* do not include other source files here!!!
private section.
*"* private components of class CL_D620AW_BOOT_CALL_METHOD
*"* do not include other source files here!!!

  methods SEND_MESSAGE
    importing
      !IM_STRING type STRING default 'some characters ...' .
ENDCLASS.



CLASS CL_BC401_BOOT_CALL_METHOD IMPLEMENTATION.


METHOD CALLER .

  DATA l_string TYPE string.

  l_string = 'new character string'(str).

  CALL METHOD me->send_message
    EXPORTING
      im_string = l_string.


ENDMETHOD.                    "CALLER


METHOD SEND_MESSAGE .

  MESSAGE im_string TYPE 'I'.

ENDMETHOD.                    "SEND_MESSAGE
ENDCLASS.
