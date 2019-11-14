*&---------------------------------------------------------------------*
*& Report  SAPBC401_EVED_MAIN_L                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&       Implement Event                                               *
*&---------------------------------------------------------------------*

REPORT  sapbc401_eved_main_l.

TYPES: ty_fuel TYPE p DECIMALS 2,
       ty_cargo TYPE p DECIMALS 2.

TYPE-POOLS icon.

INCLUDE sapbc401_vehd_h.


DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      r_rental TYPE REF TO lcl_rental,
      r_agency TYPE REF TO lcl_travel_agency.


START-OF-SELECTION.
*########################

******* create travel_agency *****************************************
  CREATE OBJECT r_agency EXPORTING im_name = 'Fly&Smile Travel'.

******* create rental *****************************************
  CREATE OBJECT r_rental EXPORTING im_name = 'HAPPY CAR RENTAL'.

  r_agency->add_partner( r_rental ).

******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'MAN'
                                  im_cargo = 45.
*  r_rental->add_vehicle( r_truck ).
******* create truck *****************************************
  CREATE OBJECT r_bus EXPORTING im_make = 'Mercedes'
                                im_passengers = 80.
*  r_rental->add_vehicle( r_bus ).
******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'VOLVO'
                                  im_cargo = 48.
*  r_rental->add_vehicle( r_truck ).


******* show attributes of all partners of travel_agency ******
  r_agency->display_agency_partners( ).
