*&---------------------------------------------------------------------*
*& Report  SAPBC401_CASS_MAIN_B                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&  carrier adds airplanes to its airplane_list --> polymorphism       *
*&---------------------------------------------------------------------*

REPORT  sapbc401_cass_main_b.

TYPE-POOLS icon.

INCLUDE sapbc401_cass_b.


DATA: r_plane TYPE REF TO lcl_airplane,
      r_cargo TYPE REF TO lcl_cargo_plane,
      r_passenger TYPE REF TO lcl_passenger_plane,
      r_carrier TYPE REF TO lcl_carrier.


START-OF-SELECTION.
*##############################

***** Create Carrier ********************************************
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

***** insert planes into itab if client ***************************
  r_carrier->add_airplane( r_passenger ).

  r_carrier->add_airplane( r_cargo ).


***** show all airplanes inside carrier ***************************
  r_carrier->display_attributes( ).
