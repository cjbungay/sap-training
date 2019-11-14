*&---------------------------------------------------------------------*
*&  Include           BC405_ARCD_CREATEK01
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       CLASS exc_handler DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS exc_handler DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS process_alv_error_msg IMPORTING r_error TYPE REF TO
    cx_salv_error     .

ENDCLASS.                    "exc_handler DEFINITION

*---------------------------------------------------------------------*
*       CLASS exc_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS exc_handler IMPLEMENTATION.
  METHOD process_alv_error_msg.
    DATA: result_message TYPE bal_s_msg .
    result_message = r_error->get_message(  ).
    MESSAGE ID result_message-msgid
            TYPE 'A'
            NUMBER result_message-msgno
            WITH result_message-msgv1
                 result_message-msgv2
                 result_message-msgv3
                 result_message-msgv4.

  ENDMETHOD.                    "process_alv_error_msg

ENDCLASS.                    "exc_handler IMPLEMENTATION
