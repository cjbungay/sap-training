*&---------------------------------------------------------------------*
*& Report  SAPBC401_VEHD_MAIN_H                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&       Use client class lcl_rental                                   *
*&       show polymorphic behaviour in method display_attributes of    *
*&       client lcl_rental                                             *
*&---------------------------------------------------------------------*

REPORT  sapbc401_vehd_main_h.

TYPES: ty_fuel TYPE p DECIMALS 2,
       ty_cargo TYPE p DECIMALS 2.

type-pools icon.

INCLUDE sapbc401_vehd_e.

DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      r_rental type ref to lcl_rental,
      count TYPE i,
      itab TYPE TABLE OF REF TO lcl_vehicle,
      cargo type ty_cargo.


START-OF-SELECTION.
*########################

******* create rental *****************************************
  CREATE OBJECT r_rental EXPORTING im_name = 'HAPPY CAR RENTAL'.


******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'MAN'
                                  im_cargo = 45.
  r_rental->add_vehicle( r_truck ).

******* create truck *****************************************
  CREATE OBJECT r_bus EXPORTING im_make = 'Mercedes'
                                im_passengers = 80.

  r_rental->add_vehicle( r_bus ).

  r_rental->display_attributes( ).
