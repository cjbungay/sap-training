*&---------------------------------------------------------------------*
*& Report  SAPBC401_VEHT_MAIN_A                                        *
*&---------------------------------------------------------------------*
*&     just some additional objects to be copied !                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_veht_main_a.

TYPES: ty_fuel TYPE p DECIMALS 2,
       ty_cargo TYPE p DECIMALS 2.

TYPE-POOLS icon.
INCLUDE sapbc401_vehd_f.

DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      r_rental TYPE REF TO lcl_rental.

START-OF-SELECTION.
*##########################

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
******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'VOLVO'
                                  im_cargo = 48.
  r_rental->add_vehicle( r_truck ).
