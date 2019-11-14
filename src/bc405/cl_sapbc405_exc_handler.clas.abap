class CL_SAPBC405_EXC_HANDLER definition
  public
  create public .

*"* public components of class CL_SAPBC405_EXC_HANDLER
*"* do not include other source files here!!!
public section.

  class-methods PROCESS_ALV_ERROR_MSG
    importing
      !R_ERROR type ref to CX_SALV_ERROR
      !TYPE type SYMSGTY default 'A' .
  class-methods PROCESS_ALV_NOT_FOUND
    importing
      !R_NOT_FOUND type ref to CX_SALV_NOT_FOUND
      !TYPE type SY-MSGTY default  'A' .
protected section.
*"* protected components of class CL_SAPBC405_EXC_HANDLER
*"* do not include other source files here!!!
private section.
*"* private components of class CL_SAPBC405_EXC_HANDLER
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_SAPBC405_EXC_HANDLER IMPLEMENTATION.


METHOD process_alv_error_msg.

  DATA: result_message TYPE bal_s_msg .
  result_message = r_error->get_message(  ).
  MESSAGE ID result_message-msgid
          TYPE type
          NUMBER result_message-msgno
          WITH result_message-msgv1
               result_message-msgv2
               result_message-msgv3
               result_message-msgv4.


ENDMETHOD.


method PROCESS_ALV_NOT_FOUND.

  DATA: result_message TYPE bal_s_msg .
  result_message = r_not_found->get_message(  ).
  MESSAGE ID result_message-msgid
          TYPE type
          NUMBER result_message-msgno
          WITH result_message-msgv1
               result_message-msgv2
               result_message-msgv3
               result_message-msgv4.
endmethod.
ENDCLASS.
