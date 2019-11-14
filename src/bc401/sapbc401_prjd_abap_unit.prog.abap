**&---------------------------------------------------------------------
**
**& Report  SAPBC401_PRJD_ABAP_UNIT
**&
**&---------------------------------------------------------------------
REPORT  sapbc401_prjd_abap_unit.

CLASS myclass DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA text TYPE string.
    CLASS-METHODS set_text_to_x.
ENDCLASS.

CLASS myclass IMPLEMENTATION.
  METHOD set_text_to_x.
    text = 'U'.
  ENDMETHOD.
ENDCLASS.

* Test classes
CLASS mytest DEFINITION FOR TESTING.
  PRIVATE SECTION.
    METHODS mytest FOR TESTING.
ENDCLASS.

CLASS mytest IMPLEMENTATION.
  METHOD mytest.
    myclass=>set_text_to_x( ).
    cl_aunit_assert=>assert_equals( act = myclass=>text
                                    exp = 'X' ).
  ENDMETHOD.
ENDCLASS.
