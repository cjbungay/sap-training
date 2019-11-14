*&---------------------------------------------------------------------*
*&  Include           SAPBC401_VEHD_F                                  *
*&---------------------------------------------------------------------*


*---------------------------------------------------------------------*
* define interface lif_partners
*
* implement interface inside of lcl_rental
*---------------------------------------------------------------------*
INTERFACE lif_partners.
  METHODS display_partner.
ENDINTERFACE.                    "lif_partners

*---------------------------------------------------------------------*
*       CLASS lcl_vehicle DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_vehicle DEFINITION.

  PUBLIC SECTION.
    "-------------------
    METHODS: get_average_fuel IMPORTING im_distance TYPE s_distance
                                        im_fuel TYPE s_capacity
                              RETURNING value(re_avgfuel) TYPE s_consum.
    METHODS       constructor IMPORTING im_make TYPE string.
    METHODS       display_attributes.
    METHODS       set_make IMPORTING im_make TYPE string.
    METHODS       get_make EXPORTING ex_make TYPE string.
    CLASS-METHODS get_count EXPORTING re_count TYPE i.

  PRIVATE SECTION.
    "-------------------
    DATA: make   TYPE string.

    METHODS      init_make.

    CLASS-DATA:  n_o_vehicles TYPE i.

ENDCLASS.                    "lcl_vehicle DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_vehicle IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_vehicle IMPLEMENTATION.
  METHOD get_average_fuel.
    re_avgfuel = im_distance / im_fuel.
  ENDMETHOD.                    "get_average_fuel

  METHOD constructor.
    make = im_make.
    ADD 1 TO n_o_vehicles.
  ENDMETHOD.                    "constructor

  METHOD set_make.
    IF im_make IS INITIAL.
      init_make( ).   " me->init_make( ). also possible
    ELSE.
      make = im_make.
    ENDIF.
  ENDMETHOD.                    "set_make

  METHOD init_make.
    make = 'default make'.
  ENDMETHOD.                    "init_make

  METHOD get_make.
    ex_make = make.
  ENDMETHOD.                    "get_make

  METHOD display_attributes.
    WRITE: make.
  ENDMETHOD.                    "display_attributes

  METHOD get_count.
    re_count = n_o_vehicles.
  ENDMETHOD.                    "get_count

ENDCLASS.                    "lcl_vehicle IMPLEMENTATION


*---------------------------------------------------------------------*
*       CLASS lcl_truck DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_truck DEFINITION INHERITING FROM lcl_vehicle.

  PUBLIC SECTION.
    "-------------------
    METHODS:      constructor IMPORTING im_make TYPE string
                                        im_cargo TYPE s_plan_car.

    METHODS       display_attributes REDEFINITION.
    METHODS       get_cargo RETURNING value(re_cargo) TYPE s_plan_car.

  PRIVATE SECTION.
    "-------------------
    DATA: max_cargo TYPE s_plan_car.

ENDCLASS.                    "lcl_truck DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_truck IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_truck IMPLEMENTATION.

  METHOD constructor.
    super->constructor( im_make ).
    max_cargo = im_cargo.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    WRITE: / icon_ws_truck AS ICON.
    super->display_attributes( ).
    WRITE: 20 ' Cargo = ', max_cargo.
    ULINE.
  ENDMETHOD.                    "display_attributes

  METHOD get_cargo.
    re_cargo = max_cargo.
  ENDMETHOD.                    "get_cargo

ENDCLASS.                    "lcl_truck DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_bus DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_bus DEFINITION INHERITING FROM lcl_vehicle.

  PUBLIC SECTION.
    "-------------------
    METHODS:      constructor IMPORTING im_make TYPE string
                                        im_passengers TYPE i.

    METHODS       display_attributes REDEFINITION.

  PRIVATE SECTION.
    "-------------------
    DATA: max_passengers TYPE i.

ENDCLASS.                    "lcl_bus DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_bus IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_bus IMPLEMENTATION.

  METHOD constructor.
    super->constructor( im_make ).
    max_passengers = im_passengers.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    WRITE: / icon_transportation_mode AS ICON.
    super->display_attributes( ).
    WRITE:  20 ' Passengers = ', max_passengers.
    ULINE.
  ENDMETHOD.                    "display_attributes


ENDCLASS.                    "lcl_bus DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_rental DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_rental DEFINITION.

  PUBLIC SECTION.
    "-------------------
    METHODS:      constructor IMPORTING im_name TYPE string.
    METHODS       add_vehicle IMPORTING im_vehicle
                                  TYPE REF TO lcl_vehicle.
    METHODS       display_attributes.
    INTERFACES lif_partners.

  PRIVATE SECTION.
    "-------------------
    DATA: name TYPE string,
          vehicle_list TYPE TABLE OF REF TO lcl_vehicle.
ENDCLASS.                    "lcl_rental DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_rental IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_rental IMPLEMENTATION.

  METHOD lif_partners~display_partner.
    display_attributes( ).
  ENDMETHOD.                    "lif_partners~display_partner

  METHOD  constructor.
    name = im_name.
  ENDMETHOD.                    "constructor

  METHOD  add_vehicle.
    APPEND im_vehicle TO vehicle_list.
  ENDMETHOD.                    "add_vehicle

  METHOD  display_attributes.
    DATA: r_vehicle TYPE REF TO lcl_vehicle.
    WRITE: /  icon_transport_proposal AS ICON, name.
    WRITE:  ' Here comes the vehicle list: '.
    ULINE.
    ULINE.
    LOOP AT vehicle_list INTO r_vehicle.
      r_vehicle->display_attributes( ).
    ENDLOOP.
  ENDMETHOD.                    "display_attributes

ENDCLASS.                    "lcl_rental IMPLEMENTATION
