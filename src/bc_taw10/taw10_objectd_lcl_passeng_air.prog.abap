*&---------------------------------------------------------------------*
*&  Include           TAW10_OBJECTD_LCL_PASSENG_AIR                    *
*&---------------------------------------------------------------------*
*       CLASS lcl_passenger_airplane DEFINITION                        *
*----------------------------------------------------------------------*
CLASS lcl_passenger_airplane DEFINITION INHERITING FROM lcl_airplane.

  PUBLIC SECTION.

    METHODS: constructor IMPORTING im_name      TYPE name_type
                                   im_planetype TYPE saplane-planetype
                                   im_n_o_seats TYPE sflight-seatsmax,
             display_attributes REDEFINITION.

  PRIVATE SECTION.

    DATA: n_o_seats TYPE sflight-seatsmax.

ENDCLASS.                    "lcl_passenger_airplane DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_passenger_airplane IMPLEMENTATION                   *
*---------------------------------------------------------------------*
CLASS lcl_passenger_airplane IMPLEMENTATION.

  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        im_name      = im_name
        im_planetype = im_planetype.
    n_o_seats = im_n_o_seats.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    CALL METHOD super->display_attributes.
    WRITE: / 'Anzahl Sitzplätze:'(003), 25 n_o_seats, /.
  ENDMETHOD.                    "display_attributes

ENDCLASS.                    "lcl_passenger_airplane IMPLEMENTATION
