*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYND_RTTI_OBJECT                                   *
*&---------------------------------------------------------------------*
REPORT  sapbc401_dynd_rtti_object.

TYPES ty_itab TYPE STANDARD TABLE OF spfli WITH KEY carrid.
*---------------------------------------------------------------------*
*       CLASS dummy DEFINITION
*---------------------------------------------------------------------*
CLASS dummy DEFINITION.
  PUBLIC SECTION.
    METHODS imp_test IMPORTING value(im_var1) TYPE i DEFAULT 24
                               im_var2 TYPE i OPTIONAL.

    METHODS exp_test EXPORTING ex_var TYPE i
                               ex_ref type ref to ty_itab.
    DATA: var TYPE i VALUE 0.
    DATA: itab TYPE ty_itab.
    DATA: r_ref TYPE REF TO ty_itab.
ENDCLASS.                    "dummy DEFINITION

*---------------------------------------------------------------------*
*       CLASS dummy IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS dummy IMPLEMENTATION.
  METHOD imp_test.
    var = im_var1.
  ENDMETHOD.                    "test

  METHOD exp_test.
    SELECT * FROM spfli INTO CORRESPONDING FIELDS OF TABLE itab.
    ex_var = var.
*   Durchreichen der gekapselten Itab aus der KLasse !!!
*   --> geht !!! Hammer !!!
    GET REFERENCE OF itab INTO r_ref.
    ex_ref = r_Ref.
  ENDMETHOD.                    "test

ENDCLASS.                    "dummy IMPLEMENTATION

DATA: r_dummy TYPE REF TO dummy.
DATA: glob_var TYPE i VALUE 8.
data: r_ref type ref to ty_itab.
DATA: wa type spfli.

START-OF-SELECTION.
*########################

  CREATE OBJECT r_dummy.
*  r_dummy->imp_test( EXPORTING im_var1 = glob_var ).
*  WRITE: / r_dummy->var.

  r_dummy->exp_test( IMPORTING ex_var = glob_var
                               ex_ref = r_Ref ).

  DELETE TABLE r_Ref->* WITH TABLE KEY carrid = 'AA'.

  WRITE: / glob_var.
  LOOP AT r_ref->* INTO wa.
    WRITE: / wa-carrid, wa-connid.
  ENDLOOP.
