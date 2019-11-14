*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYND_RTTI_OBJECT                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*&       Implement Events in lcl_vehicle and lcl_airplane              *
*&       Implement Events in lcl_carrier and lcl_rental                *
*&---------------------------------------------------------------------*

REPORT  sapbc401_dynd_rtti_object.

PARAMETERS pa_bus AS CHECKBOX DEFAULT 'X'.

TYPES: ty_fuel TYPE p DECIMALS 2,
       ty_cargo TYPE p DECIMALS 2.

TYPE-POOLS icon.

INCLUDE bc401_dynd_rtti_object_veh.
INCLUDE bc401_dynd_rtti_object_air.



DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      r_passenger TYPE REF TO lcl_passenger_plane,
      r_cargo TYPE REF TO lcl_cargo_plane,
      r_carrier TYPE REF TO lcl_carrier,
      r_rental TYPE REF TO lcl_rental,
      r_agency TYPE REF TO lcl_travel_agency.


START-OF-SELECTION.
*########################

******* create travel_agency *****************************************
  CREATE OBJECT r_agency EXPORTING im_name = 'Fly&Smile Travel'.


******* create rental *****************************************
  CREATE OBJECT r_rental EXPORTING im_name = 'HAPPY CAR RENTAL'.

******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'MAN'
                                  im_cargo = 45.
******* create truck *****************************************
  CREATE OBJECT r_bus EXPORTING im_make = 'Mercedes'
                                im_passengers = 80.

******* create truck *****************************************
  CREATE OBJECT r_truck EXPORTING im_make = 'VOLVO'
                                  im_cargo = 48.

***** Create CARRIER ********************************************
  CREATE OBJECT r_carrier EXPORTING im_name = 'Smile&Fly-Travel'.

***** Passenger Plane ********************************************
  CREATE OBJECT r_passenger EXPORTING
                         im_name = 'LH BERLIN'
                         im_planetype = '747-400'
                         im_seats = 345.
***** cargo Plane ************************************************
  CREATE OBJECT r_cargo EXPORTING
                         im_name = 'US Hercules'
                         im_planetype = '747-500'
                         im_cargo = 533.

******* show attributes of all partners of travel_agency ******
  r_agency->display_agency_partners( ).
