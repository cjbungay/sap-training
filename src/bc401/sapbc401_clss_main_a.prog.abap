*&---------------------------------------------------------------------*
*& Report  SAPBC401_CLSS_MAIN_A                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&    Global Class lcl_hotel is also a business partner of the         *
*&    travel agency                                                    *
*&---------------------------------------------------------------------*

REPORT  sapbc401_clss_main_a.

TYPE-POOLS icon.

INCLUDE sapbc401_vehd_j.
INCLUDE sapbc401_clss_a.

DATA: r_vehicle TYPE REF TO lcl_vehicle,
      r_truck TYPE REF TO lcl_truck,
      r_bus   TYPE REF TO lcl_bus,
      r_passenger TYPE REF TO lcl_passenger_plane,
      r_cargo TYPE REF TO lcl_cargo_plane,
      r_carrier TYPE REF TO lcl_carrier,
      r_rental TYPE REF TO lcl_rental,
      r_agency TYPE REF TO lcl_travel_agency,
      r_hotel TYPE REF TO cl_hotel.


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
  CREATE OBJECT r_carrier EXPORTING im_name = 'Smile&Fly Travel'.

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

******* create hotel *****************************************
  CREATE OBJECT r_hotel EXPORTING im_name = 'Holiday Inn'
                                  im_beds = 345.

******* show attributes of all partners of travel_agency ******
  r_agency->display_agency_partners( ).
