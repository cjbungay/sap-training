*&---------------------------------------------------------------------*
*& Report  SAPBC401_INTS_MAIN_K                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&       Use Interface lif_partner                                     *
*&      call client methods ( lcl_travel_agency )                      *
*&---------------------------------------------------------------------*

REPORT  sapbc401_ints_main_k.

TYPES: ty_fuel TYPE p DECIMALS 2,
       ty_cargo TYPE p DECIMALS 2.

TYPE-POOLS icon.

INCLUDE sapbc401_vehd_g.


DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      r_rental TYPE REF TO lcl_rental,
      r_agency TYPE REF TO lcl_travel_agency,
      count TYPE i,
      itab TYPE TABLE OF REF TO lcl_vehicle,
      cargo TYPE ty_cargo.


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
  r_rental->add_vehicle( r_truck ).
******* create truck *****************************************
  CREATE OBJECT r_bus EXPORTING im_make = 'Mercedes'
                                im_passengers = 80.
  r_rental->add_vehicle( r_bus ).
******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'VOLVO'
                                  im_cargo = 48.
  r_rental->add_vehicle( r_truck ).



******* show attributes of all partners of travel_agency ******
  r_agency->display_agency_partners( ).
