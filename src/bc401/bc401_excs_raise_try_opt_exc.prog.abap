*&---------------------------------------------------------------------*
*&  Include           BC401_EXCS_RAISE_TRY_OPT_EXC                     *
*&---------------------------------------------------------------------*


*---------------------------------------------------------------------*
*       CLASS lcx_list_error DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcx_list_error DEFINITION INHERITING FROM cx_static_check.

  PUBLIC SECTION.
    METHODS get_exc_text
            RETURNING value(result) TYPE string.

ENDCLASS.                    "lcx_list_error DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcx_list_error IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcx_list_error IMPLEMENTATION.

  METHOD get_exc_text.
    result = 'The list contains an error.'(err).
  ENDMETHOD.                    "get_text

ENDCLASS.                    "lcx_list_error IMPLEMENTATION
