*&---------------------------------------------------------------------*
*&  Include           SAPBC401_AIRS_C                                  *
*&  Show functional static method get_n_o_airplanes                    *
*&---------------------------------------------------------------------*


*------------------------------------------------------------------*
*       CLASS lcl_airplane DEFINITION                              *
*------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    "--------------------------------
    CONSTANTS: pos_1 TYPE i VALUE 30.

    METHODS: set_attributes IMPORTING
                   im_name      TYPE string
                   im_planetype TYPE saplane-planetype,
             display_attributes.

    CLASS-METHODS: display_n_o_airplanes,
                   get_n_o_airplanes RETURNING value(re_count) TYPE i.

  PRIVATE SECTION.
    "----------------------------------
    DATA: name      TYPE string,
          planetype TYPE saplane-planetype.

    CLASS-DATA: n_o_airplanes TYPE i.

ENDCLASS.                    "lcl_airplane DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.

  METHOD set_attributes.
    name          = im_name.
    planetype     = im_planetype.
    n_o_airplanes = n_o_airplanes + 1.
  ENDMETHOD.                    "set_attributes

  METHOD display_attributes.
    WRITE: / icon_ws_plane AS ICON,
           / 'Name of airplane:'(001), AT pos_1 name,
           / 'Typ of airplane'(002), AT pos_1 planetype.
  ENDMETHOD.                    "display_attributes

  METHOD display_n_o_airplanes.
    WRITE: /, / 'Total number of airplanes'(ca1),
           AT pos_1 n_o_airplanes LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "display_n_o_airplanes

  METHOD get_n_o_airplanes.
    re_count = n_o_airplanes.
  ENDMETHOD.                    "get_n_o_airplanes

ENDCLASS.                    "lcl_airplane IMPLEMENTATION
