REPORT  BC427_IEP_LOCCLASS.


CLASS lcl_plane DEFINITION.

  PUBLIC SECTION.

    METHODS: constructor
               IMPORTING
                 im_name      TYPE string
                 im_planetype TYPE saplane-planetype,

             set_attributes
               IMPORTING
                 im_name      TYPE string
                 im_planetype TYPE saplane-planetype.

  PRIVATE SECTION.

    CLASS-DATA n_o_planes TYPE i.

    DATA: name      TYPE string,
          planetype TYPE saplane-planetype.

ENDCLASS.                    "lcl_airplane DEFINITION


CLASS lcl_plane IMPLEMENTATION.

  METHOD constructor.
    name          = im_name.
    planetype     = im_planetype.
    n_o_planes = n_o_planes + 1.
  ENDMETHOD.                    "constructor

  METHOD set_attributes.
    name          = im_name.
    planetype     = im_planetype.
  ENDMETHOD.                    "set_attributes

ENDCLASS.                    "lcl_airplane IMPLEMENTATION



**********************************************************
*  Main program
**********************************************************
  ...
