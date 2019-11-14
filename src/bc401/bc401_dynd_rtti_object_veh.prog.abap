*&---------------------------------------------------------------------*
*&  Include           BC401_DYND_RTTI_OBJECT_VEH                       *
*&---------------------------------------------------------------------*


*---------------------------------------------------------------------*
* define client lcl_travel_agency
* it will use the interface lif_partners
*
* implement EVENT in LCL_VEHICLE and LCL_RENTAL
*---------------------------------------------------------------------*
INTERFACE lif_partners.
  METHODS display_partner.
  EVENTS: partner_created.
ENDINTERFACE.                    "lif_partners

*---------------------------------------------------------------------*
*       CLASS lcl_vehicle DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_vehicle DEFINITION.

  PUBLIC SECTION.
    "-------------------
    METHODS: get_average_fuel IMPORTING im_distance TYPE s_distance
                                        im_fuel TYPE ty_fuel
                              RETURNING value(re_avgfuel) TYPE ty_fuel.
    METHODS       constructor IMPORTING im_make TYPE string.
    METHODS       display_attributes.
    METHODS       set_make IMPORTING im_make TYPE string.
    METHODS       get_make EXPORTING ex_make TYPE string.
    CLASS-METHODS get_count EXPORTING re_count TYPE i.
    EVENTS: vehicle_created.

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
    RAISE EVENT vehicle_created.
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
                                        im_cargo TYPE ty_cargo.

    METHODS       display_attributes REDEFINITION.
    METHODS       get_cargo RETURNING value(re_cargo) TYPE ty_cargo.

  PRIVATE SECTION.
    "-------------------
    DATA: max_cargo TYPE ty_cargo.

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
    METHODS       add_vehicle FOR EVENT vehicle_created OF lcl_vehicle
                         IMPORTING sender.
    METHODS       display_attributes.

    INTERFACES: lif_partners.

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
    SET HANDLER add_vehicle FOR ALL INSTANCES.
    RAISE EVENT lif_partners~partner_created.
  ENDMETHOD.                    "constructor

  METHOD  add_vehicle.
    IF pa_bus IS NOT INITIAL.

*   only interested in busses - implemented using RTTI:
*   (alternative solution would be
*    using caught widening cast: ref_bus ?= sender)
      DATA ref_class_descr TYPE REF TO cl_abap_classdescr.

      ref_class_descr ?=
        cl_abap_typedescr=>describe_by_object_ref( sender ).

      IF ref_class_descr->get_relative_name( ) = 'LCL_BUS'.
        APPEND sender TO vehicle_list.
      ENDIF.

    ELSE. " regular demonstration program
      APPEND sender TO vehicle_list.
    ENDIF.

  ENDMETHOD.                    "add_vehicle

  METHOD  display_attributes.
    DATA: r_vehicle TYPE REF TO lcl_vehicle.
    SKIP 2.
    WRITE: /  icon_transport_proposal AS ICON, name.
    WRITE:  ' Here comes the vehicle list: '. ULINE. ULINE.
    LOOP AT vehicle_list INTO r_vehicle.
      r_vehicle->display_attributes( ).
    ENDLOOP.
  ENDMETHOD.                    "display_attributes

ENDCLASS.                    "lcl_rental IMPLEMENTATION


*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_travel_agency DEFINITION.

  PUBLIC SECTION.
    "-------------------
    METHODS:   constructor IMPORTING im_name TYPE string.
    METHODS    add_partner FOR EVENT partner_created OF lif_partners
                               IMPORTING sender.
    METHODS       display_agency_partners.
  PRIVATE SECTION.
    "-------------------
    DATA: name TYPE string,
          partner_list TYPE TABLE OF REF TO lif_partners.
ENDCLASS.                    "lcl_travel_agency DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_travel_agency IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_travel_agency IMPLEMENTATION.
  METHOD display_agency_partners.
    DATA: r_partner TYPE REF TO lif_partners.
    WRITE: icon_dependents AS ICON, name.
    WRITE:  ' Here are the partners of the travel agency: '.
    ULINE.
    ULINE.
    LOOP AT partner_list INTO r_partner.
      r_partner->display_partner( ).
    ENDLOOP.
  ENDMETHOD.                    "display_agency_partners

  METHOD  constructor.
    name = im_name.
    SET HANDLER add_partner FOR ALL INSTANCES.
  ENDMETHOD.                    "constructor

  METHOD  add_partner.
    APPEND sender TO partner_list.
  ENDMETHOD.                    "add_partner

ENDCLASS.                    "lcl_travel_agency IMPLEMENTATION
