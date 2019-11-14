*&---------------------------------------------------------------------*
*&  Include           SAPBC401_AIRS_D                                  *
*&---------------------------------------------------------------------*


*------------------------------------------------------------------*
*       CLASS lcl_airplane DEFINITION                              *
*------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    "--------------------------------
    CONSTANTS: pos_1 TYPE i VALUE 30.

    METHODS: constructor IMPORTING
                   im_name      TYPE string
                   im_planetype TYPE saplane-planetype,
             display_attributes.

    CLASS-METHODS: class_constructor.
    CLASS-METHODS: display_n_o_airplanes.


  PRIVATE SECTION.
    "----------------------------------
    DATA: name      TYPE string,
          planetype TYPE saplane-planetype.

    CLASS-DATA: n_o_airplanes TYPE i.
    CLASS-DATA: list_of_planetypes TYPE TY_PLANETYPES.

ENDCLASS.                    "lcl_airplane DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.
  METHOD class_constructor.
    SELECT * from saplane into table list_of_planetypes.
  endmethod.                    "class_constructor

  METHOD constructor.
    name          = im_name.
    planetype     = im_planetype.
    n_o_airplanes = n_o_airplanes + 1.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    WRITE: / icon_ws_plane AS ICON,
           / 'Name of Airplane'(001), AT pos_1 name,
           / 'Type of airplane: '(002), AT pos_1 planetype.
  ENDMETHOD.                    "display_attributes

  METHOD display_n_o_airplanes.
    WRITE: /, / 'Number of airplanes: '(ca1),
           AT pos_1 n_o_airplanes LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "display_n_o_airplanes

ENDCLASS.                    "lcl_airplane IMPLEMENTATION
