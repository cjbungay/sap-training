*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYNS_RTTS_1                                        *
*&---------------------------------------------------------------------*
*&  use RTTI to determine CARGO PLanes                                 *
*&  and compute highest cargo value                                    *
*&---------------------------------------------------------------------*

REPORT SAPBC401_DYNS_RTTS_1.

TYPE-POOLS icon.

INCLUDE SAPBC401_DYNS_C1.
*INCLUDE sapbc401_cass_c.

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
  r_carrier->add_airplane( r_passenger ).

***** cargo Plane 1 **********************************************
  CREATE OBJECT r_cargo EXPORTING
                         im_name = 'US Hercules'
                         im_planetype = '747-500'
                         im_cargo = 533.
  r_carrier->add_airplane( r_cargo ).

***** cargo Plane 2 *********************************************
  CREATE OBJECT r_cargo EXPORTING
                         im_name = 'US Navy 1'
                         im_planetype = '747-400'
                         im_cargo = 460.
  r_carrier->add_airplane( r_cargo ).

***** cargo Plane 2 *********************************************
  CREATE OBJECT r_cargo EXPORTING
                         im_name = 'US Navy 2'
                         im_planetype = '747-500'
                         im_cargo = 560.
  r_carrier->add_airplane( r_cargo ).

***** Passenger Plane ********************************************
  CREATE OBJECT r_passenger EXPORTING
                         im_name = 'AA Chicago'
                         im_planetype = '747-400'
                         im_seats = 420.
  r_carrier->add_airplane( r_passenger ).


***** show all airplanes inside carrier ***************************
  r_carrier->display_attributes( ).
