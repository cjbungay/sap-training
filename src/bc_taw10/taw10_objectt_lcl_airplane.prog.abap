*&---------------------------------------------------------------------*
*&  Include           TAW10_OBJECTD_LCL_AIRPLANE                       *
*&---------------------------------------------------------------------*
*       CLASS lcl_airplane DEFINITION                                  *
*----------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.

    TYPES: name_type(25) TYPE c.
    CONSTANTS: pos_1 TYPE i VALUE 30.

*   Event:   touched_down


    METHODS: constructor IMPORTING im_name TYPE name_type
                                   im_planetype TYPE saplane-planetype,
             set_attributes IMPORTING im_name    TYPE name_type
                                    im_planetype TYPE saplane-planetype,
             display_attributes,
             take_off,
*            Raising event touched_down
             landing.

    CLASS-METHODS: display_n_o_airplanes.

  PROTECTED SECTION.

    DATA: name      TYPE name_type,
          planetype TYPE saplane-planetype.

  PRIVATE SECTION.

    CLASS-DATA: n_o_airplanes TYPE i.

ENDCLASS.                    "lcl_airplane DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                             *
*---------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.

  METHOD constructor.
    name          = im_name.
    planetype     = im_planetype.
    n_o_airplanes = n_o_airplanes + 1.
  ENDMETHOD.                    "constructor

  METHOD set_attributes.
    name      = im_name.
    planetype = im_planetype.
  ENDMETHOD.                    "set_attributes

  METHOD display_attributes.
    WRITE: / 'Name des Flugzeugs:'(001), AT pos_1 name,
           / 'Flugzeugtyp:'(002), AT pos_1 planetype.
  ENDMETHOD.                    "display_attributes

  METHOD display_n_o_airplanes.
    WRITE: /, / 'Anzahl der Flugzeuge:'(ca1),
           AT pos_1 n_o_airplanes LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "display_n_o_airplanes

  METHOD take_off.
    WRITE: / name, AT 15 'Flieger, grüß mir die Sonne ...'(fly).
  ENDMETHOD.                    "take_off

  METHOD landing.
    WRITE: / name, AT 15 'Touch Down!'(lnd).
*    Raising event touched_down

  ENDMETHOD.                    "landing

ENDCLASS.                    "lcl_airplane IMPLEMENTATION
